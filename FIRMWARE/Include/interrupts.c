#include "DeviceConfig.h"
#include "interrupts.h"
#include "events.h"

INTERRUPT_HANDLER(NonHandledInterrupt, 25)
{
	FireEvent(EVT_INTERRUPT, "NONE");
}

/**
  * @brief TRAP Interrupt routine
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER_TRAP(TRAP_IRQHandler)
{
	FireEvent(EVT_INTERRUPT, "TRAP");	
}
/**
  * @brief Top Level Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(TLI_IRQHandler, 0)
{
  FireEvent(EVT_INTERRUPT, "TLI");
}

/**
  * @brief Auto Wake Up Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(AWU_IRQHandler, 1)
{
  FireEvent(EVT_INTERRUPT, "AWU");
}

/**
  * @brief Clock Controller Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(CLK_IRQHandler, 2)
{
  FireEvent(EVT_INTERRUPT, "CLK");
}

/**
  * @brief External Interrupt PORTA Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI_PORTA_IRQHandler, 3)
{
	FireEvent(EVT_INTERRUPT, "EXTI_A");
}

/**
  * @brief External Interrupt PORTB Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI_PORTB_IRQHandler, 4)
{
  FireEvent(EVT_INTERRUPT, "EXTI_B");
}

/**
  * @brief External Interrupt PORTC Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI_PORTC_IRQHandler, 5)
{
  FireEvent(EVT_INTERRUPT, "EXTI_C");
}

/**
  * @brief External Interrupt PORTD Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI_PORTD_IRQHandler, 6)
{
  FireEvent(EVT_INTERRUPT, "EXTI_D");
}

/**
  * @brief External Interrupt PORTE Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EXTI_PORTE_IRQHandler, 7)
{
  FireEvent(EVT_INTERRUPT, "EXTI_E");
}

INTERRUPT_HANDLER(EXTI_PORTF_IRQHandler, 8)
{
	FireEvent(EVT_INTERRUPT, "EXTI_F");
}

 INTERRUPT_HANDLER(CAN_RX_IRQHandler, 8)
 {
  FireEvent(EVT_INTERRUPT, "CAN_RX");
 }

/**
  * @brief CAN TX Interrupt routine.
  * @param  None
  * @retval None
  */
 INTERRUPT_HANDLER(CAN_TX_IRQHandler, 9)
 {
  FireEvent(EVT_INTERRUPT, "CAN_TX");
 }

INTERRUPT_HANDLER(SPI_IRQHandler, 10)
{
  FireEvent(EVT_INTERRUPT, "SPI");
}

INTERRUPT_HANDLER(TIM1_UPD_OVF_TRG_BRK_IRQHandler, 11)
{
  FireEvent(EVT_INTERRUPT, "TIM1_UO");
}

INTERRUPT_HANDLER(TIM1_CAP_COM_IRQHandler, 12)
{
	FireEvent(EVT_INTERRUPT, "TIM1_CC");
}

 INTERRUPT_HANDLER(TIM5_UPD_OVF_BRK_TRG_IRQHandler, 13)
 {
   FireEvent(EVT_INTERRUPT, "TIM5_UO");
 }
/**
  * @brief Timer5 Capture/Compare Interrupt routine.
  * @param  None
  * @retval None
  */
 INTERRUPT_HANDLER(TIM5_CAP_COM_IRQHandler, 14)
 {
   FireEvent(EVT_INTERRUPT, "TIM5_CC");
 }

 INTERRUPT_HANDLER(TIM2_UPD_OVF_BRK_IRQHandler, 13)
 {
 FireEvent(EVT_INTERRUPT, "TIM2_UO");
 }

 INTERRUPT_HANDLER(TIM2_CAP_COM_IRQHandler, 14)
 {
   FireEvent(EVT_INTERRUPT, "TIM2_CC");
 }
 
 INTERRUPT_HANDLER(TIM3_UPD_OVF_BRK_IRQHandler, 15)
 {
     FireEvent(EVT_INTERRUPT, "TIM3_UO");
 }

/**
  * @brief Timer3 Capture/Compare Interrupt routine.
  * @param  None
  * @retval None
  */
 INTERRUPT_HANDLER(TIM3_CAP_COM_IRQHandler, 16)
 {
    FireEvent(EVT_INTERRUPT, "TIM3_CC");
 }
 
 INTERRUPT_HANDLER(UART1_TX_IRQHandler, 17)
 {
   FireEvent(EVT_INTERRUPT, "UART1_TX");
 }

/**
  * @brief UART1 RX Interrupt routine.
  * @param  None
  * @retval None
  */
 INTERRUPT_HANDLER(UART1_RX_IRQHandler, 18)
 {
   FireEvent(EVT_INTERRUPT, "UART1_RX");
 }


 INTERRUPT_HANDLER(I2C_IRQHandler, 19)
 {
   FireEvent(EVT_INTERRUPT, "I2C");
 }

/**
  * @brief UART3 RX interrupt routine.
  * @param  None
  * @retval None
  */
	
INTERRUPT_HANDLER(UART2_TX_IRQHandler, 20)
 {	 
		char evt[] = {EVT_INTERRUPT_UART2_TX};
		char* p = evt;
    FireEvent(EVT_INTERRUPT, p);
 }
 
 INTERRUPT_HANDLER(UART2_RX_IRQHandler, 21)
 {
	 	char evt[] = {EVT_INTERRUPT_UART2_RX};
		char* p = evt;
   FireEvent(EVT_INTERRUPT, p);
 }


/**
  * @brief UART3 RX interrupt routine.
  * @param  None
  * @retval None
  */
 INTERRUPT_HANDLER(UART3_TX_IRQHandler, 20)
 {
   FireEvent(EVT_INTERRUPT, "UART3_TX");
 }
 
 INTERRUPT_HANDLER(UART3_RX_IRQHandler, 21)
 {
   FireEvent(EVT_INTERRUPT, "UART3_RX");
 }

 INTERRUPT_HANDLER(ADC2_IRQHandler, 22)
 {
   FireEvent(EVT_INTERRUPT, "ADC2");
 }

 INTERRUPT_HANDLER(ADC1_IRQHandler, 22)
 {
   FireEvent(EVT_INTERRUPT, "ADC1");
 }


INTERRUPT_HANDLER(TIM6_UPD_OVF_TRG_IRQHandler, 23)
 {
   FireEvent(EVT_INTERRUPT, "TIM6_UO");
 }
 
 INTERRUPT_HANDLER(TIM4_UPD_OVF_IRQHandler, 23)
 {
   FireEvent(EVT_INTERRUPT, "TIM4_UO");
 }

/**
  * @brief Eeprom EEC Interrupt routine.
  * @param  None
  * @retval None
  */
INTERRUPT_HANDLER(EEPROM_EEC_IRQHandler, 24)
{
  FireEvent(EVT_INTERRUPT, "EEPROM");
}

/**
  * @}
  */

/******************* (C) COPYRIGHT 2011 STMicroelectronics *****END OF FILE****/