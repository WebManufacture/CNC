#include "STM8S003F3P.h"
#include "Consts.h"
#include "stm8s_i2c.h"
#include "segmentsi2c.h"

unsigned char Tx_Idx = 0;
unsigned char TxBuffer[7];
const unsigned char SymbolCodes[];
unsigned char commandPending = 0;

/*

#define SEGCOMMAND_ARR_ASCII 1
#define SEGCOMMAND_CLEAR     2
#define SEGCOMMAND_ARR_DRAFT 5
#define SEGCOMMAND_ARR_SYM   10
#define SEGCOMMAND_BYTE      20
#define SEGCOMMAND_INT       30
#define SEGCOMMAND_SIGNED    40
#define SEGCOMMAND_DRAFT     50
#define SEGCOMMAND_SYM       51
*/

void SegmentsSendCommand(char com){
	unsigned int counter = 1000000;
	if (commandPending > 0) return;
	commandPending = 1;
	TxBuffer[0] = com;	
	while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY) && counter > 0){ counter--; }
	if (counter == 0) return;
	I2C_ITConfig((I2C_IT_TypeDef)(I2C_IT_ERR | I2C_IT_EVT | I2C_IT_BUF) , ENABLE);
	I2C_GenerateSTART(ENABLE);
}

void SegmentsSendLong(long dta){
	while (commandPending > 0){};
	TxBuffer[4] = dta >> 24;
	TxBuffer[3] = dta >> 16;
	TxBuffer[2] = dta >> 8;
	TxBuffer[1] = dta;	
	SegmentsSendCommand(25);
	/*
	if (dta > 99999){
		dta = dta/10;
		SegmentsShowSym(24, 6);
	}	
	if (dta > 999999){
		dta = dta/100;
		SegmentsShowSym(24, 6);
	}	
	if (dta > 9999999){
		dta = dta/1000;
		SegmentsShowSym(24, 6);
	}	
	SegmentsShowSym(dta%10, 5);
	if (dta >= 10){
		SegmentsShowSym((dta/10)%10, 4);
	}
	if (dta >= 100){
		SegmentsShowSym((dta/100)%10, 3);
	}
	if (dta >= 1000){
		SegmentsShowSym((dta/1000)%10, 2);
	}
	if (dta >= 10000){
		SegmentsShowSym((dta/10000)%10, 1);
	}
	SegmentsSendCommand(SEGCOMMAND_ARR_SYM);*/
}


unsigned char SegmentsSendData(void){
	SegmentsSendCommand(SEGCOMMAND_ARR_DRAFT);
	return 1;
}

void SegmentsSendClear(void){
	SegmentsSendCommand(SEGCOMMAND_CLEAR);
}

void SegmentsClearAll(void){
	char i;
	if (commandPending > 0) return;
	for(i = 1; i < 7; i++){
		TxBuffer[i] = 39;
	}
	SegmentsSendCommand(SEGCOMMAND_CLEAR);
}

void SegmentsShowDraft(signed short dta, char pos){
	if (commandPending > 0) return;
	TxBuffer[pos+1] = SymbolCodes[dta];
}

void SegmentsShowSym(signed short dta, char pos){
	if (commandPending > 0) return;
	TxBuffer[pos+1] = dta;
}

void SegmentsShowSpecial(signed short dta, char pos){
	if (commandPending > 0) return;
	TxBuffer[pos+1] = dta;
}

void SegmentsShowDot(char pos){
	if (commandPending > 0) return;
	TxBuffer[pos+1] |= segH;
}

void SegmentsShowNum(unsigned long dta){
	if (commandPending > 0) return;
	if (dta > 99999){
		dta = dta/10;
		SegmentsShowSym(24, 6);
	}	
	if (dta > 999999){
		dta = dta/100;
		SegmentsShowSym(24, 6);
	}	
	if (dta > 9999999){
		dta = dta/1000;
		SegmentsShowSym(24, 6);
	}	
	SegmentsShowSym(dta%10, 5);
	if (dta >= 10){
		SegmentsShowSym((dta/10)%10, 4);
	}
	if (dta >= 100){
		SegmentsShowSym((dta/100)%10, 3);
	}
	if (dta >= 1000){
		SegmentsShowSym((dta/1000)%10, 2);
	}
	if (dta >= 10000){
		SegmentsShowSym((dta/10000)%10, 1);
	}
}

