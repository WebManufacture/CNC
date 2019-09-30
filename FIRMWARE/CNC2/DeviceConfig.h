#include "consts105C6.h"

#define USE_TIM2 1
#define USE_TIM4 1

#define LEDS_OFF PA_ODR &= bit1 + bit2 + bit3; 
#define LED_RED_ON PA_ODR &= bit1;
#define LED_RED_OFF PA_ODR |= bit1;
#define LED_GREEN_ON PA_ODR &= bit2;
#define LED_GREEN_OFF PA_ODR |= bit2;
#define LED_BLUE_ON PA_ODR &= bit3;
#define LED_BLUE_OFF PA_ODR |= bit3;

#define DEFAULT_PACKET_SIZE 40

struct Message {
	unsigned char addr;
};
