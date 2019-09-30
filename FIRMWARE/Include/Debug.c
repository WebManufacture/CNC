#include "DeviceConfig.h"
#include "GeneralConfig.h"
#include "routing.h"
#include "tinyDebug.h"
#include "utils.h"
#include "uart.h"

//11 $0B
schar _msg_debug_StartDebug(struct Message *message);
//12 $0C
schar _msg_debug_StopDebug(struct Message *message);
//13 $0D
schar _msg_debug_GetMem(struct Message* msg);
//14 $0E
schar _msg_debug_SetMem(struct Message *msg);
//15 $0F
schar _msg_debug_CopyMem(struct Message *message);
//16 $10
schar _msg_debug_UnblockMem(struct Message *message);
//17 $11
schar _msg_debug_Call(struct Message *message);
//18 $12
schar _msg_debug_GoTo(struct Message *message);
//19 $13
schar _msg_debug_ResetDevice(struct Message *message);

signed char __evt_init_debug(char event, char* data)
{
	UnblockEEPROM();
	MSubscribe(10, NULL); //DEBUG COMMAND ANSWER 
	MSubscribe(11, _msg_debug_StartDebug); 
	MSubscribe(12, _msg_debug_StopDebug); 
	MSubscribe(13, _msg_debug_GetMem); 
	MSubscribe(14, _msg_debug_SetMem); 
	MSubscribe(15, _msg_debug_CopyMem);
	MSubscribe(16, _msg_debug_UnblockMem);	
	MSubscribe(17, _msg_debug_Call);
	MSubscribe(18, _msg_debug_GoTo);
	MSubscribe(19, _msg_debug_ResetDevice);	
	return 0;
}


schar _msg_debug_StartDebug(struct Message *message){
	deviceState.DebugFlag = 1;
	return 0;
}

schar _msg_debug_StopDebug(struct Message *message){
	deviceState.DebugFlag = 0;
	return 0;
}

//13
schar _msg_debug_GetMem(struct Message* msg){
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

//14
schar _msg_debug_SetMem(struct Message *msg){
	char* addr;
	char bytesCount;
	uchar byte = 0;
	if (!msg->srcAddr) return 0;
	bytesCount = msg->srcType;
	addr = (char*)((uint)((msg->data[0] << 8) + msg->data[1]));
	for (;bytesCount > 0; bytesCount--){
		byte = msg->data[(bytesCount-1)+2];
		*addr = byte;
		addr++;
	}	
	return 0;
}

//15
schar _msg_debug_CopyMem(struct Message *message){
	deviceState.DebugFlag = 0;
	return 0;
}

//16
schar _msg_debug_UnblockMem(struct Message *message){
	if (!message->srcAddr) return -1;
	UnblockEEPROM();
	UnblockFLASH();
	return 0;
}

//17
schar _msg_debug_Call(struct Message *message){
	deviceState.DebugFlag = 0;
	return 0;
}

//18
schar _msg_debug_GoTo(struct Message *message){
	deviceState.DebugFlag = 0;
	return 0;
}

//19
schar _msg_debug_ResetDevice(struct Message *message){
	Reset();
	return 0;
}