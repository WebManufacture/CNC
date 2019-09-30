#include "nRF24L01.h"
#include "utils.h"

uchar TX_ADDRESS_P0[TX_ADR_WIDTH]  = {0xE7,0xE7,0xE7,0xE7,0xE1}; // Define a static TX address
uchar RX_ADDRESS_P0[RX_ADR_WIDTH]  = {0xE7,0xE7,0xE7,0xE7,0xE1}; // Define a static RX address
uchar TX_ADDRESS_P1[TX_ADR_WIDTH]  = {0xE7,0xE7,0xE7,0xE7,0xE7}; // Define a static TX address
uchar RX_ADDRESS_P1[RX_ADR_WIDTH]  = {0xE7,0xE7,0xE7,0xE7,0xE7}; // Define a static RX address

unsigned char  stat;		   
void inerDelay_us(unsigned char n)  
{
for(;n>0;n--) 
  { 
     // asm("nop");  /
     // asm("nop");  
     // asm("nop");  
     // asm("nop");  
      //printf("\n\r delay \n\r");
			#asm
			nop
			nop
			nop
			nop
			#endasm
  }
}

/**************************************************
Function: SPI_Init();
  Description:
  Init hardware and SPI
**************************************************/
void NRF_SPI_Init(void)
{
    GPIO_Init(NRF24L01_CE_PORT, (GPIO_Pin_TypeDef)(NRF24L01_CE_PIN ), GPIO_MODE_OUT_PP_LOW_FAST);//fake CE port aka NSS. Can be use this.
    GPIO_Init(NRF24L01_CS_PORT, (GPIO_Pin_TypeDef)(NRF24L01_CS_PIN ), GPIO_MODE_OUT_PP_HIGH_FAST);//CS
    GPIO_Init(NRF24L01_SCK_PORT, (GPIO_Pin_TypeDef)(NRF24L01_SCK_PIN ), GPIO_MODE_OUT_PP_LOW_FAST);//SCK
    GPIO_Init(NRF24L01_MOSI_PORT, (GPIO_Pin_TypeDef)(NRF24L01_MOSI_PIN ), GPIO_MODE_OUT_PP_HIGH_FAST);//MOSI
    GPIO_Init(NRF24L01_MISO_PORT, (GPIO_Pin_TypeDef)(NRF24L01_MISO_PIN), GPIO_MODE_IN_FL_NO_IT);//MISO
    GPIO_Init(NRF24L01_IRQ_PORT, (GPIO_Pin_TypeDef)(NRF24L01_IRQ_PIN ), GPIO_MODE_IN_FL_NO_IT); //IRQ
    GPIO_Init(GPIOD, (GPIO_Pin_TypeDef)(GPIO_PIN_0), GPIO_MODE_OUT_PP_LOW_FAST);//CE STM8S discovery LED
			
		SPI_DeInit();
    /* Initialize SPI in Slave mode  */
    SPI_Init(SPI_FIRSTBIT_MSB, SPI_BAUDRATEPRESCALER_2, SPI_MODE_MASTER, SPI_CLOCKPOLARITY_LOW,
    SPI_CLOCKPHASE_1EDGE, SPI_DATADIRECTION_2LINES_FULLDUPLEX, SPI_NSS_SOFT,0x07); //(u8)0x07  
    /* Enable the SPI*/
    SPI_Cmd(ENABLE);
}



/**************************************************
Function: SPI_RW();
  Description:
  Writes one byte to nRF24L01, and return the byte read
  from nRF24L01 during write, according to SPI protocol
**************************************************/
unsigned char SPI_RW(unsigned char byte)
{
        /*!< Wait until the transmit buffer is empty */
      uchar retry=0;
      while (SPI_GetFlagStatus(SPI_FLAG_TXE) == RESET)
      {}
      /*!< Send the byte */
      SPI_SendData(byte);
      /*!< Wait until a data is received */
      while (SPI_GetFlagStatus(SPI_FLAG_RXNE) == RESET)
      {
        retry++;
        //if(retry>200)return 0;
      }
      /*!< Get the received data */
      byte = SPI_ReceiveData();
      return(byte);  
}
/**************************************************/

