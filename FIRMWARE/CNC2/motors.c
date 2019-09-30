#include "DeviceConfig.h"
#include "Motors.h"
#include "Utils.h"
#include "Commands.h"

//#define FULLSTEP_Z

struct SMotorState mX, mY, mZ, *m1, *m2, *m3;
extern char ticks;
extern struct TablePosition current;
extern volatile struct Digits settingsA @0x4010;


void motor_stop(void);
void motor_start(unsigned int bspeed);
void setSpeed(unsigned int bspeed);

void initMotors(){
	mX.coef = 1;
	mY.coef = 1;
	mZ.coef = 1;
	
	mX.out = &PC_ODR;
	mX.port = &PC;
	mX.mask =     0b11100001;
	mX.stopMask = 0b00000000;
	mX.phases[0] = 0b00010000;
	mX.phases[1] = 0b00011000;
	mX.phases[2] = 0b00001000;
	mX.phases[3] = 0b00001100;
	mX.phases[4] = 0b00000100;
	mX.phases[5] = 0b00000110;
	mX.phases[6] = 0b00000010;
	mX.phases[7] = 0b00010010;	
	  
	mY.out = &PD_ODR;
	mY.port = &PD;
	mY.mask = 0b11100010;
	mY.stopMask = 0b00000000;
	mY.phases[0] = 0b00010000;
	mY.phases[1] = 0b00010100;
	mY.phases[2] = 0b00000100;
	mY.phases[3] = 0b00001100;
	mY.phases[4] = 0b00001000;
	mY.phases[5] = 0b00001001;
	mY.phases[6] = 0b00000001;
	mY.phases[7] = 0b00010001;
			            
		
	mZ.out = &PE_ODR;
	mZ.port = &PE;
	mZ.mask = 0b11110000;
	mZ.stopMask =  0b00000000;
		
	#ifdef FULLSTEP_Z
	
	mZ.phases[0] = 0b00001010;
	mZ.phases[1] = 0b00001010;
	mZ.phases[2] = 0b00001001;
	mZ.phases[3] = 0b00001001;
	mZ.phases[4] = 0b00000101;
	mZ.phases[5] = 0b00000101;
	mZ.phases[6] = 0b00000110;
	mZ.phases[7] = 0b00000110;
	                  
	#else
	mZ.phases[0] = 0b00000010;
	mZ.phases[1] = 0b00001010;
	mZ.phases[2] = 0b00001000;
	mZ.phases[3] = 0b00001001;
	mZ.phases[4] = 0b00000001;
	mZ.phases[5] = 0b00000101;
	mZ.phases[6] = 0b00000100;
	mZ.phases[7] = 0b00000110;
	#endif              
	
  PB.DDR = 0;
	PB.CR1 = 255;
	PB.CR2 = 0;

  PA.DDR = 0;
	PA.CR1 = 0xFF;
	PA.CR2 = 0;
		
	TIM2_CR1 = bit7;    //Разрешаем буферизацию ARR
	TIM2_ARRH = 0x10;      //1000000 / 100 ~ 10000Hz;
	TIM2_ARRL = 0x15;    //1000000 / 100 ~ 10000Hz;
	TIM2_IER =  1;      //Update overflow and Capture/Compare 1
	TIM2_PSCR = 4;      //Предделитель 16000000 /16 = 1000000 Hz
		
	motor_stop();
	
	mX.port->DDR |= ~mX.mask;
	mX.port->CR1 |= ~mX.mask;
	mX.port->CR2 = 0;
	mX.port->Out &= mX.stopMask;
	
	mY.port->DDR |= ~mY.mask;
	mY.port->CR1 |= ~mY.mask;
	mY.port->CR2 = 0;
	mY.port->Out &= mY.stopMask;
	
	mZ.port->DDR |= ~mZ.mask;
	mZ.port->CR1 |= ~mZ.mask;
	mZ.port->CR2 = 0;
	mZ.port->Out &= mZ.stopMask;
}


char CheckEnds(void){
	char inp;
	inp = PB.In & 124;
	if (inp == 124){
		return 1;
	}
	if (PpB.in2 > 0 && mX.Limit < mX.Steps && settingsA.dig2){
		return 0;
	}
	if (PpB.in3 > 0 && mX.Limit > mX.Steps && settingsA.dig4){
		return 0;
	}
	if (PpB.in4 > 0 && mZ.Limit > mZ.Steps && settingsA.dig8){
		return 0;
	}
	if (PpB.in5 > 0 && mZ.Limit < mZ.Steps && settingsA.dig16){
		return 0;
	}
	if (PpB.in6 > 0 && mY.Limit < mY.Steps && settingsA.dig32){
		return 0;
	}
  if (PpB.in7 > 0 && mY.Limit > mY.Steps && settingsA.dig64){
		return 0;
	}
	inp = PB.In;
	inp = (~inp) & current.waitingMaskA;
	if (current.waitingMaskA & 127 > 0){
		if (current.waitingMaskA > 0 && inp > 0){
			return 0;
		}
	}
	else{
		if (current.waitingMaskA > 0 && inp == 0){
			return 0;
		}
	}
	return 1;
}

char CheckBtns(void){
	char inp;	
	return 1;
  inp = PA.In & 252;
	inp = inp & current.waitingMaskB;
	if (current.waitingMaskB > 0 && inp == 0){
		return 0;
	}
	return 1;
}

