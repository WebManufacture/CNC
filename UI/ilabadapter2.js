Compilers = {};

function RegisterCompiler(type, compiler){
	Compilers[type] = compiler;
}
var CNC = {};

CNC.Commands = ["unknown", "go", "rebase", "stop", "info", "move", "pause", "resume","spindle1", "spindle2"];
CNC.CommandsShort = ['N', 'G', 'B', 'S', 'I', 'M', 'P', 'R', 'S1', 'S2'];
CNC.GCommands = { "G": 1, "S": 3, "B": 2, "I": 4, "M" : 5, "P": 6, 'R': 7, 'X' : 1, 'Y': 1, 'Z': 1, "S1" : 8, "S2" : 9};
CNC.QPrograms = {};

CNC.CommandType =
	{
	unknown: 0,
	go: 1,
	rebase: 2,
	stop: 3,
	state: 4,
	move: 5,
	pause: 6,
	resume: 7,
    spindle1: 8,
    spindle2: 9,
	error: 16
}

CNC.ProgramState =
	{
	NotStarted: 0,
	Running: 1,
	Paused: 2,
	Completed: 3,
	Aborted: 4
}

function CncController(name, connector){
	this.Name = name;
	this.configStorage = Net.GetTunnel("storage/configs/" + name + "/");
	this._super();
}

Inherit(CncController, EventEmitter,{
	Init : function (settings) {
	    var self = this;
	    var service = this.Device = {};
	    ServiceProxy.Connect("ws://localhost:5700/CncService").then(function(s){
            service = s;
            service.GetMotorState().then(function(message){
                Channels.emit("device.connected", message);
            }).catch(function(error){
                console.log('Something wrong with calling service.GetMotorState')
            })
        }).catch(function(error){
            console.log('cannot connect to the service');
        });
        
        service.once("state", function(message){
		    Channels.emit("device.ready", message);
		});
        service.on("state", self.StateReturned);
		service.on("connect", self.GetCncState);
	    
	   /* 
		var ws = this.Device = new WebSocketProvider(settings, function(message){
		    Channels.emit("device.connected", message);
		});
		ws.once("state",function(message){
		    Channels.emit("device.ready", message);
		});
		*/
		//ws.on("state", CreateClosure(this.StateReturned, this));
		//ws.on("connect", CreateClosure(this.GetCncState, this));
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
	},

	GetCncState : function () {
		this.Device.sendCommand({command: 4}).then(function(){
            console.log('{command: 4} was sent')
        }).catch(function(error){
            console.log('Something wrong with sending command')
        });
	},

	StateReturned : function (event,message) {
		if (!message) return;
		if (typeof message == "string"){
			message = JSON.parse(message);
		}
		lx = message.x;
		ly = message.y;
		lz = message.z;

		message.line = parseInt(message.line);
		this.do("state", message);

		this.LastState = message;
		this.X = message.x;
		this.Y = message.y;
		this.Z = message.z;
		this.stateA = message.stateA;
		this.stateB = message.stateB;

		Channels.emit("device.state", message);

        if (this.program && message.state == 2 && message.line > 0){
            console.log("IN>" + message.line);
            console.log(message);
            this.nextCommand(message.line);
        }

		this.state = parseInt(message.state);
	},

	Command : function (str, callback) {
		this.Device.sendCommand(str).then(function(){
            console.log(str + ' was sent')
        }).catch(function(error){
            console.log('Something wrong with sending command')
        });
	},

	ProgCommand : function (str, callback) {
		if (typeof (str) == "strinssendCommand") {
			str = CNC.CommandType[str.toLowerCase()];
			this.Device.sendCommand({command: str}).then(function(){
                console.log('{command:' + str + 'was sent');
            }).catch(function(error){
                console.log('Something wrong with sending command')
            });;
		}
	},

	SendProgram : function (cmds) {
		if (cmds && cmds.length > 0){
		    this.program = cmds;
		    var line = 1;
		    this.program.each(function(obj){
		        obj.line = line++;
		    });
		    this.nextCommand(0);
		}
	},
	
	nextCommand : function(line){
	    if (this.program && line < this.program.length){
	        var command = this.program[line];
	        console.log("OUT<" + line);
            console.log(command);
		    this.Device.sendCommand(command).then(function(){
                console.log(command + ' was sent')
            }).catch(function(error){
                console.log('Something wrong with sending command')
            });;
	    }
	},

	Go : function (x, y, z) {
		this.Command({ command: 1, x: x, y: y, z: z, speed: this.Settings.speed });
	},


	Move : function (x, y, z) {
		this.Command({ command: 5, x: x, y: y, z: z, speed: this.Settings.speed });
	},


	Rebase : function (x, y, z) {
		this.Command({ command: 2, x: x, y: y, z: z, speed: 0 });
	},
	
	QuickCommand : function (txt) {
		txt = CncCompiler.Compile(this.Settings, txt, { x: lx, y : ly, z: lz, speed : this.Settings.speed });
		if (txt && txt.length > 0){
			this.Command(txt[0]);
		}
	},


	LoadSettings : function(callback){
		var cnc = this;
		this.configStorage.get("cnc.json?rnd=" + Math.random(), function(result){
			if (result){
				cnc.Settings = result;
				callback(result);
			}
		});	
	},

	SaveSettings :function(settings){
		this.configStorage.POST("cnc.json", JSON.stringify(settings), function(result){

		});	
	},
});