/**************************************************
Function: SPI_RW_Reg();
  Description:
  Writes value 'value' to register 'reg'
************************************************/
unsigned char SPI_RW_Reg(unsigned char reg, unsigned char value)
{
	unsigned char status;
	GPIO_WriteLow(NRF24L01_CS_PORT,NRF24L01_CS_PIN);  // CSN low, init SPI transaction
	status = SPI_RW(reg);      												// select register
	SPI_RW(value);             												// ..and write value to it..
	GPIO_WriteHigh(NRF24L01_CS_PORT,NRF24L01_CS_PIN); // CSN high again
	return(status);            												// return nRF24L01 status byte
}
/**************************************************/

/**************************************************
Function: SPI_Read();
  Description:
  Read one byte from nRF24L01 register, 'reg'
**************************************************/
unsigned char SPI_Read(unsigned char reg)
{
	unsigned char reg_val;
	GPIO_WriteLow(NRF24L01_CS_PORT,NRF24L01_CS_PIN);	// CSN low, initialize SPI communication...
	SPI_RW(reg);            													// Select register to read from..
	reg_val = SPI_RW(0);    													// ..then read registervalue
	GPIO_WriteHigh(NRF24L01_CS_PORT,NRF24L01_CS_PIN); // CSN high, terminate SPI communication
	return(reg_val);        													// return register value
}
/**************************************************/

/*************************************************
Function: SPI_Read_Buf();
  Description:
  
**************************************************/
unsigned char SPI_Read_Buf(unsigned char reg, unsigned char *pBuf, unsigned char bytes)
{
	unsigned char status,byte_ctr;
	GPIO_WriteLow(NRF24L01_CS_PORT,NRF24L01_CS_PIN);// Set CSN low, init SPI tranaction
	status = SPI_RW(reg);       										// Select register to write to and read status byte
		for(byte_ctr=0;byte_ctr<bytes;byte_ctr++)
		pBuf[byte_ctr] = SPI_RW(0);    
	GPIO_WriteHigh(NRF24L01_CS_PORT,NRF24L01_CS_PIN);
	return(status);                    							// return nRF24L01 status byte
}
/**************************************************/

/**************************************************
Function: SPI_Write_Buf();

  Description:
  Writes contents of buffer '*pBuf' to nRF24L01
  Typically used to write TX payload, Rx/Tx address
*************************************************/
unsigned char SPI_Write_Buf(unsigned char reg, unsigned char *pBuf, unsigned char bytes)
{
	unsigned char status,byte_ctr;
  GPIO_WriteLow(NRF24L01_CS_PORT,NRF24L01_CS_PIN);
	status = SPI_RW(reg);
	for(byte_ctr=0; byte_ctr<bytes; byte_ctr++) SPI_RW(*pBuf++);
  GPIO_WriteHigh(NRF24L01_CS_PORT,NRF24L01_CS_PIN);
	return(status);          
}
/**************************************************/

