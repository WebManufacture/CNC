#define UART_NONE_PARITY 0
#define UART_ODD_PARITY 1
#define UART_EVEN_PARITY 2

#define UART_PACKET_NO 0
#define UART_PACKET_SIMPLE 1
#define UART_PACKET_SIZED 2

#define UART_DATABITS_7 0
#define UART_DATABITS_8 1
#define UART_DATABITS_9 2

#ifndef DEFAULT_PACKET_SIZE 
#define DEFAULT_PACKET_SIZE 12
#endif

struct UartConfiguration{
	unsigned int speed;
	unsigned char parity : 2;
	unsigned char stopBits : 2;
	unsigned char dataBits : 2;
	unsigned char packetType : 2;
};

char InitUART_simple(uint speed);
char InitUART(struct UartConfiguration* config);
char CheckUart(void);
char* GetUartData(void);
void ClearUart(void);
void UartSendData(char* data, unsigned char size );
void UartSendMessage(uchar da, uchar dt, uchar sa, uchar st, char* data, uchar size);

#ifdef USE_EVENTS
signed char __evt_init_uart(char evt, char* data);
#endif

#ifdef USE_ROUTING

#define UartSend UartSendMessage

struct Message* GetUartMessage(void);
void UartSendMessageStruct(struct Message* message);
void UartSendSized(struct Message* message, unsigned char size);

#endif

