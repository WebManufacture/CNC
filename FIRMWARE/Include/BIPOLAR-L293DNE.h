#include "STM8S.h"

char phase = 8;
char phases[8];
char dir = 1;
int steps = 0;

void FullStep(void){
	phases[0] = 0b10000000;
	phases[1] = 0b10100000;
	phases[2] = 0b00100000;
	phases[3] = 0b01100000;
	phases[4] = 0b01000000;
	phases[5] = 0b01010000;
	phases[6] = 0b00010000;
	phases[7] = 0b10010000;/*
	phases[0] = 0b00001000;
	phases[1] = 0b00001010;
	phases[2] = 0b00000010;
	phases[3] = 0b00000110;
	phases[4] = 0b00000100;
	phases[5] = 0b00000101;
	phases[6] = 0b00000001;
	phases[7] = 0b00001001;*/
}              

void PowStep(void){
	phases[0] = 0b10100000;
	phases[1] = 0b10100000;
	phases[2] = 0b01100000;
	phases[3] = 0b01100000;
	phases[4] = 0b01010000;
	phases[5] = 0b01010000;
	phases[6] = 0b10010000;
	phases[7] = 0b10010000;
	    /*          
	phases[0] = 0b00001010;
	phases[1] = 0b00001010;
	phases[2] = 0b00000110;
	phases[3] = 0b00000110;
	phases[4] = 0b00000101;
	phases[5] = 0b00000101;
	phases[6] = 0b00001001;
	phases[7] = 0b00001001;*/ 
}              

void Stop(void){
	TIM2->CR1 &= 254; //START
}

void GoForward(void){
	dir = 1;
	TIM2->CR1 |= 1; //START
}

void GoBack(void){
	dir = 0;
	TIM2->CR1 |= 1; //START
}

void InitMotor(void)
{
	PowStep();
	
	GPIOC->DDR |= 0b11111110;
	
	TIM2->CR1 |= 0x80;      //Разрешаем буферизацию ARR
	TIM2->IER =  1;                   //Update overflow and Capture/Compare 1
	TIM2->PSCR = 2;       //Предделитель 16000000 / 1 = 16000000 Hz
	TIM2->ARRH = 60;
	TIM2->ARRL = 10;
}

@interrupt void TIM2_OVF(void){
	_asm("SIM");
	TIM2->SR1 &= 254;
	if (phase < 1){
		phase = sizeof(phases);
	}
	if (phase > sizeof(phases)){
		phase = 1;
	}
	GPIOC->ODR = phases[phase - 1];
	if (dir){
		phase++;
	}
	else
	{
		phase--;
	}
	steps++;
	_asm("RIM");
}