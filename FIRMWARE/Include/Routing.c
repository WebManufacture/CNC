#include "DeviceConfig.h"
#include "GeneralConfig.h"
#include "routing.h"
#include "utils.h"
#include "uart.h"

uint DeviceAddr = 0;

//@near struct RouteRecord   Subscribers[MAX_SUBSCRIPTIONS];
@near struct FactoryRecord KnownDevices[4];
@near 			 uchar         KnownAddresses[MAX_KNOWN_DEVICES];
@near struct Message       MessagesQuery[MESSAGE_QUEUE_LENGTH];

volatile MessageHandler RoutingTable[40] @(0x4000 + sizeof (struct CONFIGURATION_STRUCT));

uchar KnownIndex = 0;
uchar QueueIndex = 0;
uchar QueueProcessIndex = 0;

schar _msg_routing_SendFactoryNum(struct Message *message);
schar _msg_routing_SetDeviceAddr(struct Message *message);
schar _msg_routing_AddFriend(struct Message *message);

schar postInitRoutingEventHandler(char event, char* data);
signed char ProcessMessages(char event, char* data);

signed char __evt_init_routing(char event, char* data)
{
	ESubscribe(EVT_AFTER_INIT, postInitRoutingEventHandler);
	ESubscribe(EVT_IDLE, ProcessMessages);
	ESubscribe(EVT_DEBUG, ProcessMessages);
	UnblockEEPROM();
	RoutingTable[1] = _msg_routing_SendFactoryNum; //ÄĞÓÃÎÅ ÓÑÒĞÎÉÑÒÂÎ ĞÅÃÈÑÒĞÈĞÓÅÒÑß
	RoutingTable[2] = _msg_routing_SetDeviceAddr;  //ÎÒÂÅÒ ĞÎÓÒÅĞÀ ÑÎÄÅĞÆÈÒ ÀÄĞÅÑ
	RoutingTable[4] = _msg_routing_AddFriend;      //ÓÑÒĞÎÉÑÒÂÀ çíàêîìÿòñÿ
	RoutingTable[5] = _msg_routing_SendFactoryNum; //Èññëåäîâàíèå ñåòè
	//MSubscribe(00, 01, SendFactoryNum);
	//MSubscribe(00, 02, SetDeviceAddr);
	return 0;
}

signed char ProcessMessage(uint addr, struct Message* message)
//signed char ProcessMessage(uint addr, struct Message* message)
{
	char dstType = (addr & 0x00FF);	
	MessageHandler handler = RoutingTable[dstType];
	if (handler == NULL) return 0;
	return handler(message);
	/*
	schar result = 0;
	MessageHandler handler;
	for (i = 0; i < MAX_SUBSCRIPTIONS; i++){
		if ((Subscribers[i].mask & addr) == Subscribers[i].addr){
			handler = Subscribers[i].handler;
			if (handler(message) < 0) return -1;
		}
	}
	return 1;*/
}

signed char ProcessMessages(char event, char* data){
	char i;	
	struct Message* message = (struct Message*)(&MessagesQuery[QueueProcessIndex]);
	if (*(long*)(&MessagesQuery[QueueProcessIndex]) != NULL){
		if (!ProcessMessage(*(uint*)(&MessagesQuery[QueueProcessIndex]), message)){
			*(long*)&MessagesQuery[QueueProcessIndex] = 0;
		}
	}
	QueueProcessIndex++;
	if (QueueProcessIndex >= MESSAGE_QUEUE_LENGTH - 1){
		QueueProcessIndex = 0;
	}
	return 0;
}

signed char SendMessage(struct Message *message){
	char i;	
	if (QueueIndex >= MESSAGE_QUEUE_LENGTH - 1){
		QueueIndex = 0;
	}
	MessagesQuery[QueueIndex].dstAddr = message->dstAddr;
	MessagesQuery[QueueIndex].dstType = message->dstType;
	MessagesQuery[QueueIndex].srcAddr = message->srcAddr;
	MessagesQuery[QueueIndex].srcType = message->srcType;
	for (i = 0; i < MAX_MESSAGE_SIZE; i++){
		MessagesQuery[QueueIndex].data[i] = message->data[i];
	}
	QueueIndex++;
	return 1;
}

signed char SendMessageChain(struct Message *message[]){
	return 1;
}

void MSubscribe(uchar command, MessageHandler handler){
	//if (RoutingTable[command] == NULL) 
	RoutingTable[command] = handler;
}

