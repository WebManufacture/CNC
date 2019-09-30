#define waitLimit 1000000
#define holdInterval 3000
#define downInterval 140
#define downCounter 100
#define upInterval 100
#define upCounter 100

struct Button{
	unsigned char pressed : 1;
	unsigned char falled : 1;
	unsigned char otherBtnPressed : 1;
	unsigned char state : 5;
	unsigned char ticks;
	unsigned char passes;
	struct Port *port;
	unsigned char mask;
	unsigned long time;
};

typedef void (*ButtonHandler)(struct Button *button);

extern void RegisterButtonHandler(struct Button *button, ButtonHandler handler);
