#ifndef _COMMANDS_MODULE

#define _COMMANDS_MODULE 1
#define COMMAND_BUFFER_LENGTH 40


struct TablePosition{
	unsigned int currentSpeed;	
	unsigned int maxSpeed;	
	unsigned long line;	
	unsigned char command;
	unsigned char state;
	unsigned char waitingMaskA;
	unsigned char waitingMaskB;
};

typedef @near struct InUartCommand *InCommandPtr;
void initCommands(void);
void idleCommand(void);
void processCommand(InCommandPtr command);
void setState(char state);

void pause(void);
void error(void);
void resume(void);
void stop(void);

#endif
