#ifndef _MOTORS_MODULE

#define _MOTORS_MODULE 1

#include "Commands.h"

#define MinSpeed 30000
#define SpeedInc 1000


struct SMotorState{
	signed long Steps;
	signed long Limit;
	signed long Error;
	signed long Delta;	
	signed char Dir;
	unsigned int speed1;
	unsigned int speed2;
	unsigned char coef;
	signed int counter;
	unsigned char phase;
	unsigned char mask;
	unsigned char stopMask;
	unsigned char phases[8];
	unsigned char *out;
	struct Port *port;
};

void initMotors(void);
void motor_stop(void);
void motor_start(unsigned int bspeed);
void setSpeed(unsigned int bspeed);
void loadCommand(InCommandPtr cmd);
char CheckEnds(void);
char CheckBtns(void);

#endif