#include "STM8S105C6.h"
#include "stm8s_i2c.h"
#include "consts.h"

@near uint8_t Slave_Buffer_Rx[32];
@near uint8_t Slave_Buffer_Tx[24];
uint8_t Tx_Idx = 0, Rx_Idx = 0;
uint16_t Event = 0x00;

void motor_stop(void);
void motor_start(unsigned int bspeed);
void setSpeed(unsigned int bspeed);
//extern unsigned char uart_read_buf

struct {
	char command;
	unsigned int speed;	
	unsigned long line;	
	char state;
	char waitingMaskA;
	char waitingMaskB;
} TablePosition;

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
} uartSendBuf;

struct SMotorState{
	signed long Steps;
	signed long Limit;
	signed long Error;
	signed long Delta;	
	signed char Dir;
	unsigned int speed1;
	unsigned int speed2;
	unsigned char coef;
	unsigned char counter;
	unsigned char phase;
	unsigned char mask;
	unsigned char phases[8];
	unsigned char *port;
} mX, mY, mZ, *m1, *m2, *m3;

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


struct uartState{
	unsigned char phase;
	unsigned char size;
	unsigned char index;
} urState, uwState;

volatile struct {
	unsigned long X;
	unsigned long Y;
	unsigned long Z;
	unsigned long W;
	unsigned char settingsA;
	unsigned char settingsB;
} config @0x4000;

volatile struct Digits settingsA @0x4010;
typedef @near struct InUartCommand *InCommand;
typedef void (*commandFunc)(InCommand cmd);

char ticks;
char currentCommand = 0;
@near struct InUartCommand Buffer[40];
@near struct InUartCommand uartDataBuf, i2cDataBuf;

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

void sendTable(char command);

void loadCommand(InCommand cmd){
	  mX.Limit = cmd->x;		
		mY.Limit = cmd->y;	
		mZ.Limit = cmd->z;		
		mX.Dir = sign(mX.Limit, mX.Steps);
		mY.Dir = sign(mY.Limit, mY.Steps);
		mZ.Dir = sign(mZ.Limit, mZ.Steps);
  	mX.Delta = abs(mX.Limit - mX.Steps);
		mY.Delta = abs(mY.Limit - mY.Steps);
		mZ.Delta = abs(mZ.Limit - mZ.Steps);
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
		//mX.Delta *= MotorSettings.xCorrect;
		//mY.Delta *= MotorSettings.yCorrect;
		//mZ.Delta *= MotorSettings.zCorrect;
		TablePosition.state = 1;		
		TablePosition.speed = cmd->speed;
		TablePosition.line = cmd->line;		
}

DEF_8BIT_REG_AT(RST_ST,0x50B3);

void uartSend(void);

void init(){
	//guac = *(struct GoUartCommand*);
	TablePosition.state = 9;
	TablePosition.line = RST_ST;
	motor_stop();
	sendTable(0);
	TablePosition.state = 0;
	TablePosition.line = 0;
	
	mX.coef = 1;
	mY.coef = 1;
	mZ.coef = 1;
	
	mX.port = &PD_ODR;
	mX.mask = 0b11100010;
	mX.phases[0] = 0b00010000;
	mX.phases[1] = 0b00010100;
	mX.phases[2] = 0b00000100;
	mX.phases[3] = 0b00001100;
	mX.phases[4] = 0b00001000;
	mX.phases[5] = 0b00001001;
	mX.phases[6] = 0b00000001;
	mX.phases[7] = 0b00010001;
	                
	mZ.port = &PC_ODR;
	mZ.mask = 0b00001111;
	mZ.phases[0] = 0b10000000;
	mZ.phases[1] = 0b10100000;
	mZ.phases[2] = 0b00100000;
	mZ.phases[3] = 0b01100000;
	mZ.phases[4] = 0b01000000;
	mZ.phases[5] = 0b01010000;
	mZ.phases[6] = 0b00010000;
	mZ.phases[7] = 0b10010000;
	                
	mY.port = &PE_ODR;
	mY.mask = 0b11110000;
	mY.phases[0] = 0b00001000;
	mY.phases[1] = 0b00001010;
	mY.phases[2] = 0b00000010;
	mY.phases[3] = 0b00000110;
	mY.phases[4] = 0b00000100;
	mY.phases[5] = 0b00000101;
	mY.phases[6] = 0b00000001;
	mY.phases[7] = 0b00001001;
	
	I2C_DeInit();
  I2C_Init(100000, 0x06, I2C_DUTYCYCLE_2, I2C_ACK_CURR, I2C_ADDMODE_7BIT, 16);           
  I2C_ITConfig((I2C_IT_TypeDef)(I2C_IT_ERR | I2C_IT_EVT | I2C_IT_BUF), ENABLE);
	
	CLK_CKDIVR = 0;
	
	UART2_CR1 = 0; //PARITY ODD + 9Bit (8d+1p)
	UART2_CR2 = bit5 + bit3 + bit2; // RX + TX + RXIE
	UART2_CR3 = 0; //1 STOP
	UART2_CR4 = 0;
	UART2_CR5 = 0;
	//UART_BRR2 = 0x03; //9600 16 MHz
	//UART_BRR1 = 0x68; //9600 16 MHz
	
	
	//MOV UART2_BRR2, #$00;38400
	//MOV UART2_BRR1, #$0D;38400
	
	UART2_BRR2 = 0x0B; //115200 16 MHz
	UART2_BRR1 = 0x08; //115200 16 MHz

	//guac.z = 100000;
	//guac.x = 100000;
	//guac.y = 100000;
	//guac.speed = 6000;
	//cCommand = 1;
}

