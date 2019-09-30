#ifndef DEBUG_MODULE
#define DEBUG_MODULE 1


signed char __evt_init_debug(char event, char* data);
void InitDebug(void);
signed char ProcessPacket(char* data);

#endif