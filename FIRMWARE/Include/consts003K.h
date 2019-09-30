#include "STM8S003K3.h"
#include "Consts.h"
#include "gpio.h"

#define UART_CR1 UART1_CR1
#define UART_CR2 UART1_CR2
#define UART_CR3 UART1_CR3
#define UART_CR4 UART1_CR4
#define UART_CR5 UART1_CR5
#define UART_BRR2 UART1_BRR2
#define UART_BRR1 UART1_BRR1
#define UART_SR UART1_SR
#define UART_DR UART1_DR

volatile struct Port PA @PA_ODR;
volatile struct Port PB @PB_ODR;
volatile struct Port PC @PC_ODR;
volatile struct Port PD @PD_ODR;

volatile struct Pins PpA @PA_ODR;
volatile struct Pins PpB @PB_ODR;
volatile struct Pins PpC @PC_ODR;
volatile struct Pins PpD @PD_ODR; 