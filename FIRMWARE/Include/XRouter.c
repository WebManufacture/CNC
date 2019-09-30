#include "DeviceConfig.h"
#include "GeneralConfig.h"
#include "utils.h"

uchar DeviceAddr = 0;
uchar RouterAddr = 0;

extern void UartSendData(char* data, char size);

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
	return 0;
}

void InitXRouting(void)
{
	char data[20];
	data[1] = 01;
	data[3] = 01;
	_msg_routing_SendFactoryNum(data);
}

signed char __evt_init_XRouting(char event, char* data){
	InitXRouting();
}