/*
void MSubscribeMaskInt(uint mask, uint addr, MessageHandler handler){
	char i;
	for (i = 0; i < MAX_SUBSCRIPTIONS; i++){
	if (Subscribers[i].handler == 0) {
			Subscribers[i].mask = mask;
			Subscribers[i].addr = addr;
			Subscribers[i].handler = handler;
	}
}

#define MSubscribeMask(a, b) MSubscribeMaskInt(*((uint*)&a), *((uint*)&b))

void MSubscribeMask(struct MessageMask mask, struct MessageMask addr, MessageHandler handler){
 	//union {
	//	struct MessageMask addr;
	//	uint value;
	//} msg;
	
	//msg.addr = addr;
	//
	//MSubscribeMaskInt(msg.value, msg.value, handler);
	MSubscribeMaskInt(*((uint*)&mask), *((uint*)&addr), handler);
}

void MSubscribe(uchar da, uchar dt, MessageHandler handler){
	char i;
	uint addr = (uint)((da << 8) + dt);
	MSubscribeMaskInt(0xFFFF, addr, handler);
}

void MUnSubscribe(struct MessageMask mask){
	char i, j;
	long searchMask = *((long*)(&mask));
	for (i = 0; i < MAX_SUBSCRIPTIONS; i++){
		if (Subscribers[i].mask == searchMask) {
			if (i >= MAX_SUBSCRIPTIONS - 1){
				Subscribers[i].mask = 0;
				Subscribers[i].handler = 0;
			}
			else
			{
				for (j = i + 1; j < MAX_SUBSCRIPTIONS; j++){
					Subscribers[j-1] = Subscribers[j];
				}
				Subscribers[MAX_SUBSCRIPTIONS - 1].mask = 0;
				Subscribers[MAX_SUBSCRIPTIONS - 1].handler = 0;
			}
		}
	}
}

void MUnSubscribeHandler(MessageHandler handler){
	char i, j;
	for (i = 0; i < MAX_SUBSCRIPTIONS; i++){
		if (Subscribers[i].handler == handler){
			if (i >= MAX_SUBSCRIPTIONS - 1){
				Subscribers[i].mask = 0;
				Subscribers[i].handler = 0;
			}
			else
			{
				for (j = i + 1; j < MAX_SUBSCRIPTIONS; j++){
					Subscribers[j-1] = Subscribers[j];
				}
				Subscribers[MAX_SUBSCRIPTIONS - 1].mask = 0;
				Subscribers[MAX_SUBSCRIPTIONS - 1].handler = 0;
			}
		}
	}
}

*/

signed char postInitRoutingEventHandler(char event, char* data)
{	
	struct Message msg;
	msg.dstAddr = 00;
	msg.dstType = 01;
	msg.srcAddr = 00;
	_msg_routing_SendFactoryNum(&msg);
	return 0;
}


schar _msg_routing_SendFactoryNum(struct Message *message){
	char i;
	//ÍÅÒ ÔÈËÜÒĞÀÖÈÈ ÏÎ ÀÄĞÅÑÓ, ò.å. 00 èëè àäğåñ óñòğîéñòâà - íå âàæíî
	message->srcType = message->dstType;	
	if (message->srcAddr > 0 && (message->dstType == 1 || message->dstType == 5)) {
		message->dstType = 4;
	}
	message->dstAddr = message->srcAddr;
	message->srcAddr = DeviceAddr;	
	for (i = 0; i < sizeof (struct FactoryRecord); i++){
		message->data[i] = *((char*)(&DeviceConfig.factoryRec) + i);	
	}
	UartSendSized(message, sizeof(struct FactoryRecord));
	return 0;
}

schar _msg_routing_SetDeviceAddr(struct Message *message){
	char i;
	//ÍÅÒ ÔÈËÜÒĞÀÖÈÈ ÏÎ ÀÄĞÅÑÓ, ò.å. 00 èëè àäğåñ óñòğîéñòâà - íå âàæíî
	for (i = 0; i < sizeof (struct FactoryRecord); i++){
		if (message->data[i] != *((char*)(&DeviceConfig.factoryRec) + i)) return 0;
	}	
	DeviceAddr = message->srcType;	
	return 0;
}

schar _msg_routing_AddFriend(struct Message *message){
	char i;
	char* knownStruct = (char*)&KnownDevices[KnownIndex];
	if (!message->srcAddr) return 0;
	KnownAddresses[KnownIndex] = message->srcAddr;
	for (i = 0; i < sizeof (struct FactoryRecord); i++){
		knownStruct[i] = message->data[i];
	}	
	KnownIndex++;
	return 0;
}
