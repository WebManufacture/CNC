#include "DeviceConfig.h"
#include "GeneralConfig.h"
#include "tinyDebug.h"
#include "utils.h"

uchar DeviceAddr = 0;
uchar RouterAddr = 0;

#define MESSAGE_SIZE 20

typedef void (*PacketHandler)(char* data);

extern void UartSendData(char* data, char size);

PacketHandler Handlers[7];

void _msg_routing_SendFactoryNum(char* msg){
	char i;	
	if (msg[1] == 5) {//if (msg->dstType == 5)) {
		msg[1] = 4;
	}
	msg[0] = msg[2];//msg->dstAddr = msg->srcAddr;
	msg[2] = DeviceAddr;	//msg->srcAddr = DeviceAddr;	
	for (i = 0; i < sizeof (struct FactoryRecord); i++){
		msg[i+4] = *((char*)(&DeviceConfig.factoryRec) + i);//msg->data[i] = *((char*)(&DeviceConfig.factoryRec) + i);	
	}
	UartSendData(msg, 4 + sizeof (struct FactoryRecord));
}

void _msg_routing_SetDeviceAddr(char* msg){
	char i;
	for (i = 0; i < sizeof (struct FactoryRecord); i++){
		if (msg[i+4] != *((char*)(&DeviceConfig.factoryRec) + i)) return;
	}	
	DeviceAddr = msg[3];
	RouterAddr = msg[2];
	return;
}

void _msg_debug_GetMem(char* msg){
	uint addr;
	uint count;
	char buffer[MESSAGE_SIZE];
	uchar counter = 0;
	if (!msg[2] || !msg[0]) return;
	addr = (uint)((msg[0+4] << 8) + msg[1+4]);
	count = (uint)((msg[2+4] << 8) + msg[3+4]);
	msg[0] = msg[2];
	msg[2] = DeviceAddr;
	msg[3] = msg[1];
	msg[1] = 10;
	for (;count > 0; count--){
		msg[counter + 4] = *(char*)addr;
		addr++;
		counter++;
		if (counter >= MESSAGE_SIZE-4){
			UartSendData(msg, MESSAGE_SIZE);
			counter = 0;
		}
	}	
	if (counter > 0){
		UartSendData(msg, counter);
	}
}

//14
void _msg_debug_SetMem(char *msg){
	char* addr;
	char bytesCount;
	uchar byte = 0;
	if (!msg[2] || !msg[0]) return;
	bytesCount = msg[3];
	addr = (char*)((uint)((msg[0+4] << 8) + msg[1+4]));
	for (;bytesCount > 0; bytesCount--){
		byte = msg[(bytesCount-1)+2+4];
		*addr = byte;
		addr++;
	}	
}

//15
void _msg_debug_CopyMem(char* msg){
	
}

//16
void _msg_debug_UnblockMem(char* msg){
	if (!msg[2] || !msg[0]) return;
	UnblockEEPROM();
	UnblockFLASH();
}

//17
void _msg_debug_Call(char* msg){

}

//18
void _msg_debug_GoTo(char* msg){

}

//19
void _msg_debug_ResetDevice(char* msg){
	if (!msg[2] || !msg[0]) return;
	Reset();
}

schar ProcessPacket(char* data){
	switch (data[1]){
		case 2: 
			_msg_routing_SetDeviceAddr(data);
		return 1;
		case 5: 
			_msg_routing_SendFactoryNum(data);
		return 1;
	}	
	if (data[0] != DeviceAddr) return 1;
	if (data[1] >= 13 && data[1] < 20) {
		Handlers[data[1] - 13](data);
		return 1;
	}
	return 0;
}

signed char __evt_init_debug(char event, char* data){
	InitDebug();
}

void InitDebug(void)
{
	char data[20];
	Handlers[0] = _msg_debug_GetMem; 
	Handlers[1] = _msg_debug_SetMem; 
	Handlers[2] = _msg_debug_CopyMem;
	Handlers[3] = _msg_debug_UnblockMem;	
	Handlers[4] = _msg_debug_Call;
	Handlers[5] = _msg_debug_GoTo;
	Handlers[6] = _msg_debug_ResetDevice;
	data[1] = 01;
	data[3] = 01;
	_msg_routing_SendFactoryNum(data);
}
