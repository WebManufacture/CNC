#include "Events.h"
#include "Utils.h"


#ifndef MAX_SUBSCRIPTIONS
#define MAX_SUBSCRIPTIONS 10
#endif

#ifndef MAX_KNOWN_DEVICES
#define MAX_KNOWN_DEVICES 10
#endif

#ifndef MESSAGE_QUEUE_LENGTH
#define MESSAGE_QUEUE_LENGTH 12
#endif

#define USE_ROUTING 1

#ifndef ROUTING_MODULE
#define ROUTING_MODULE 1

#ifndef MAX_MESSAGE_SIZE
#define MAX_MESSAGE_SIZE 30
#endif

extern uint DeviceAddr;

struct Message{	
	unsigned char dstAddr;
	unsigned char dstType;
	unsigned char srcAddr;
	unsigned char srcType;
	//unsigned char realSize;
	unsigned char data[MAX_MESSAGE_SIZE];
};

struct MessageMask{	
	unsigned char dstAddr;
	unsigned char dstType;
};

typedef schar (*MessageHandler)(struct Message *message);

struct RouteRecord{	
	uint mask;
	uint addr;
	MessageHandler handler;
};

signed char SendMessage(struct Message *message);
signed char SendMessageChain(struct Message *message[]);
void MSubscribe(uchar command, MessageHandler handler);

/*
void MSubscribe(uchar da, uchar dt, MessageHandler handler);
void MSubscribeMaskInt(uint mask, uint addr, MessageHandler handler);
void MSubscribeMask(struct MessageMask mask, struct MessageMask addr, MessageHandler handler);
void MUnSubscribe(struct MessageMask mask);
void MUnSubscribeHandler(MessageHandler handler);
*/


signed char __evt_init_routing(char event, char* data);

#endif