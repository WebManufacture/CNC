#define SEGCOMMAND_ARR_ASCII 1
#define SEGCOMMAND_CLEAR     2
#define SEGCOMMAND_ARR_DRAFT 5
#define SEGCOMMAND_ARR_SYM   10
#define SEGCOMMAND_BYTE      20
#define SEGCOMMAND_INT       30
#define SEGCOMMAND_SIGNED    40
#define SEGCOMMAND_DRAFT     50
#define SEGCOMMAND_SYM       51

#define SLAVE_ADDRESS 0x89

#define segA bit0
#define segB bit2
#define segC bit6
#define segD bit5
#define segE bit3
#define segF bit1
#define segG bit4
#define segH bit7


void SegmentsSendCommand(char com);

unsigned char SegmentsSendData(void);

void SegmentsSendClear(void);

void SegmentsClearAll(void);

void SegmentsShowSym(signed short dta, char pos);

void SegmentsShowNum(unsigned long  dta);

void SegmentsSendLong(long  dta);

void SegmentsShowBigNum(unsigned long  dta);
       
// SEGMENTS:
//    a
//   ---
// b| g |f
//   ---
// c|   |e
//   ---   .h
//    d
/*
const unsigned char SymbolCodes[39] = {
	segB + segA + segF + segC + segE + segD, // 0
	segF + segE, //1
	segA + segF + segG + segC + segD, //2
	segA + segF + segG + segE + segD, //3
	segB + segG + segF + segE, //4
	segA + segB + segG + segE + segD, //5
	segA + segB + segG + segC + segE + segD, //6
	segA + segF + segE, //7
	~segH, //8
	~segH - segC, //9
	~segH - segD, //10 A
	~segH - segA - segF, //11 b
	segA + segB + segC + segD, //12 C
	~segH - segA - segB, //13 d
	~segH - segF - segE, //14 E
	segA + segB + segC + segG, //15 F
	~segH - segC, //16 g
	~segH - segA - segD, //17 H
	segC, //18 i
	segF + segE + segD + segC, //19 J
	segA + segG + segD, //20 k
	segB + segC + segD, //21 L
	segA + segB + segC + segE, //22 m
	segC + segG + segE, //23 n
	segC + segG + segE + segD, //24 o
	~segH - segD - segE, //25 P
	~segH - segC - segD, //26 q
	segC - segG, //27 r
	segA + segB + segG + segE + segD, //28 S
	segB + segG + segC + segD,  //29 t
	segC + segD + segE,  //30 u
	segC + segD + segE + segB + segF,  //31 U
	segB + segE,  //32 x
	~segH - segA - segC,  //33 Y
	segB + segG + segE,  //34 z
	segH,  //35 .
	segF + segH,  //36 !
	segG,  //37 -
	255  //38 8.
	0,
};*/
