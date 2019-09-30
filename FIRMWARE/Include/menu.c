#include "menu.h"
#include "Utils.h"
#include "segmentsi2c.h"

char menuSize = defaultMenuSize;

struct MenuModeDescriptor* currentMenu;
unsigned char menuPtr;
struct MenuModeDescriptor menu[defaultMenuSize];

void ShowFlag(char value){
	SegmentsShowSym(24, 4);
	if (value > 0){
		SegmentsShowSym(23, 5);
	}
	else{
		SegmentsShowSym(15, 5);
	}
}

void ShowItem(char* arr, char value){
	char i = 0;
	char val = 0;
	for (i = 0; i < 6; i++){
		val = arr[i + (value*6)];
		if (val > 0){
			SegmentsShowSym(val, i);
		}
	}	
}

unsigned char GetMenuIndex(void){
	return menuPtr;
}

void ShowMenu(struct MenuModeDescriptor* subMenu){
	char i;
	unsigned long value;
	for (i = 0; i < 6; i++){
		if (subMenu->symbolsMask[i] > 0){
			SegmentsShowSym(subMenu->symbolsMask[i], i);
		}
		else{
			SegmentsShowSym(39, i);
		}
	}
	value = *(subMenu->valueAddr);
	switch (subMenu->valueType){
		case MENU_VALUE_NUM :
			if (value > subMenu->maxValue){
				value = subMenu->maxValue;
				*(subMenu->valueAddr) = value;
			}
			if (value < subMenu->minValue){
				value = subMenu->minValue;
				*(subMenu->valueAddr) = value;
			}
			SegmentsShowNum(value); break;
		case MENU_VALUE_BOOL : {
			ShowFlag(value); break;
		}
		case MENU_VALUE_LIST : {
			if (value > subMenu->maxValue){
				value = subMenu->maxValue;
				*(subMenu->valueAddr) = value;
			}
			if (value < subMenu->minValue){
				value = subMenu->minValue;
				*(subMenu->valueAddr) = value;
			}
			ShowItem(subMenu->symbolsMasksList, value);
		}
		case MENU_VALUE_NONE : break;
	}
	SegmentsSendData();
}

void InitMenu(void){
	menuSize = defaultMenuSize;
	menuPtr = 0;
	Delay(10000);
	currentMenu = &(menu[menuPtr]);
	ShowMenu(currentMenu);
}

void SelectMenu(char menuIndex){
	menuPtr = menuIndex;
	if (menuPtr >= menuSize) menuPtr = 0;	
	currentMenu = &(menu[menuPtr]);
	ShowMenu(currentMenu);
	Delay(70000);
}

void SelectNextMenu(void){
	menuPtr++;
	if (menuPtr >= menuSize) menuPtr = 0;	
	currentMenu = &(menu[menuPtr]);
	ShowMenu(currentMenu);
	Delay(70000);
}

void IncMenuValue(unsigned long inc){
	unsigned long value;
	if (currentMenu->valueType == MENU_VALUE_NONE) return;
	value = *(currentMenu->valueAddr);
	if (currentMenu->valueType == MENU_VALUE_LIST){
		inc = 1;
	}
	if (currentMenu->valueType == MENU_VALUE_BOOL){
		if (value > 0){
			value = 0;
		}
		else{
			value = 1;
		}
		*(currentMenu->valueAddr) = value;
		ShowMenu(currentMenu);
		Delay(80000);
		return;
	}
	if (value + inc <= currentMenu->maxValue){
		value += inc;
	}
	else{
		value = currentMenu->minValue;
	}
	*(currentMenu->valueAddr) = value;
	ShowMenu(currentMenu);
	Delay(45000);
}

void DecMenuValue(unsigned long dec){
	unsigned long value;
	if (currentMenu->valueType == MENU_VALUE_NONE) return;
	value = *(currentMenu->valueAddr);
	if (currentMenu->valueType == MENU_VALUE_LIST){
		dec = 1;
	}
	if (currentMenu->valueType == MENU_VALUE_BOOL){
		if (value > 0){
			value = 0;
		}
		else{
			value = 1;
		}
		*(currentMenu->valueAddr) = value;
		ShowMenu(currentMenu);
		Delay(80000);
		return;
	}
	if (value >= currentMenu->minValue + dec){
		value -= dec;
	}
	else{
		value = currentMenu->maxValue;
	}
	*(currentMenu->valueAddr) = value;
	ShowMenu(currentMenu);
	Delay(45000);
}

