#include "STM8S105K4.h"
#include "Consts.h"
#include "gpio.h"

volatile struct Port PA @PA_ODR;
volatile struct Port PB @PB_ODR;
volatile struct Port PC @PC_ODR;
volatile struct Port PD @PD_ODR;

volatile struct Pins PpA @PA_ODR;
volatile struct Pins PpB @PB_ODR;
volatile struct Pins PpC @PC_ODR;
volatile struct Pins PpD @PD_ODR; 

volatile struct Port PE @PE_ODR;
volatile struct Port PF @PF_ODR;
volatile struct Pins PpE @PE_ODR;
volatile struct Pins PpF @PF_ODR;

#define UART_CR1 UART2_CR1
#define UART_CR2 UART2_CR2
#define UART_CR3 UART2_CR3
#define UART_CR4 UART2_CR4
#define UART_CR5 UART2_CR5
#define UART_BRR2 UART2_BRR2
#define UART_BRR1 UART2_BRR1
#define UART_SR UART2_SR
#define UART_DR UART2_DR            

DEF_8BIT_REG_AT(RST_ST,0x50B3);