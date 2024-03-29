#include "events.h"
#include "utils.h"

#define USE_EVENTS 1

@near EventHandler events[4][maxEvents];

signed char FireEvent(char event, char* data){
	uchar i;
	schar result;
	schar fresult = 0;
	for (i = 0; i < maxEvents; i++){
		if (events[event][i] != 0){
			result = events[event][i](event, data);
			if (result < 0) return -1;
			fresult |= (result & 1);
		}
	}
	return fresult;
}

void SubscribeEvent(char event, EventHandler handler){
	char i;
	char freeSlotIndex = -1;
	for (i = 0; i < maxEvents; i++){
		if (events[event][i] == 0){
			freeSlotIndex = i;
			break;
		}
	}
	if (freeSlotIndex >= 0){
		events[event][freeSlotIndex] = handler;
	}
}