var Service = useRoot("/System/Service.js");
useModule("utils.js");


function CncController(params){
    var devicePort = 'COM4'
    self = this;
    self.state = {
        x: '',
        y: '',
        z: '',
        temperature: ''
    };
    this.connect("SerialService").then(function(service){
        SerialService = service;
        SerialService.OpenPort(devicePort, {baudRate: 115200}).then(function(portName){
            
            SerialService.on("serial-string-" + devicePort, function(data){
                switch (data[6]) {
                    case 'T':
                        var i = 8;
                        var temperature = '';
                        while(data[i] != ' '){
                            temperature = temperature + data[i];
                            i++;
                        };
                        self.state.temperature = temperature;
                        self.emit('state', self.state);
                        console.log('state: ', self.state);
                        break;
                    case 'X':
                        // code
                        break;
                    
                    default:
                        // code
                }
            });
            console.log('cnc was connected on '+ portName);
            self.emit('cnc connected', portName);
            
        }).catch(function(error){
            console.log(error);
        });
    }).catch(function(error){
        console.log(error);
    });
    
    this.once('cnc connected', function(portName){
        self.getCoords(portName);
        setInterval(function() {
            self.getTemperature(portName);
        }, 2000);
    });
    
    return Service.call(this, "CncController");
}

CncController.serviceId = "CncController";

Inherit(CncController, Service, {
    send: function(devicePort, command){
        SerialService.Send(devicePort, command, 'ascii').then(function(){
            console.log('command '+ command + ' was sent');
        }).catch(function(error){
            console.log(error);
        });    
    },
    
    getTemperature: function(devicePort, command = 'M105\n'){
        self.send(devicePort, command);
    },
    
    getCoords:function(devicePort, command = 'M114\n'){
        self.send(devicePort, command);
    }
    
});

module.exports = CncController;