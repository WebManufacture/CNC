#define menuMin 1
#define defaultMenuSize 5

#define MENU_VALUE_NONE 0
#define MENU_VALUE_BOOL 1
#define MENU_VALUE_NUM  4
#define MENU_VALUE_SIGNED_NUM 5
#define MENU_VALUE_LIST 10

extern char menuSize;

struct MenuModeDescriptor{
	unsigned char valueType;
	unsigned long* valueAddr;
	unsigned long minValue;
	unsigned long maxValue;
	unsigned char symbolsMask[6];
	char* symbolsMasksList;
};

extern struct MenuModeDescriptor menu[];

void InitMenu(void);
void SelectNextMenu(void);

void IncMenuValue(unsigned long value);
void DecMenuValue(unsigned long value);
void SelectMenu(char menuIndex);
void ShowMenu(struct MenuModeDescriptor* subMenu);
unsigned char GetMenuIndex(void);