/**************************************************
Function: RX_Mode();

  Description:
  
*************************************************/
void RX_Mode(void)
{
	GPIO_WriteLow(NRF24L01_CE_PORT,NRF24L01_CE_PIN);
//	SPI_Write_Buf(WRITE_REG + TX_ADDR, TX_ADDRESS_P0, TX_ADR_WIDTH);    // Writes TX_Address to nRF24L01
	SPI_Write_Buf(WRITE_REG + RX_ADDR_P0, RX_ADDRESS_P0, RX_ADR_WIDTH); // Use the same address on the RX device as the TX device
	SPI_Write_Buf(WRITE_REG + RX_ADDR_P1, RX_ADDRESS_P1, RX_ADR_WIDTH); // Use the same address on the RX device as the TX device
	SPI_RW_Reg(WRITE_REG + EN_AA, 0x03);      //Enable ‘Auto Acknowledgment’ Function
	SPI_RW_Reg(WRITE_REG + EN_RXADDR, 0x03);  //Enabled RX Addresses
	SPI_RW_Reg(WRITE_REG + RF_CH, 40);        //RF Channel
//  SPI_RW_Reg(WRITE_REG + SETUP_RETR, 0x01); //Setup of Automatic Retransmission
	SPI_RW_Reg(WRITE_REG + RX_PW_P0, RX_PLOAD_WIDTH); //Number of bytes in RX payload in data pipe
	SPI_RW_Reg(WRITE_REG + RX_PW_P1, RX_PLOAD_WIDTH);
	SPI_RW_Reg(WRITE_REG + RF_SETUP, 0x06);   //RF Setup Register  0-LNA
  SPI_RW_Reg(WRITE_REG + CONFIG, 0x0F);     //power up  1: PRX
	/*
	MASK_RX_DR 6  Mask interrupt caused by RX_DR
	1: Interrupt not reflected on the IRQ pin
	0: Reflect RX_DR as active low interrupt on the
	IRQ pin
	MASK_TX_DS 5 Mask interrupt caused by TX_DS
	1: Interrupt not reflected on the IRQ pin
	0: Reflect TX_DS as active low interrupt on the
	IRQ pin
	MASK_MAX_RT 4 Mask interrupt caused by MAX_RT
	1: Interrupt not reflected on the IRQ pin
	0: Reflect MAX_RT as active low interrupt on the
	IRQ pin
	EN_CRC 3 Enable CRC. Forced high if one of the bits in the EN_AA is high
	CRCO 2 CRC encoding scheme
	'0' - 1 byte
	'1' – 2 bytes
	PWR_UP 1 1: POWER UP, 0:POWER DOWN
	PRIM_RX 0 RX/TX control
	1: PRX, 0: PTX
	*/
	GPIO_WriteHigh(NRF24L01_CE_PORT,NRF24L01_CE_PIN);
	inerDelay_us(10);
}
/**************************************************/
unsigned char nRF24L01_RxPacket(unsigned char* rx_buf)
{
	unsigned char stat;
	stat=SPI_Read(STATUS);											// read register STATUS's value
	if((stat&RX_OK)==RX_OK)											// if receive data ready (RX_DR) interrupt
	{
		if ((stat&0x0E)==0)  											//pipe0
			{
			SPI_Read_Buf(RD_RX_PLOAD,rx_buf,TX_PLOAD_WIDTH);// read receive payload from RX_FIFO buffer
			}
		if ((stat&0x0E)==0x02)  									//pipe1
			{
			SPI_Read_Buf(RD_RX_PLOAD,rx_buf,TX_PLOAD_WIDTH);// read receive payload from RX_FIFO buffer
			}
		SPI_RW_Reg(FLUSH_RX,0xff);
		SPI_RW_Reg(WRITE_REG+STATUS,stat);				// clear RX_DR or TX_DS or MAX_RT interrupt flag
		return RX_OK;
	}
//	SPI_RW_Reg(FLUSH_RX,0xff);
  SPI_RW_Reg(WRITE_REG+STATUS,stat);
	return 0;
}


/**************************************************
Function: Set_TX_Mode()

  Description:
  
*************************************************/
void TX_Mode(void)
{
	GPIO_WriteLow(NRF24L01_CE_PORT,NRF24L01_CE_PIN);
	SPI_RW_Reg(WRITE_REG + CONFIG, 0x02);  			// PTX standby
	SPI_RW_Reg(WRITE_REG + EN_AA, 0x01);  			// Enable ‘Auto Acknowledgment’ Function
//	SPI_RW_Reg(WRITE_REG + EN_RXADDR, 0x01);  // Enabled RX Addresses
	SPI_RW_Reg(WRITE_REG + SETUP_RETR, 0x1a); 	// Setup of Automatic Retransmission
	SPI_RW_Reg(WRITE_REG + RF_CH, 40);        	// RF Channel
	SPI_RW_Reg(WRITE_REG + RF_SETUP, 0x07);   	// RF Setup Register 
	SPI_RW_Reg(WRITE_REG + CONFIG, 0x0e);				// power up PTX
}