char CheckEnds(void){
	char inp;
	inp = PA_IDR & 126;
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
	inp = PA_IDR & TablePosition.waitingMaskA;
	if (TablePosition.waitingMaskA > 0 && inp == 0){
		return 0;
	}
	inp = PB_IDR & TablePosition.waitingMaskB;
	if (TablePosition.waitingMaskB > 0 && inp == 0){
		return 0;
	}
	return 1;
}

char CheckBtns(void){
	char inp;
	//STOP
	inp = PB_IDR & 1;
	if (inp == 0){
		return 3; 
	}
	//LURD+TB
	inp = PA_IDR & 126;
	if (inp == 0){
		return 1;
	}
	return 0;
}

void StopCommand(InCommand cmd){		//3
	motor_stop();
	TablePosition.state = 2;
}

void StateCommand(InCommand cmd){ //4
	sendTable(cmd->command);
}

void WaitMaskCommand(InCommand cmd){ //10
	sendTable(TablePosition.command);
	TablePosition.state = 2;
}

void PauseCommand(InCommand cmd) {//6
	motor_stop();
	TablePosition.state = 2;
}
	
void ResumeCommand(InCommand cmd) {//7
	motor_start(TablePosition.speed);
	TablePosition.state = 2;
}
	
		
void InternalCommand(InCommand cmd) {//11
}


void Reset(void){
	WWDG_CR = bit7;
}
	
void ResetCommand(InCommand cmd) {//12
	Reset();
}

void SpindleCommand(InCommand cmd){//8, 9
		PC_ODR = cmd->paramA;
		TablePosition.state = 2;
}
	
void MoveCommand(InCommand cmd){ // 1, 5
		if (cmd->command == 5){
			 cmd->x = cmd->x + mX.Steps;
			 cmd->y = cmd->y + mY.Steps;
			 cmd->z = cmd->z + mZ.Steps;
		}	
		if (cmd->x == mX.Steps && cmd->y == mY.Steps && cmd->z == mZ.Steps || (TablePosition.line > 0 && TablePosition.line == cmd->line))
		{				
			motor_stop();
			TablePosition.line = cmd->line;
			TablePosition.state = 2;
			return;
		}
		motor_stop();
		TablePosition.waitingMaskA = cmd->paramA;
		TablePosition.waitingMaskB = cmd->paramB;
		loadCommand(cmd);
		if (!CheckEnds()){
			TablePosition.state = 4;
			return;
		}
		TablePosition.line = cmd->line;
		ticks = 201;
		motor_start(TablePosition.speed);
		return;
	}
	
void RebaseCommand(InCommand cmd){ //2
		motor_stop();
		mX.Steps = cmd->x;		
		mY.Steps = cmd->y;	
		mZ.Steps = cmd->z;
		mX.Limit = 0;		
		mY.Limit = 0;	
		mZ.Limit = 0;	
		mX.Dir = 0;
		mY.Dir = 0;
		mZ.Dir = 0;
		mX.Delta = 0;
		mY.Delta = 0;
		mZ.Delta = 0;
		TablePosition.state = 2;	
		return;
	}

void ConfigCommand(InCommand cmd){ //13
	unsigned char dataState;
	if (cmd->speed = 1){
		uartSendBuf.address = 06;//Adress
		uartSendBuf.command = 12;
		uartSendBuf.X = config.X;
		uartSendBuf.Y = config.Y;
		uartSendBuf.Z = config.Z;
		uartSendBuf.XL = 0;
		uartSendBuf.YL = 0;
		uartSendBuf.ZL = 0;
		uartSendBuf.state = 1;
		uartSendBuf.line = TablePosition.line;
		uartSendBuf.paramA = config.settingsA;
		uartSendBuf.paramB = config.settingsB;
		uartSend();
	}
	if (cmd->speed = 2){
		dataState = FLASH_IAPSR;
		dataState &= bit3;
		if (dataState == 0){
			FLASH_DUKR = 0xAE;
			FLASH_DUKR = 0x56;
		}
		config.X = cmd->x;
		config.Y = cmd->y;
		config.Z = cmd->z;
		config.settingsA = cmd->paramA;
		config.settingsB = cmd->paramB;
	}
	TablePosition.state = 2;
	return;
}	

