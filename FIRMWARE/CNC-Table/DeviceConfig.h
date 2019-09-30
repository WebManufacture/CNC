#include "consts105C6.h"

#define USE_TIM2 1
#define USE_TIM4 1

#define LEDS_OFF PG_ODR |= 3; PE_ODR |= 1; 
#define LED_RED_ON PG_ODR &= 254;
#define LED_RED_OFF PG_ODR |= 1;
#define LED_GREEN_ON PG_ODR &= 253;
#define LED_GREEN_OFF PG_ODR |= 2;
#define LED_BLUE_ON PE_ODR &= 254;
#define LED_BLUE_OFF PE_ODR |= 1;

struct Message {
	unsigned char addr;
};
