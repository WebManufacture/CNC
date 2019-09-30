#include "DeviceConfig.h"
#include "Motors.h"
#include "Uart.h"
#include "Commands.h"

#define FULLSTEP_Z 1

struct SMotorState mX, mY, mZ, *m1, *m2, *m3;
extern char ticks;
extern struct TablePosition current;
extern volatile struct Digits settingsA @0x4010;

signed char sign (signed long x, signed long y) {
		return x == y ? 0 : (x > y) ? 1 : -1;
    //возвращает 0, если аргумент (x) равен нулю; -1, если x < 0 и 1, если x > 0.
}

signed long abs(signed long x) {
	if (x < 0){
		return -x;
	}
	return x;
}

void motor_stop(void);
void motor_start(unsigned int bspeed);
void setSpeed(unsigned int bspeed);

void initMotors(){
	mX.coef = 1;
	mY.coef = 1;
	mZ.coef = 1;
	
	mX.out = &PD_ODR;
	mX.port = &PD;
	mX.mask = 0b11100010;
	mX.stopMask = 0b11100010;
	mX.phases[0] = 0b00010000;
	mX.phases[1] = 0b00010100;
	mX.phases[2] = 0b00000100;
	mX.phases[3] = 0b00001100;
	mX.phases[4] = 0b00001000;
	mX.phases[5] = 0b00001001;
	mX.phases[6] = 0b00000001;
	mX.phases[7] = 0b00010001;
			            
	mY.out = &PE_ODR;
	mY.port = &PE;
	mY.mask = 0b00010111;
	mY.stopMask = 0b00010111;
	mY.phases[0] = 0b10000000;
	mY.phases[1] = 0b10100000;
	mY.phases[2] = 0b00100000;
	mY.phases[3] = 0b01100000;
	mY.phases[4] = 0b01000000;
	mY.phases[5] = 0b01001000;
	mY.phases[6] = 0b00001000;
	mY.phases[7] = 0b10001000;	
	
	mZ.out = &PC_ODR;
	mZ.port = &PC;
	mZ.mask = 0b00001111;
	mZ.stopMask =  0b00001111;
		
	#ifdef FULLSTEP Z
	
	mZ.phases[0] = 0b11000000;
	mZ.phases[1] = 0001010000;
	mZ.phases[2] = 0b00110000;
	mZ.phases[3] = 0b10100000;	
	mZ.phases[4] = 0b11000000;
	mZ.phases[5] = 0001010000;
	mZ.phases[6] = 0b00110000;
	mZ.phases[7] = 0b10100000;
	
	#else
	mZ.phases[0] = 0b11000000;
	mZ.phases[1] = 0b11000000;
	mZ.phases[2] = 0b01000000;
	mZ.phases[3] = 0b01010000;
	mZ.phases[4] = 0b00010000;
	mZ.phases[5] = 0b00110000;
	mZ.phases[6] = 0b00100000;
	mZ.phases[7] = 0b10100000;
	#endif
	
  PB.DDR = 0;
	PB.CR1 = 0;
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
	mX.port->Out = mX.stopMask;
	
	mY.port->DDR |= ~mY.mask;
	mY.port->CR1 |= ~mY.mask;
	mY.port->CR2 = 0;
	mY.port->Out = mY.stopMask;
	
	mZ.port->DDR |= ~mZ.mask;
	mZ.port->CR1 |= ~mZ.mask;
	mZ.port->CR2 = 0;
	mZ.port->Out = mZ.stopMask;
}


char CheckEnds(void){
	char inp;
	inp = PA.In & 126;
	if (inp == 126){
		return 1;
	}
	if (PpA.in1 == 0 && mX.Limit < mX.Steps && settingsA.dig2){
		return 0;
	}
	if (PpA.in2 == 0 && mX.Limit > mX.Steps && settingsA.dig4){
		return 0;
	}
	if (PpA.in3 == 0 && mZ.Limit > mZ.Steps && settingsA.dig8){
		return 0;
	}
	if (PpA.in4 == 0 && mZ.Limit < mZ.Steps && settingsA.dig16){
		return 0;
	}
	if (PpA.in5 == 0 && mY.Limit < mY.Steps && settingsA.dig32){
		return 0;
	}
	if (PpA.in6 == 0 && mY.Limit > mY.Steps && settingsA.dig64){                                                   
		return 0;
	}
	inp = PA.In & current.waitingMaskA;
	if (current.waitingMaskA > 0 && inp == 0){
		return 0;
	}
	inp = PA.In & current.waitingMaskB;
	if (current.waitingMaskB > 0 && inp == 0){
		return 0;
	}
	return 1;
}

char CheckBtns(void){
	char inp;
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
	
	current.currentSpeed = MinSpeed;
	
	LEDS_OFF
	LED_BLUE_ON
}

void motor_start(unsigned int bspeed){
	setSpeed(current.currentSpeed);
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
		motor_stop();
		setState(2);
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
		if (current.currentSpeed != current.maxSpeed){
			if (current.currentSpeed > current.maxSpeed){
				current.currentSpeed -= SpeedInc;
				setSpeed(current.currentSpeed);
			}
			else
			{
				current.currentSpeed = current.maxSpeed;
				setSpeed(current.currentSpeed);
			}
	  }
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
			motor_stop();
			setState(2);
		}
	}
	_asm("RIM");
}

