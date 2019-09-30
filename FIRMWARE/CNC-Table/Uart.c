#include "DeviceConfig.h"
#include "utils.h"

#define UART_BUFFER_SIZE 30
/*
@near uchar Slave_Buffer_Rx[UART_BUFFER_SIZE];
@near uchar Slave_Buffer_Tx[UART_BUFFER_SIZE];
uchar Tx_Idx = 0, Rx_Idx = 0;
uint16_t Event = 0x00;
bool i2cDataReceived = 0;
*/
@near uchar uartDataBuf[UART_BUFFER_SIZE];
@near uchar uartSendBuf[UART_BUFFER_SIZE];


struct uartState{
	unsigned char phase;
	unsigned char size;
	unsigned char index;
} urState, uwState;

char* getUart(void){
	return uartDataBuf;
}

char checkUart(void){
	return urState.phase == 3 ? 1 : 0;
}

char clearUart(void){
	return urState.phase = 0;
}

void initUart(void){/*
	I2C_DeInit();
  I2C_Init(100000, 0x06, I2C_DUTYCYCLE_2, I2C_ACK_CURR, I2C_ADDMODE_7BIT, 16);           
  I2C_ITConfig((I2C_IT_TypeDef)(I2C_IT_ERR | I2C_IT_EVT | I2C_IT_BUF), ENABLE);
*/	
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
}


void sendUart(char* ptr, unsigned char size){
	unsigned int i;
	while (uwState.phase > 0 && uwState.phase < 3){
		
	};
	uwState.phase = 0;
	uwState.index = 0;
	uwState.size = size;
	for (i = 0; i < size; i++){
		uartSendBuf[i] = ptr[i];
	}
	UART2_CR2 |= bit7;//(TIEN) TXE interrupt	
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
			if (val > 0 && val <= UART_BUFFER_SIZE){
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
				urState.size = UART_BUFFER_SIZE;
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

/**
  * @brief I2C Interrupt routine.
  * @param  None
  * @retval None
  */
	
	/*
@interrupt void iI2C_handler(void)
{
	unsigned char data;
	char command;
	char i;
  if ((I2C->SR2) != 0)
  {
		I2C->SR2 = 0;
  }
  Event = I2C_GetLastEvent();
  switch (Event)
  {
    case I2C_EVENT_SLAVE_TRANSMITTER_ADDRESS_MATCHED:
      Tx_Idx = 0;
      break;
    case I2C_EVENT_SLAVE_BYTE_TRANSMITTING:
      I2C_SendData(Slave_Buffer_Tx[Tx_Idx++]);
      break;
    case I2C_EVENT_SLAVE_RECEIVER_ADDRESS_MATCHED:
			//ShowDot(5);
			i2cDataReceived = 0;
			Rx_Idx = 0;
      break;
    case I2C_EVENT_SLAVE_BYTE_RECEIVED:
			data = I2C_ReceiveData();
			Slave_Buffer_Rx[Rx_Idx++] = data;
      break;
    case (I2C_EVENT_SLAVE_STOP_DETECTED):
        I2C->CR2 |= I2C_CR2_ACK;				
				if (Rx_Idx > 0){
					command = Slave_Buffer_Rx[0];
					for (i = 0; i < Rx_Idx; i++){
						*((unsigned char*)(&i2cDataBuf + 1 + i)) = Slave_Buffer_Rx[i];
					}
					i2cDataReceived = 1;
				}
				//HideDot(5);
      break;

    default:
      break;
  }
}*/