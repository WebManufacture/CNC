#include "DeviceConfig.h"
#include "uart.h"
#include "motors.h"
#include "commands.h"
#include "utils.h"
//extern unsigned char uart_read_buf

void init(void){	
	CLK_CKDIVR = 0;
	
	
	//LEDS
	PG.DDR = 03;
	PG.CR1 = 03;
	PG.CR2 = 0;
	PG.Out = 03;
	
	PE.DDR = bit0;
  PE.CR1 = bit0;
	PE.CR2 = 0;
	PE.Out = bit0;
	//
		
	initMotors();
	initUart();
	initCommands();
	
	_asm("rim");
}

void main(void){	 
  InCommandPtr command;
	init();
	LEDS_OFF
	LED_RED_ON
	LED_BLUE_ON
	Delay(600000);
	LEDS_OFF
	while(1){
		if (checkUart()){
			command = (InCommandPtr)(getUart());
			processCommand(command);
			clearUart();
		} 
		idleCommand();
	}
}


