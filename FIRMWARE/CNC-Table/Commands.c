#include "DeviceConfig.h"
#include "Uart.h"
#include "Motors.h"
#include "Utils.h"

typedef void (*commandFunc)(InCommandPtr cmd);
extern struct SMotorState mX, mY, mZ;

const commandFunc commands[];

volatile struct {
	unsigned long X;
	unsigned long Y;
	unsigned long Z;
	unsigned long W;
	unsigned char settingsA;
	unsigned char settingsB;
} config @0x4000;

volatile struct Digits settingsA @0x4010;

char stateSended = 0;
char ticks;
char currentCommand = 0;

@near struct InUartCommand Buffer[COMMAND_BUFFER_LENGTH];
@near struct OutUartCommand OutCommand;

struct TablePosition current, storage;

void push(void){
	storage.command = current.command;
	storage.maxSpeed = current.maxSpeed;
	storage.currentSpeed = current.currentSpeed;
	storage.line = current.line;
	storage.state = current.state;
	storage.waitingMaskA = current.waitingMaskA;
	storage.waitingMaskB = current.waitingMaskB;
}

void pop(void){
	current.maxSpeed     = storage.maxSpeed;
	current.currentSpeed = storage.currentSpeed;
	current.command =      storage.command;
	current.line =         storage.line;
	current.state =        storage.state;
	current.waitingMaskA = storage.waitingMaskA;
	current.waitingMaskB = storage.waitingMaskB;
}        


void sendTable(char command){
	OutCommand.address = 06;//Adress
	OutCommand.command = command;
	OutCommand.X = mX.Steps;
	OutCommand.Y = mY.Steps;
	OutCommand.Z = mZ.Steps;
	OutCommand.XL = mX.Limit;
	OutCommand.YL = mY.Limit;
	OutCommand.ZL = mZ.Limit;
	OutCommand.state = current.state;
	OutCommand.line = current.line;
	OutCommand.paramA = PA_IDR;
	OutCommand.paramB = PB_IDR;
	sendUart((char*)(&OutCommand), sizeof(OutCommand));
}


void sendState(char command, char state, char line, char A, char B){
	OutCommand.address = 06;//Adress
	OutCommand.command = command;
	OutCommand.X = mX.Steps;
	OutCommand.Y = mY.Steps;
	OutCommand.Z = mZ.Steps;
	OutCommand.XL = mX.Limit;
	OutCommand.YL = mY.Limit;
	OutCommand.ZL = mZ.Limit;
	OutCommand.state = state;
	OutCommand.line = line;
	OutCommand.paramA = A;
	OutCommand.paramB = B;
	sendUart((char*)(&OutCommand), sizeof(OutCommand));
}


void initCommands(void){
	current.state = 9;
	current.line = RST_ST;
	current.currentSpeed = 0;
	current.maxSpeed = 0;

  sendTable(0);
	
	current.state = 0;
	current.line = 0;
}


void setState(char state){
	current.state = state;
	stateSended = 0;
}



void idleCommand(void){
	if (current.state == 1 && ticks > 50){
		ticks = 0;
		sendTable(current.command);
	}
	if (stateSended == 0){
		sendTable(current.command);
		if (current.state == 2){
			current.state = 0;
			current.waitingMaskA = 0;
			current.waitingMaskB = 0;
		}
		stateSended = 1;
	}
}

void processCommand(InCommandPtr command){
	current.command = command->command;
	current.line = command->line;
	commands[current.command](command);
	return;
}

void pause(void){
	if (current.state == 1){
		motor_stop();
	}
	LEDS_OFF
	LED_RED_ON
	LED_GREEN_ON
	setState(3);
}

void error(void){
	if (current.state == 1){
		motor_stop();
	}
	LEDS_OFF
	LED_RED_ON
	setState(4);
}

void resume(void){
	if (current.state > 1){
		motor_start(current.currentSpeed);
		setState(1);
	}
}

void stop(void){
	motor_stop();
	setState(0);
}


void StopCommand(InCommandPtr cmd){		//3
	stop();
}

void StateCommand(InCommandPtr cmd){ //4
	sendTable(current.command);
}

void WaitMaskCommand(InCommandPtr cmd){ //10
	sendTable(current.command);
	current.state = 2;
}

void PauseCommand(InCommandPtr cmd) {//6
	pause();
	sendTable(current.command);
}
	
void ResumeCommand(InCommandPtr cmd) {//7
	resume();
	sendTable(current.command);
}	
		
void InternalCommand(InCommandPtr cmd) {//11
}

void ResetCommand(InCommandPtr cmd) {//12
	Reset();
}

void SpindleCommand(InCommandPtr cmd){//8, 9
	PC_ODR = cmd->paramA;
}
	
