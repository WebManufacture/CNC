#define maxEvents 5


#define USE_EVENTS 1

#define EVT_RESET 0
#define EVT_INIT 1
#define EVT_AFTER_INIT 2
#define EVT_IDLE 3
#define EVT_DEBUG 4
#define EVT_INTERRUPT 5

#ifndef EVENTS_MODULE
#define EVENTS_MODULE 1

typedef signed char (*EventHandler)(char event, char* data);

#endif

#define ESubscribe SubscribeEvent

signed char FireEvent(char event, char* data);
void SubscribeEvent(char event, EventHandler handler);