void SegmentsShowBigNum(unsigned long dta){
	if (commandPending > 0) return;
	if (dta > 999999){
		dta = dta/10;
		SegmentsShowBigNum(dta);
		SegmentsShowSym(24, 5);
		return;
	}	
	SegmentsShowSym(dta%10, 5);
	if (dta >= 10){
		SegmentsShowSym((dta/10)%10, 4);
	}
	if (dta >= 100){
		SegmentsShowSym((dta/100)%10, 3);
	}
	if (dta >= 1000){
		SegmentsShowSym((dta/1000)%10, 2);
	}
	if (dta >= 10000){
		SegmentsShowSym((dta/10000)%10, 1);
	}
	if (dta >= 100000){
		SegmentsShowSym((dta/100000)%10, 0);
	}
}

@interrupt void iI2C(void)
{
	uint16_t Event;
	unsigned char data;
  if ((I2C->SR2) != 0)
  {
		I2C->SR2 = 0;
  }
  Event = I2C_GetLastEvent();
	switch (Event)
  {
		case I2C_EVENT_MASTER_MODE_SELECT :
      I2C_Send7bitAddress(SLAVE_ADDRESS, I2C_DIRECTION_TX);
      break;
    case I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED:
      Tx_Idx = 0;
      break;
      /* EV8 */
    case I2C_EVENT_MASTER_BYTE_TRANSMITTING:
      I2C_SendData(TxBuffer[Tx_Idx++]);
      if (Tx_Idx >= 7)
      {
        I2C_ITConfig(I2C_IT_BUF, DISABLE);
      }
      break;
    case I2C_EVENT_MASTER_BYTE_TRANSMITTED:
      I2C_GenerateSTOP(ENABLE);
      I2C_ITConfig(I2C_IT_EVT, DISABLE);
			commandPending = 0;
      break;

    default:
      break;
  }
}


// SEGMENTS:
//    a
//   ---
// b| g |f
//   ---
// c|   |e
//   ---   .h
//    d

#define segA bit0
#define segB bit2
#define segC bit6
#define segD bit5
#define segE bit3
#define segF bit1
#define segG bit4
#define segH bit7

const unsigned char SymbolCodes[41] = {
	segB + segA + segF + segC + segE + segD, // 0
	segF + segE, //1
	segA + segF + segG + segC + segD, //2
	segA + segF + segG + segE + segD, //3
	segB + segG + segF + segE, //4
	segA + segB + segG + segE + segD, //5
	segA + segB + segG + segC + segE + segD, //6
	segA + segF + segE, //7
	~segH, //8
	~segH - segC, //9
	~segH - segD, //10 A
	~segH - segA - segF, //11 b
	segA + segB + segC + segD, //12 C
	~segH - segA - segB, //13 d
	~segH - segF - segE, //14 E
	segA + segB + segC + segG, //15 F
	~segH - segC, //16 g
	~segH - segA - segD, //17 H
	segC, //18 i
	segF + segE + segD + segC, //19 J
	segA + segG + segD, //20 k
	segB + segC + segD, //21 L
	segA + segB + segC + segE, //22 m
	segC + segG + segE, //23 n
	segC + segG + segE + segD, //24 o
	~segH - segD - segE, //25 P
	~segH - segC - segD, //26 q
	segC + segG, //27 r
	segA + segB + segG + segE + segD, //28 S
	segB + segG + segC + segD,  //29 t
	segC + segD + segE,  //30 u
	segC + segD + segE + segB + segF,  //31 U
	segB + segE,  //32 x
	~segH - segA - segC,  //33 Y
	segB + segG + segE,  //34 z
	segH,  //35 .
	segF + segH,  //36 !
	segG,  //37 -
	255,  //38 8.
	0, //39,
	segD,  //40 _
};

