#include "DeviceConfig.h"
#include "GeneralConfig.h"
#include "routing.h"
#include "utils.h"
#include "GPIO.h"

//21 $14
schar _msg_gpio_SetState(struct Message *message);
//22 $15
schar _msg_gpio_Get(struct Message *message);
//23 $16
schar _msg_gpio_Set(struct Message* msg);

signed char __evt_init_debug(char event, char* data)
{
	UnblockEEPROM();
	MSubscribe(20, NULL); //GPIO COMMAND ANSWER
	MSubscribe(21, _msg_gpio_SetState); 
	MSubscribe(22, _msg_gpio_Get); 
	MSubscribe(23, _msg_gpio_Set); 
	return 0;
}


schar _msg_gpio_SetState(struct Message *message){
	deviceState.DebugFlag = 1;
	return 0;
}

schar _msg_gpio_Get(struct Message *message){
	deviceState.DebugFlag = 0;
	return 0;
}

//13
schar _msg_gpio_Set(struct Message* msg){
	uint addr;
	uint count;
	char buffer[MAX_MESSAGE_SIZE];
	uchar counter = 0;
	if (!msg->srcAddr) return 0;
	addr = (uint)((msg->data[0] << 8) + msg->data[1]);
	count = (uint)((msg->data[2] << 8) + msg->data[3]);
	for (;count > 0; count--){
		buffer[counter] = *(char*)addr;
		addr++;
		counter++;
		if (counter >= MAX_MESSAGE_SIZE){
			UartSendMessage(msg->srcAddr, 10, DeviceAddr, msg->dstType, (char*)&buffer, counter);
			counter = 0;
		}
	}	
	if (counter > 0){
		UartSendMessage(msg->srcAddr, 10, DeviceAddr, msg->dstType, (char*)&buffer, counter);
	}
	return 0;
}