void loadCommand(InCommandPtr cmd){
	  mX.Limit = cmd->x;		
		mY.Limit = cmd->y;	
		mZ.Limit = cmd->z;		
		mX.Dir = sign(mX.Limit, mX.Steps);
		mY.Dir = sign(mY.Limit, mY.Steps);
		mZ.Dir = sign(mZ.Limit, mZ.Steps);
  	mX.Delta = abs(mX.Limit - mX.Steps);
		mY.Delta = abs(mY.Limit - mY.Steps);
		mZ.Delta = abs(mZ.Limit - mZ.Steps);
		mX.speed2 = cmd->speed;
		mY.speed2 = cmd->speed;
		mZ.speed2 = cmd->speed;
	  mX.Error = 0;		
		mY.Error = 0;	
		mZ.Error = 0;	
		mX.counter = 0;
		mY.counter = 0;
		mZ.counter = 0;
		if (mX.Delta >= mY.Delta && mX.Delta >= mZ.Delta){
			m1 = &mX;
			m2 = &mY;
			m3 = &mZ;
		}
		if (mY.Delta > mX.Delta && mY.Delta > mZ.Delta){
			m1 = &mY;
			m2 = &mX;
			m3 = &mZ;
		}
		if (mZ.Delta > mX.Delta && mZ.Delta > mY.Delta){
			m1 = &mZ;
			m2 = &mY;
			m3 = &mX;
		}
		if (cmd->speed > 0){
			current.maxSpeed = cmd->speed;
	  }
}

	

void motor_stop(void){
	unsigned char pvalue;
	TIM2_CR1 &= 254;
	
	pvalue = *(mX.out);
	pvalue &= mX.mask;
	pvalue |= mX.stopMask;
	*(mX.out) = pvalue;
	
	pvalue = *(mY.out);
	pvalue &= mY.mask;
	pvalue |= mY.stopMask;
	*(mY.out) = pvalue;
	
	pvalue = *(mZ.out);
	pvalue &= mZ.mask;
	pvalue |= mZ.stopMask;
	*(mZ.out) = pvalue;
	
	//current.currentSpeed = MinSpeed;
	
	LEDS_OFF
	LED_BLUE_ON
}

void motor_start(unsigned int bspeed){
	setSpeed(bspeed);
	TIM2_CR1 |= 1;
	LEDS_OFF
	LED_GREEN_ON
}

void setSpeed(unsigned int bspeed){
	TIM2_ARRH = bspeed >> 8;
	TIM2_ARRL = bspeed;
}

void moveFunction(struct SMotorState *mstate){
	unsigned char pvalue;
	if (mstate->phase < 1){
		mstate->phase = sizeof(mstate->phases);
	}
	if (mstate->phase > sizeof(mstate->phases)){
		mstate->phase = 1;
	}
	pvalue = *(mstate->out);
	pvalue &= mstate->mask;
	pvalue |= mstate->phases[mstate->phase - 1];
	*(mstate->out) = pvalue;
	mstate->phase += mstate->Dir;
	mstate->counter--;
	if (mstate->counter == 0){
	   mstate->Steps += mstate->Dir;
	}
}

@interrupt unsigned char iTim2_overflow(){
	_asm("SIM");
	TIM2_SR1 &= 254;
	if (current.state != 1 || (mX.Steps == mX.Limit && mY.Steps == mY.Limit && mZ.Steps == mZ.Limit)) {
		moving_finished();
		_asm("RIM");
		return 0;
	}
	if (!CheckBtns()){
		pause();
		_asm("RIM");
		return 0;
	}
	if (!CheckEnds()){
		error();
		_asm("RIM");
		return 0;
	}
	if (m1->counter > 0) moveFunction(m1);
	if (m2->counter > 0) moveFunction(m2);
	if (m3->counter > 0) moveFunction(m3);
	if (m1->counter == m2->counter == m3->counter == 0){
		ticks++;
		/*if (current.currentSpeed != current.maxSpeed){
			if (current.currentSpeed > current.maxSpeed){
				current.currentSpeed -= SpeedInc;
				setSpeed(current.currentSpeed);
			}
			else
			{
				current.currentSpeed = current.maxSpeed;
				setSpeed(current.currentSpeed);
			}
	  }*/
		if (m1->Steps != m1->Limit){
			m1->counter = m1->coef;
			moveFunction(m1);
			//moveFunction1(m1->Dir > 0 ? 1 : 2);
		}
		if (m2->Steps != m2->Limit && m2->Dir != 0){
			m2->Error += m2->Delta;
			if ((signed long)(2 * m2->Error) >= m1->Delta){
				m2->Error -= m1->Delta;
				m2->counter = m2->coef;
				moveFunction(m2);
				//moveFunction2(m2->Dir > 0 ? 1 : 2);
			}
		}
		if (m3->Steps != m3->Limit && m3->Dir != 0){
			m3->Error += m3->Delta;
			if ((signed long)(2 * m3->Error) >= m1->Delta){
				m3->Error -= m1->Delta;
				m3->counter = m3->coef;
				moveFunction(m3);
				//moveFunction3(m3->Dir > 0 ? 1 : 2);
			}
		}
		if (mX.Steps == mX.Limit && mY.Steps == mY.Limit && mZ.Steps == mZ.Limit)
		{
			moving_finished();
		}
	}
	_asm("RIM");
}

