function saveInt(arr, index, value)
{
	arr[index] =  (value >> 24);
	arr[index + 1] = (value >> 16);
	arr[index + 2] = (value >> 8);
	arr[index + 3] = (value);
	return Math.round(value);
}

function loadValue(arr, index)
{
	return Math.round(arr[index] * 16777216 + arr[index + 1] * 65536 + arr[index + 2] * 256 + arr[index + 3]);
}

MotorPacket = function(command, address){
	if (address == undefined) address = 0;
	this.address = address;
	this.command = command;
	this.line = 0;
	this.x = 0;
	this.y = 0;
	this.z = 0;
	this.speed = 0;
}


MotorPacket.FromBuffer = function(data){
	if (data == null) return null;
	if (data.length >= 32)
	{
		var obj = new MotorPacket(data[0]);
		obj.date = new Date();
		obj.state = data[1];
		obj.line = loadValue(data, 2);
		obj.x = loadValue(data, 6);
		obj.y = loadValue(data, 10);
		obj.z = loadValue(data, 14);
		obj.xLimit = loadValue(data, 18);
		obj.yLimit = loadValue(data, 22);
		obj.zLimit = loadValue(data, 26);
		obj.stateA = data[30];
		obj.stateB = data[31];
		return obj;
	}
	return null;
}

MotorPacket.prototype.serialize = function(){
	var bytes = [];
	bytes[0] = this.command;
	bytes[1] = Math.floor(this.speed / 256);
	bytes[2] = Math.round(this.speed - bytes[1]*256);
	saveInt(bytes, 3, this.line);
	saveInt(bytes, 7, this.x);
	saveInt(bytes, 11, this.y);
	saveInt(bytes, 15, this.z);
	if (this.address) bytes.unshift(this.address);
	return bytes;
}

global.Commands = global.CommandType =
{
    Null: 0,
    Go: 1,
    Rebase: 2,
    Stop: 3,
    State: 0,
    Move: 5,
    Pause: 6,
    Resume: 7,
    Spindle1: 8,
    Spindle2: 9,
    Error: 16
}

global.Symbols = ['N', 'G', 'B', 'S', 'I', 'M', 'P', 'R','S','S'];
Symbols[16] = 'E';

CncProgramState =
{
    NotStarted: 0,
    Running: 1,
    Paused: 2,
    Completed: 3,
    Aborted: 4
}

CncProgram = function (commands) {
    this.CurrentLine = 0;
    this.Commands = commands;
    this._state = CncProgramState.NotStarted;
	program = this;
	var messageFunc = function(message, obj){
		program.OnMessage(obj);	
	}
	this.close = function(){
		Channels.clear("uart.device", messageFunc);
	}
	Channels.on("uart.device", messageFunc);
	this.send = function(command){
		Channels.emit("uart.output", command);	
	}
}

CncProgram.prototype =
{
    _state: CncProgramState.NotStarted,

    Exists: function () {
        return this.Commands.length > 0;
    },

    InProgress: function () {
        return _state > CncProgramState.NotStarted && _state < CncProgramState.Completed;
    },

    Commands: [],
    CurrentLine: 0,
    DebugMode: false,

    Stop: function () {
        this._state = CncProgramState.Aborted;
		log("CNC Stop");
    },

    Start: function () {
        this.CurrentLine = 1;
		this._state = CncProgramState.Running;
		this.Send(this.CurrentLine);
		log("CNC Start");
    },

    Pause: function (obj) {
        if (this._state < CncProgramState.Completed) {
            this._state = CncProgramState.Paused;
			var command = this.Commands[obj.line];
			if (command && command.sended){
				command.sended = false;
			}
        }
    },

    Resume: function (obj) {
        if (this._state < CncProgramState.Completed) {
            this._state = CncProgramState.Running;
			var command = this.Commands[obj.line];
			if (command && command.sended){
				command.sended = false;
			}
        }
    },

	OnMessage : function(obj){
		if (obj.command == 3) {
            this.Stop();
			this.close();
            return;
        }
		if (obj.command == 6) {
			this.Pause(obj);
			return;
		}
		if (obj.command == 7) {
			this.Resume(obj);
			return;
		}
		if (this.Exists && this.InProgress && obj.line > 0) {
			if (obj.command == 1 || obj.command == 5) {
				if (obj.state == 1) {
					var command = this.Commands[obj.line - 1];
					command.line = obj.line;
					this.CurrentLine = obj.line;
					this.Send(obj.line + 1);
				}
				if (obj.state == 2 || obj.state == 3) {
					if (this._state == CncProgramState.Running && obj.line == this.Commands.length - 1) {
						log("Program complete");
						this._state = CncProgramState.Completed;
						return;
					}
					var command = this.Commands[obj.line - 1];
					command.line = obj.line;
					command.completed = true;
					if (obj.state == 2){
						this.Send(obj.line + 1);
					}
				}
				if (obj.state == 4) {
					this.Stop();
				}
			}
			else{
				if (this._state == CncProgramState.Running && obj.line == this.Commands.length - 1) {
					log("Program complete");
					this._state = CncProgramState.Completed;
					return;
				}
				var command = this.Commands[obj.line - 1];
				command.line = obj.line;
				command.completed = true;
				this.Send(obj.line + 1);
			}
		}
	},
	
    Send: function (line) {
        if (this._state > CncProgramState.Running) {
            return false;
        }
		if (line > 0 && line <= this.Commands.length){
            var command = this.Commands[line - 1];
            command.line = line;
			if (!command.sended && !command.completed){
				if (command.command == CommandType.Pause) {
					Pause();
					return true;
				}
				if (command.command == CommandType.Resume) {
					Resume();
				}			
				this.send(command);
			}
            return true;
        }        
        return false;
    },
}

module.exports = CncProgram

