
var Service = useRoot("/System/Service.js");
var http = useSystem("http");
useModule("utils.js");

function CNCProgramService(params){
    var self = this;
    self.homing = false;
    this.units = 0;


    this.connectCNC = function(port, baudRate){
        this.connect("SerialService").then(function (service) {

            self.SerialService = service;

            self.SerialService.OpenPort(port, {baudRate: baudRate}).then(function () {
                self.port = port;
                self.baudRate = baudRate;

                self.SerialService.on("serial-string-" + port, function(data){
                    console.log('19'+data);
                    if ((data.indexOf('Reset')>-1) && (self.homing)){
                        self.reset(self);
                        self.homing = false;
                    };

                    if (data.indexOf('to unlock')>-1){
                        self.SerialService.Send(self.port, '$X\n', 'ascii').then(function(){
                            console.log('cnc was unlocked');
                        }).catch(function(error){
                            console.log('command was not sent');
                            console.log(error);
                        });
                    };

                });
                self.emit('cnc connected', port);

            }).catch(function (error) {console.log(error)})


        }).catch(function (error) {console.log(error)});

    };

    this.doProgram = function(program){
        program.forEach(function(item, i, arr){
            this.sendCommand(command);
        });

    }





    return Service.call(this, "CNCProgramService");
}

CNCProgramService.serviceId = "CNCProgramService";

Inherit(CNCProgramService, Service, {



    sendCommand: function (command) {
        console.log(command);
        self.SerialService.Send(self.port, command, 'ascii').then(function(){
            console.log('command was sent');
        }).catch(function(error){
            console.log('command was not sent');
            console.log(error);
        });

    }

});

module.exports = CNCProgramService;


