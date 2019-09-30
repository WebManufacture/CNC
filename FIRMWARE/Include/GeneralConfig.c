#include "DeviceConfig.h"
#include "GeneralConfig.h"

//volatile struct CONFIGURATION_STRUCT DeviceConfig @0x4000;

@near struct DeviceState deviceState;

struct CONFIGURATION_STRUCT* LoadConfiguration(void)
{
	char i = 0;
	
	#ifdef USE_EVENTS	
	
	struct EventSubscription es;
	//deviceConfig.factoryRec = config.factoryRec;
	//deviceConfig.deviceSettings = config.deviceSettings;
	for (i = 0; i < MAX_EVENT_Subscriptions; i++){
		es = DeviceConfig.events[i];
		SubscribeEvent(es.eventNum, es.handler);	
	}		
	
	#endif
	
	return &DeviceConfig;
}

