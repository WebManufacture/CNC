#include "DeviceConfig.h"
/*
void RegisterButtonHandler(struct Button *button, ButtonHandler handler){
	PB_DDR = 0;
	PB_CR1 = bit4 + bit5;
  PB_CR2 = bit4 + bit5;
	
	EXTI_CR1 |= bit3;
}

unsigned char WaitBtn(struct Button *btn, unsigned char unblock, struct Button *controlBtn){
	unsigned long waitLimitValue = 0;
	unblock++;
	while (!btn->pressed){ 
		waitLimitValue++;
		if (controlBtn->pressed) return 0; 
		if (waitLimitValue >= waitLimit) return 0;
	};
	while (btn->falled){ };
	return unblock;
}

unsigned char CheckBtn(struct Button *btn){
	if (!btn->pressed){ return 0;	};
	while (btn->falled){ 
		if (btn->time > holdInterval) return 2;
	};
	return 1;
}

@interrupt void iPortA_EXTI(void){
	unsigned char btn1;
	unsigned char btn2;
	//_asm("SIM");
	btn1 = PB_IDR & b1.mask;
	btn2 = PB_IDR & b2.mask;
  if (btn1 == 0 && !b1.falled && !b1.pressed){
		if (b2.falled){
			b2.otherBtnPressed = 1;
		}
		else{
			b1.ticks = downInterval;
			b1.falled = 1;
			b1.passes = 1;
			b1.time = 0;
			if (ISNOTBEEP){
				Beep1;
			}
		}
	}
	if (btn2 == 0 && !b2.falled && !b2.pressed){
		if (b1.falled){
			b1.otherBtnPressed = 1;
		}
		else{
			b2.ticks = downInterval;
			b2.falled = 1;
			b2.time = 0;
			b2.passes = 1;
			if (ISNOTBEEP){
				Beep2;
			}
		}
	}
	//_asm("RIM");
}

@interrupt void iPortB_EXTI(void){
	unsigned char btn1;
	unsigned char btn2;
	//_asm("SIM");
	btn1 = PB_IDR & b1.mask;
	btn2 = PB_IDR & b2.mask;
  if (btn1 == 0 && !b1.falled && !b1.pressed){
		if (b2.falled){
			b2.otherBtnPressed = 1;
		}
		else{
			b1.ticks = downInterval;
			b1.falled = 1;
			b1.passes = 1;
			b1.time = 0;
			if (ISNOTBEEP){
				Beep1;
			}
		}
	}
	if (btn2 == 0 && !b2.falled && !b2.pressed){
		if (b1.falled){
			b1.otherBtnPressed = 1;
		}
		else{
			b2.ticks = downInterval;
			b2.falled = 1;
			b2.time = 0;
			b2.passes = 1;
			if (ISNOTBEEP){
				Beep2;
			}
		}
	}
	//_asm("RIM");
}


void ProcessBtn(struct Button *btn){
	unsigned char btn_state;
	btn->time++;
	if (btn->pressed){
		btn->ticks++;
		if (btn->ticks > upInterval){
			if (btn->passes >= upCounter){
				btn->pressed = 0;				
				btn->passes = 0;
				btn->falled = 0;        //Все хорошо, отпускаем обработку
				btn->otherBtnPressed = 0; 
			}
			else{
				btn->ticks = 0;
				btn->passes = 0;
			}
		}
		else{
			btn_state = PB_IDR & btn->mask;
			if (btn_state > 0) btn->passes++;
		}
	}
	else{
		btn->ticks--;
		if (btn->ticks == 0){
			if (btn->passes > downCounter){
				btn->pressed = 1;		//Переходим к ожиданию отжатия		
				btn->passes = 0;
			}
			else{
				btn->pressed = 0;
				btn->falled = 0; //Клавиша нажата не уверенно, выходим.
				btn->ticks = 0;
				btn->passes = 0;
				btn->otherBtnPressed = 0; 
			}
			Beep0;
		}
		else{
			btn_state = PB_IDR & btn->mask;
			if (btn_state == 0) btn->passes++;
		}
	}
}

@interrupt void iTim4_OVF(void){
	unsigned char b1t;
	unsigned char b2t;
	//_asm("SIM");
	TIM4_SR &= 254;
	if (workMode >= 10){
		ticksLocal++;
		ticksGlobal++;
		if (workMode == 99 && ticksLocal > 14000){
			workMode = 100;
			Beep0;
			ticksLocal = 0;
		}
	}
	if (b1.falled){
		ProcessBtn(&b1);
	}
	if (b2.falled){
		ProcessBtn(&b2);
	}
	//_asm("RIM");
}*/