/**************************************************
Function: nRF24L01_TxPacket();
  Description:
  This function initializes one nRF24L01 device to
  TX mode, set TX address, set RX address for auto.ack,
  fill TX payload, select RF channel, datarate & TX pwr.
  PWR_UP is set, CRC(2 bytes) is enabled, & PRIM:TX.
	ToDo: One high pulse(>10us) on CE will now send this
	packet and expext an acknowledgment from the RX device.
**************************************************/
unsigned char nRF24L01_TxPacket(unsigned char * tx_buf)
{
	GPIO_WriteLow(NRF24L01_CE_PORT,NRF24L01_CE_PIN);
	SPI_Write_Buf(WRITE_REG + TX_ADDR, TX_ADDRESS_P0, TX_ADR_WIDTH);    
	SPI_Write_Buf(WRITE_REG + RX_ADDR_P0, TX_ADDRESS_P0, TX_ADR_WIDTH); 
  SPI_RW_Reg(WRITE_REG + EN_AA, 0x01);      			// Enable ‘Auto Acknowledgment’ Function
//	SPI_RW_Reg(WRITE_REG + EN_RXADDR, 0x01);  		// Enabled RX Addresses
	SPI_RW_Reg(WRITE_REG + SETUP_RETR, 0x1a); 			// Setup of Automatic Retransmission
	SPI_RW_Reg(WRITE_REG + RF_CH, 40);        			// RF Channel
	SPI_RW_Reg(WRITE_REG + RF_SETUP, 0x07);   			// RF Setup Register 
 	SPI_Write_Buf(WR_TX_PLOAD, tx_buf, TX_PLOAD_WIDTH);        
  SPI_RW_Reg(WRITE_REG + CONFIG, 0x0E);						// power up  PTX
	GPIO_WriteHigh(NRF24L01_CE_PORT,NRF24L01_CE_PIN); //Start transmit
//	inerDelay_us(10);		
	while(GPIO_ReadInputPin(NRF24L01_IRQ_PORT, NRF24L01_IRQ_PIN)!=0);//iRQ 
	GPIO_WriteLow(NRF24L01_CE_PORT,NRF24L01_CE_PIN);//Stop transmit  PTX standby
	stat=SPI_Read(STATUS);													//read STATUS register	   
	SPI_RW_Reg(WRITE_REG+STATUS,stat); 							//Reset TX_DS and MAX_RT bit
	if(stat&MAX_TX)																	//check iRQ source MAX_TX, transmit failed
		{
			SPI_RW_Reg(FLUSH_TX,0xff);										//Reset TX FIFO
			return MAX_TX; 
		}
	if(stat&TX_OK)																	//check iRQ source TX_OK, transmit OK
		{
			SPI_RW_Reg(FLUSH_TX,0xff);
			return TX_OK;
		}
	return 0xff;																		//error exit
}
	
/**************************************************
Function: NRF24L01_Check();
//Check NRF24L01 aviablity
**************************************************/
unsigned char NRF24L01_Check(void)
{
	unsigned char buf[5]={0xa9,0xa9,0xa9,0xa9,0xa9};
	unsigned char buf1[5];
	unsigned char i;   	 
	SPI_Write_Buf(WRITE_REG+TX_ADDR,buf,5);			//Write fake TX_ADDR	
	SPI_Read_Buf(TX_ADDR,buf1,5);               //Read register  	
	for(i=0;i<5;i++)
		if(buf1[i]!=0xA9)													//Check readed data
		break;					   
	if(i!=5) return 1;                         	//NRF24L01 aviable
	return 0;		                                //NRF24L01 not aviable
}	 	
/*************************************************/
