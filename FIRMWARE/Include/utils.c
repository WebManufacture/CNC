#include "DeviceConfig.h"

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

void UnblockEEPROM(void){
	char dataState;
	dataState = FLASH_IAPSR;
	dataState &= bit3;
	if (dataState == 0){
		FLASH_DUKR = 0xAE;
		FLASH_DUKR = 0x56;
	}
}

void UnblockFLASH(void){
	char dataState;
	dataState = FLASH_IAPSR;
	dataState &= bit3;
	if (dataState == 0){
		FLASH_PUKR = 0x56;
		FLASH_PUKR = 0xAE;
	}
}

void Delay(long waitCalc){
	long i;
	for (i = waitCalc; i > 0; i--){
		_asm("nop");
	}
}

void Reset(void){
	WWDG_CR = bit7;
}

