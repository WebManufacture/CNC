#define MAX_EVENT_Subscriptions 128
#define MAX_MODULES_COUNT 32
#include "utils.h"

struct FactoryRecord {
	int type;
	int ver;
	long factoryID;
};

struct DeviceSettings{	
	unsigned char ClockSource: 2;
	unsigned char ClockDivider: 6;
	unsigned char WorkingMode;
	unsigned char setting3;
	unsigned char setting4;
	unsigned char setting5;
	unsigned char setting6;
	unsigned char setting7;
	unsigned char setting8;
};

#ifdef USE_EVENTS
	#include "events.h"

	struct EventSubscription{	
		unsigned char eventNum;
		EventHandler handler;
	};

	struct CONFIGURATION_STRUCT{	
		struct FactoryRecord factoryRec;
		struct DeviceSettings deviceSettings;
		char* moduleConfigs[MAX_MODULES_COUNT];
		struct EventSubscription events[MAX_EVENT_Subscriptions];		
	};
	
#else 
	struct CONFIGURATION_STRUCT{	
		struct FactoryRecord factoryRec;
		struct DeviceSettings deviceSettings;
		char* moduleConfigs[MAX_MODULES_COUNT];
	};
#endif

struct DeviceState{	
	uchar ResetFlag : 1;
	uchar DebugFlag : 1;
	uchar reservedFlag2 : 1;
	uchar reservedFlag3 : 1;
	uchar reservedFlag4 : 1;
	uchar reservedFlag5 : 1;
	uchar reservedFlag6 : 1;
	uchar reservedFlag7 : 1;	
};

extern @near struct DeviceState deviceState;
volatile struct CONFIGURATION_STRUCT DeviceConfig @0x4000;

struct CONFIGURATION_STRUCT* LoadConfiguration(void);
