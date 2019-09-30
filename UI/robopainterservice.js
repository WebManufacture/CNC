/*
function SendPacket(arr){
    if (arr.length != 24) {return false};
    var packet = [];
    packet[0] = 1;
    packet[1] = arr.length;
    packet[2] = 3;
    packet[3] = 0;
    packet[4] = 47;
    packet[5] = 0;
    packet = packet.concat(arr);
    for (var i = 0; i < arr.length; i++){
        crc ^= arr[i]; 
    }
    packet.push(crc);
    packet.push(3);
    //write to port
};
*/

MotorPacket = function(command, address){
	if (address == undefined) address = 0;
	this.address = address;
	this.command = command;
	this.x = 0;
	this.y = 0;
	this.z = 0;
	this.line = 0;
	this.speed = 0;
	this.out = {
	    C : 0,
	    M : 0,
	    Y : 0,
	    K : 0
	};
	this.stateA = 0;
	this.stateB = 0;
}


MotorPacket.FromBuffer = function(data){
	//if (data.length == 17){
		var obj = new MotorPacket(data[0]);
		obj.x = loadValue(data, 1);
		obj.y = loadValue(data, 5);
		obj.z = loadValue(data, 9);
		obj.line = loadValue(data, 13);
		obj.speed = data[17];
		obj.state = data[18];
		obj.stateA = data[19];
		obj.stateB = data[20];
        obj.date = new Date();
        return obj;
//	}
//	return null;
}

MotorPacket.prototype.serialize = function(){
	var bytes = [];
	bytes[0] = this.command;
	saveInt(bytes, 1, this.x);
	saveInt(bytes, 5, this.y);
	saveInt(bytes, 9, this.z);
	saveInt(bytes, 13, this.line);
	bytes[17] = this.speed;
	bytes[18] = this.out.C;
	bytes[19] = this.out.M;
	bytes[20] = this.out.Y;
	bytes[21] = this.out.K;
	bytes[22] = this.paramA;
	bytes[23] = this.paramB;
	return bytes;
}




function RoboPainterDevice(service){
    this.service = service;
    EventEmitter.apply(this, arguments)
}

Inherit(RoboPainterDevice, EventEmitter, {
    sendCommand: function(obj){
        var packet = new MotorPacket(obj.command);
        if (obj.x != undefined) packet.x = obj.x;
        if (obj.y != undefined) packet.y = obj.y;
        if (obj.z != undefined) packet.z = obj.z;
        if (obj.speed != undefined) packet.speed = obj.speed;
        if (obj.line != undefined) packet.line = obj.line;
        this.send(packet);
    },
    
    send: function(packet){
        this.sendBuffer(packet.serialize());
    },
    
    sendBuffer : function(arr){
        if (arr.length != 24) {return false};
        var packet = [];
        packet[0] = 1;
        packet[1] = arr.length;
        packet[2] = 3;
        packet[3] = 0;
        packet[4] = 47;
        packet[5] = 0;
        packet = packet.concat(arr);
        var crc = 222;
        for (var i = 0; i < arr.length; i++){
            crc ^= arr[i]; 
        }
        packet.push(crc);
        packet.push(3);
        this.service.Write("COM4", packet).then(function(){}).catch(function(error){
            console.error(error);
        });
    },
    packetReadingState : 'free',
    onReceiveByte : function(data){
        switch (this.packetReadingState){
            case 'free':
                if (data != 1){
                    console.log('error data');
                }else{
                    this.packetReadingState = 'sizeWaiting';
                    crc = 222;
                };
            break;
            case 'sizeWaiting':
                if (data <= 0){
                    this.packetReadingState = 'free';
                }else{
                    receivingBuf = [];
                    receivingBuf.length = data;
                    this.packetReadingState = 'addrReading';
                    addrCount = 0;
                    readingIndex = 0;
                };
            break;
            case 'addrReading':
                addrCount++;
                if (addrCount == 4) {
                    this.packetReadingState = 'dataReading';
                    
                };
            break;
            case 'dataReading':
                receivingBuf[readingIndex] = data;
                crc ^= data;
                readingIndex++;
                if (readingIndex >= receivingBuf.length) {this.packetReadingState = 'crcCheck'};
            break;
            case 'crcCheck':
                if (data == crc){
                    this.packetReadingState = 'finishCheck'
                }else{
                    console.log('crc check error!');
                    this.packetReadingState = 'free';
                };
            break;
            case 'finishCheck':
                this.packetReadingState = 'free';
                if (data == 3){
                    var packet = MotorPacket.FromBuffer(receivingBuf);
                    packet.xLimit = packet.x;
                    packet.yLimit = packet.y;
                    packet.zLimit = packet.z;
                    this.emit("state", packet);
                    Channels.emit("device.state", packet);
                    console.log(packet);
                }else{
                    console.log('Incorrect finishing byte!');
                };
            break;
        }
    }
})


CncController.prototype.Init = function (settings) {
        var self = this;
        
		this.Device = new RoboPainterDevice();
		
	    ServiceProxy.Connect(settings.LocalUrl + "/SerialService", {}).then(function(service){
            service.OpenPort("COM4").then(function(){
                self.Device.service = service;
                Channels.emit("device.connected", {});
                
                self.Device.send(new MotorPacket(4));
                
                
                
            }).catch(function(error){
               console.error(error);
            });
            
            service.on("serial-data", function (event, portName, data) {
                data = data.data;
                for ( var i = 0; i < data.length; i++){
                    self.Device.onReceiveByte(data[i]);
                };
            });
        }).catch(function(error){
            console.error(error);
        });
	    
	    this.Device.once("state",function(message){
		    Channels.emit("device.ready", message);
		});
	    this.Device.on("state", CreateClosure(this.StateReturned, this));
		this.Device.on("connect", CreateClosure(this.GetCncState, this));
		
		if (!settings) return;
		L.debug = true;
		this.log = L.Log;
		this.id = settings.id;
		this.Settings = settings;
		this.startDate = new Date();
		lx = 0;
		ly = 0;
		lz = 0;
		this.ProgramRunned = false;
		this.DebugMode = false;
		this.ProgramCode;
	};