void MoveCommand(InCommandPtr cmd){ // 1, 5
	if (cmd->command == 5){
		 cmd->x = cmd->x + mX.Steps;
		 cmd->y = cmd->y + mY.Steps;
		 cmd->z = cmd->z + mZ.Steps;
	}	
	if (cmd->x == mX.Steps && cmd->y == mY.Steps && cmd->z == mZ.Steps)
	{				
		motor_stop();
		current.line = cmd->line;
		setState(2);
		return;
	}
	motor_stop();
	current.waitingMaskA = cmd->paramA;
	current.waitingMaskB = cmd->paramB;
	current.line = cmd->line;
	current.maxSpeed = cmd->speed;
	loadCommand(cmd);
	if (!CheckBtns()){
		setState(3);
		return;
	}
	if (!CheckEnds()){
		setState(4);
		return;
	}
	ticks = 0;
	setState(1);
	motor_start(current.currentSpeed);
	return;
}
	
void RebaseCommand(InCommandPtr cmd){ //2
	mX.Steps = cmd->x;		
	mY.Steps = cmd->y;	
	mZ.Steps = cmd->z;
	mX.Limit = 0;		
	mY.Limit = 0;	
	mZ.Limit = 0;	
	mX.Dir = 0;
	mY.Dir = 0;
	mZ.Dir = 0;
	mX.Delta = 0;
	mY.Delta = 0;
	mZ.Delta = 0;	
	return;
}

void ConfigCommand(InCommandPtr cmd){ //13
	unsigned char dataState;
	if (cmd->speed = 1){
		OutCommand.address = 06;//Adress
		OutCommand.command = 12;
		OutCommand.X = config.X;
		OutCommand.Y = config.Y;
		OutCommand.Z = config.Z;
		OutCommand.XL = 0;
		OutCommand.YL = 0;
		OutCommand.ZL = 0;
		OutCommand.state = 1;
		OutCommand.line = current.line;
		OutCommand.paramA = config.settingsA;
		OutCommand.paramB = config.settingsB;
		sendUart((char*)(&OutCommand), sizeof(OutCommand));
	}
	if (cmd->speed = 2){
		dataState = FLASH_IAPSR;
		dataState &= bit3;
		if (dataState == 0){
			FLASH_DUKR = 0xAE;
			FLASH_DUKR = 0x56;
		}
		config.X = cmd->x;
		config.Y = cmd->y;
		config.Z = cmd->z;
		config.settingsA = cmd->paramA;
		config.settingsB = cmd->paramB;
	}
	return;
}	


void BufferFlush(InCommandPtr cmd){ //13
	currentCommand = 0;
	return;
}	

const commandFunc commands[20] = {
	StateCommand,//0
	MoveCommand,//1
	RebaseCommand,//2
	StopCommand, //3
	StateCommand, //4
	MoveCommand,//5
	PauseCommand,//6
	ResumeCommand,//7
	SpindleCommand,//8
	SpindleCommand,//9
	WaitMaskCommand,//10
	ConfigCommand,//11
	ResetCommand,//12
	BufferFlush,//13
	NULL,//14
	NULL,//15
	NULL,//16
	NULL,//17
	NULL,//18
	NULL //19
};

/*

void pause(void){
	if (TablePositiom.state == 1){
		TablePositiom.state = 3;
	}
	TablePositiom.state = 0;
}

void error(void){
	TablePositiom.state = 4;
}

void resume(void){
	if (TablePositiom.state == 3){
		TablePositiom.state = 1;
	}
}

void stop(void){
	if (TablePositiom.state == 3){
		TablePositiom.state = 1;
	}
}

		//13 - flushBuffer
		//14 - nextBuffer
		//15 - buffer empty
		//16 - buffer full

void processCommand(InCommandPtr command){
	if (command.line == 0){
		push();
		current.command = command.command;
		current.line = 0;
		commands[current.command](&command);
		return;
	}
	if (currentCommand < sizeof(Buffer)){
		Buffer[currentCommand] = *command;
		currentCommand++;
	}
	else{
		sendState(16,command->command,command->line, 0,0);
	}
}

char nextCommand(void){
	char i;
	if (currentCommand > 0){
		currentCommand--;
		sendState(14,current.state, current.line, PA_IDR, PB_IDR);
		current.command = Buffer[0].command;
		current.line = Buffer[0].line;
		commands[current.command](&Buffer[0]);
		for (i = 0; i < COMMAND_BUFFER_LENGTH - 1; i++){
			Buffer[i] = Buffer[i+1];
		}
		return 1;
	}
	sendState(15,current.state, current.line, PA_IDR, PB_IDR);
	return 0;
}
*/