const commandFunc commands[20] = {
	StateCommand,//0
	MoveCommand,//1
	RebaseCommand,//2
	StopCommand, //3
	StateCommand, //4
	MoveCommand,//5
	PauseCommand,//6
	ResumeCommand,//7
	SpindleCommand,//8
	SpindleCommand,//9
	WaitMaskCommand,//10
	InternalCommand,//11
	ResetCommand,//12
	ConfigCommand,//13
	NULL,//14
	NULL,//15
	NULL,//16
	NULL,//17
	NULL,//18
	NULL //19
};

void processCommand(InCommand command){
	if (currentCommand < sizeof(Buffer)){
		Buffer[currentCommand] = *command;
		currentCommand++;
	}
	else{
		
	}	
}

char nextCommand(void){
	if (currentCommand > 0){
		currentCommand--;
		TablePosition.command = Buffer[0].command;
		commands[TablePosition.command](&Buffer[0]);
		Buffer[0] = Buffer[1];
		Buffer[1] = Buffer[2];
		Buffer[2] = Buffer[3];
		return 1;
	}
	return 0;
}

void cicle(){
	if (urState.phase == 3){
		processCommand(&uartDataBuf);
		if (TablePosition.state == 0 && currentCommand > 0){
			nextCommand(); 
		}
		urState.phase = 0;
	} 	
	if (TablePosition.state == 2){
		if (currentCommand > 0){
			TablePosition.state = 3;
		}
		sendTable(TablePosition.command);		
		TablePosition.waitingMaskA = 0;
		TablePosition.waitingMaskB = 0;
		if (currentCommand > 0){
			nextCommand();
		}
		else{
			TablePosition.command = 0;
			TablePosition.state = 0;
		}		
	}
	if (TablePosition.state == 4){
		sendTable(TablePosition.command);
		TablePosition.waitingMaskA = 0;
		TablePosition.waitingMaskB = 0;
		TablePosition.state = 0;
	}
	if (TablePosition.state == 1){
		if (CheckBtns() == 3) {
			motor_stop();
			TablePosition.state = 4;
			sendTable(20);//Error
		}
		if (ticks > 50){
			ticks = 0;
			sendTable(TablePosition.command);
		}
	}
}


void moveFunction(struct SMotorState *mstate){
	unsigned char pvalue;
	if (mstate->phase < 1){
		mstate->phase = sizeof(mstate->phases);
	}
	if (mstate->phase > sizeof(mstate->phases)){
		mstate->phase = 1;
	}
	pvalue = *(mstate->port);
	pvalue &= mstate->mask;
	pvalue |= mstate->phases[mstate->phase - 1];
	*(mstate->port) = pvalue;
	mstate->phase += mstate->Dir;
	mstate->counter--;
	if (mstate->counter == 0){
	   mstate->Steps += mstate->Dir;
	}
}

@interrupt unsigned char iTim2_overflow(){
	_asm("SIM");
	TIM2_SR1 &= 254;
	if (TablePosition.state != 1 || (mX.Steps == mX.Limit && mY.Steps == mY.Limit && mZ.Steps == mZ.Limit)) {
		_asm("RIM");
		return 0;
	}
	if (!CheckEnds()){
		motor_stop();
		TablePosition.state = 4;
		_asm("RIM");
		return 0;
	}
	if (m1->counter > 0) moveFunction(m1);
	if (m2->counter > 0) moveFunction(m2);
	if (m3->counter > 0) moveFunction(m3);
	if (m1->counter == m2->counter == m3->counter == 0){
		ticks++;
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
			if ((signed long)(2 *m3->Error) >= m1->Delta){
				m3->Error -= m1->Delta;
				m3->counter = m3->coef;
				moveFunction(m3);
				//moveFunction3(m3->Dir > 0 ? 1 : 2);
			}
		}
		if (mX.Steps == mX.Limit && mY.Steps == mY.Limit && mZ.Steps == mZ.Limit)
		{
				TablePosition.state = 2;
		}
	}
	_asm("RIM");
}

@interrupt unsigned char iTim3_overflow(){
	unsigned char pvalue;
	_asm("SIM");
	TIM3_SR1 &= 254;

	_asm("RIM");
}

