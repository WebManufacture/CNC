/*	BASIC INTERRUPT VECTOR TABLE FOR STM8 devices
 *	Copyright (c) 2007 STMicroelectronics
 */

	
#define NULL 0

extern void _stext();     /* startup routine */
//extern void iPORTB_EXTI();     /* startup routine */
extern void iTim2_overflow();     /* startup routine */
//extern void iTim3_overflow();     /* startup routine */
extern void iUART_TX();     /* startup routine */
extern void iUART_RX();     /* startup routine */
extern void iADC();     /* startup routine */
//extern void iTim4_OVF();     /* startup routine */
//extern void iI2C_handler();

void (* const @vector _vectab[32])() = {
	_stext,			/* RESET       */
	NULL,			/* TRAP        */
	NULL,			/*0 TLI         */
	NULL,			/*1 AWU         */
	NULL,			/*2 CLK         */
	NULL,			/*3 EXTI PORTA  */
	NULL,			/*4 EXTI PORTB  */
	NULL,			/*5 EXTI PORTC  */
	NULL,			/*6 EXTI PORTD  */
	NULL,			/*7 EXTI PORTE  */
	NULL,			/*8 CAN RX      */
	NULL,			/*9 CAN TX      */
	NULL,			/*10 SPI         */
	NULL,			/*11 TIMER 1 OVF */
	NULL,			/*12 TIMER 1 CAP */
	iTim2_overflow,			/*13 TIMER 2 OVF */
	NULL,			/*14 TIMER 2 CAP */
	NULL,			/*15 TIMER 3 OVF */
	NULL,			/*16 TIMER 3 CAP */
	iUART_TX,			/*17 USART TX    */
	iUART_RX,			/*18 USART RX    */
	NULL,//iI2C_handler,			/*19 I2C         */
	iUART_TX,			/* 20 LINUART TX  */
	iUART_RX,			/* 21 LINUART RX  */
	NULL,			/* 22 ADC         */
	NULL,			/* 23 TIMER 4 OVF */
	NULL,			/* EEPROM ECC  */
	NULL,			/* Reserved    */
	NULL,			/* Reserved    */
	NULL,			/* Reserved    */
	NULL,			/* Reserved    */
	NULL,			/* Reserved    */
	};