#ifndef _UART_MODULE

#define _UART_MODULE 1

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

void sendUart(char* ptr, unsigned char size);
char* getUart(void);
void initUart(void);
char checkUart(void);
char clearUart(void);

#endif