void uartSend(void){
	unsigned char size;
	while (uwState.phase > 0 && uwState.phase < 3){
		
	};
	uwState.phase = 0;
	uwState.index = 0;
	size = sizeof(struct OutUartCommand);
	uwState.size = size;
	UART2_CR2 |= bit7;//(TIEN) TXE interrupt	
}


void sendTable(char command){
	uartSendBuf.address = 06;//Adress
	uartSendBuf.command = command;
	uartSendBuf.X = mX.Steps;
	uartSendBuf.Y = mY.Steps;
	uartSendBuf.Z = mZ.Steps;
	uartSendBuf.XL = mX.Limit;
	uartSendBuf.YL = mY.Limit;
	uartSendBuf.ZL = mZ.Limit;
	uartSendBuf.state = TablePosition.state;
	uartSendBuf.line = TablePosition.line;
	uartSendBuf.paramA = PA_IDR;
	uartSendBuf.paramB = PB_IDR;
	uartSend();
}


@interrupt void iUART_RX(void){
	unsigned char val;
	unsigned int index;
	_asm("SIM");
	res(UART2_SR,5);
	val = UART2_DR;
	if (urState.phase < 3){
		if (urState.phase == 2){
			if (urState.index >= urState.size){
					urState.phase = val == 04 ? 3 : 0;
					_asm("RIM");
					return;
			}
			else{
				*((char*)&uartDataBuf + urState.index) = val;
				urState.index++;
			}
		}
		if (urState.phase == 1){
			if (val > 0 && val <= sizeof(struct InUartCommand)){
				urState.phase = 2;
				urState.size = val;				
			}
			else{
				urState.phase = 0;
				urState.size = 0;
			}
			urState.index = 0;
		}
		if (urState.phase == 0){
			if (val == 1 || val == 2){
				urState.phase = val;
				urState.size = sizeof(struct InUartCommand);
			}
			urState.index = 0;
		}
	}
	_asm("RIM");
}

@interrupt void iUART_TX(void){
	unsigned char *val;
	unsigned char wv;
	_asm("SIM");
	if (uwState.index >= uwState.size){
		if (uwState.phase < 3){
			UART2_DR = 04;//EOT
			uwState.phase = 3;
		}
		else{
			UART2_CR2 = UART2_CR2 & ~bit7; //UART TX OFF
		}		
	}
	else{
		if (uwState.phase == 2){
			val = ((char*)&uartSendBuf) + uwState.index;
			UART2_DR = *val;
			uwState.index++;
		}		
		if (uwState.phase == 1){
			UART2_DR = uwState.size;
			uwState.phase = 2;
		}
		if (uwState.phase == 0){
			UART2_DR = 01;//SOH
			uwState.phase = 1;
		}
	}
	_asm("RIM");
}



void ProcessCommand(unsigned char size){
	char command;
	char i;
	if (size > 0){
		command = Slave_Buffer_Rx[0];
		for (i = 0; i < size; i++){
			*((unsigned char*)(&i2cDataBuf + 1 + i)) = Slave_Buffer_Rx[i];
		}
		processCommand(&i2cDataBuf);
	}
}

/**
  * @brief I2C Interrupt routine.
  * @param  None
  * @retval None
  */
@interrupt void iI2C_handler(void)
{
	unsigned char data;
  if ((I2C->SR2) != 0)
  {
		I2C->SR2 = 0;
  }
  Event = I2C_GetLastEvent();
  switch (Event)
  {
      /******* Slave transmitter ******/
      /* check on EV1 */
    case I2C_EVENT_SLAVE_TRANSMITTER_ADDRESS_MATCHED:
      Tx_Idx = 0;
      break;

      /* check on EV3 */
    case I2C_EVENT_SLAVE_BYTE_TRANSMITTING:
      /* Transmit data */
      I2C_SendData(Slave_Buffer_Tx[Tx_Idx++]);
      break;
      /******* Slave receiver **********/
      /* check on EV1*/
    case I2C_EVENT_SLAVE_RECEIVER_ADDRESS_MATCHED:
			//ShowDot(5);
			Rx_Idx = 0;
      break;

      /* Check on EV2*/
    case I2C_EVENT_SLAVE_BYTE_RECEIVED:
			data = I2C_ReceiveData();
			Slave_Buffer_Rx[Rx_Idx++] = data;
      break;

      /* Check on EV4 */
    case (I2C_EVENT_SLAVE_STOP_DETECTED):
        /* write to CR2 to clear STOPF flag */
        I2C->CR2 |= I2C_CR2_ACK;				
				ProcessCommand(Rx_Idx);
				//HideDot(5);
      break;

    default:
      break;
  }
}
