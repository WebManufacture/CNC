

#ifndef _COMMANDS_MODULE
#define _COMMANDS_MODULE 1


#define COMMAND_BUFFER_LENGTH 2

struct OutUartCommand{
	char address;
	char command;
	char state;
	unsigned long line;
	unsigned long X;	
	unsigned long Y;	
	unsigned long Z;	
	unsigned long XL;	
	unsigned long YL;	
	unsigned long ZL;	
	char paramA;
	char paramB;
};

struct InUartCommand {
	char address;
	char command;
	unsigned short speed;
	unsigned long line;
	signed long x;
	signed long y;	
	signed long z;	
	char paramA;
	char paramB;
}; 

typedef @near struct InUartCommand* InCommandPtr;

struct TablePosition{
	unsigned int currentSpeed;	
	unsigned int maxSpeed;	
	unsigned long line;	
	unsigned char command;
	unsigned char state;
	unsigned char waitingMaskA;
	unsigned char waitingMaskB;
};

void moving_finished(void);
void initCommands(void);
void idleCommand(void);
void processCommand(InCommandPtr command);
void setState(char state);

void pause(void);
void error(void);
void resume(void);
void stop(void);

#endif
