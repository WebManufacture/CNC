   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.8 - 03 Dec 2008
3697                     ; 48 char InitUART(struct UartConfiguration* cfg){
3699                     	switch	.text
3700  0000               _InitUART:
3702  0000 89            	pushw	x
3703       00000002      OFST:	set	2
3706                     ; 49 	uint speed = cfg->speed;
3708  0001 fe            	ldw	x,(x)
3709  0002 1f01          	ldw	(OFST-1,sp),x
3710                     ; 50 	UART_CR1 = 0; //PARITY ODD + 9Bit (8d+1p)
3712  0004 725f5244      	clr	_UART2_CR1
3713                     ; 51 	UART_CR2 = bit5 + bit3 + bit2; //  RXIE + RX + TX
3715  0008 352c5245      	mov	_UART2_CR2,#44
3716                     ; 52 	UART_CR3 = 0; //1 STOP
3718  000c 725f5246      	clr	_UART2_CR3
3719                     ; 53 	UART_CR4 = 0;
3721  0010 725f5247      	clr	_UART2_CR4
3722                     ; 54 	UART_CR5 = 0;
3724  0014 725f5248      	clr	_UART2_CR5
3725                     ; 60 	if (speed == 0) speed = 0x0368;
3727  0018 1e01          	ldw	x,(OFST-1,sp)
3728  001a 2605          	jrne	L1252
3731  001c ae0368        	ldw	x,#872
3732  001f 1f01          	ldw	(OFST-1,sp),x
3733  0021               L1252:
3734                     ; 62 	UART_BRR2 = speed >> 8;
3736  0021 7b01          	ld	a,(OFST-1,sp)
3737  0023 c75243        	ld	_UART2_BRR2,a
3738                     ; 63 	UART_BRR1 = speed;
3740  0026 7b02          	ld	a,(OFST+0,sp)
3741  0028 c75242        	ld	_UART2_BRR1,a
3742                     ; 65 	readDataBuf = (char*)&receiveBuffer;
3744  002b ae0028        	ldw	x,#_receiveBuffer
3745  002e bf52          	ldw	_readDataBuf,x
3746                     ; 75 		urState.size = DEFAULT_PACKET_SIZE;
3748  0030 35280059      	mov	_urState+1,#40
3749                     ; 78 	return 1;
3751  0034 a601          	ld	a,#1
3754  0036 85            	popw	x
3755  0037 81            	ret
3779                     ; 82 char CheckUart(void){
3780                     	switch	.text
3781  0038               _CheckUart:
3785                     ; 83 	return urState.phase == 06 ? urState.size : 0;
3787  0038 b658          	ld	a,_urState
3788  003a a106          	cp	a,#6
3789  003c 2604          	jrne	L01
3790  003e b659          	ld	a,_urState+1
3791  0040 2001          	jra	L21
3792  0042               L01:
3793  0042 4f            	clr	a
3794  0043               L21:
3797  0043 81            	ret
3823                     ; 86 char* GetUartData(void){
3824                     	switch	.text
3825  0044               _GetUartData:
3829                     ; 87 	if (urState.phase >= 6){
3831  0044 b658          	ld	a,_urState
3832  0046 a106          	cp	a,#6
3833  0048 2503          	jrult	L3452
3834                     ; 88 		return readDataBuf;
3836  004a be52          	ldw	x,_readDataBuf
3839  004c 81            	ret
3840  004d               L3452:
3841                     ; 91 		return 0;
3843  004d 5f            	clrw	x
3846  004e 81            	ret
3870                     ; 95 void ClearUart(void){
3871                     	switch	.text
3872  004f               _ClearUart:
3876                     ; 96 	urState.phase = 0;
3878  004f 3f58          	clr	_urState
3879                     ; 97 }
3882  0051 81            	ret
3906                     ; 99 void WaitSend(void){
3907                     	switch	.text
3908  0052               _WaitSend:
3912  0052               L1752:
3913                     ; 100 	while(uwState.phase > 0 && uwState.phase < 3){
3915  0052 3d54          	tnz	_uwState
3916  0054 2706          	jreq	L5752
3918  0056 b654          	ld	a,_uwState
3919  0058 a103          	cp	a,#3
3920  005a 25f6          	jrult	L1752
3921  005c               L5752:
3922                     ; 103 }
3925  005c 81            	ret
3973                     ; 105 void UartSendData(char* data, uchar size){
3974                     	switch	.text
3975  005d               _UartSendData:
3977  005d 89            	pushw	x
3978       00000000      OFST:	set	0
3981                     ; 106 	WaitSend();
3983  005e adf2          	call	_WaitSend
3985                     ; 107 	uwState.phase = 0;
3987  0060 3f54          	clr	_uwState
3988                     ; 108 	uwState.index = 0;
3990  0062 3f56          	clr	_uwState+2
3991                     ; 109 	uwState.size = size;
3993  0064 7b05          	ld	a,(OFST+5,sp)
3994  0066 b755          	ld	_uwState+1,a
3995                     ; 113 	writeDataBuf = data;
3997  0068 1e01          	ldw	x,(OFST+1,sp)
3998  006a bf50          	ldw	_writeDataBuf,x
3999                     ; 114 	UART_CR2 |= bit7;//(TIEN) TXE interrupt	
4001  006c 721e5245      	bset	_UART2_CR2,#7
4002                     ; 115 }
4005  0070 85            	popw	x
4006  0071 81            	ret
4097                     ; 117 void UartSendMessage(uchar da, uchar dt, uchar sa, uchar st, char* data, uchar size){
4098                     	switch	.text
4099  0072               _UartSendMessage:
4101  0072 89            	pushw	x
4102  0073 88            	push	a
4103       00000001      OFST:	set	1
4106                     ; 119 	size += 4;
4108  0074 7b0a          	ld	a,(OFST+9,sp)
4109  0076 ab04          	add	a,#4
4110  0078 6b0a          	ld	(OFST+9,sp),a
4111                     ; 120 	sendBuffer[0] = da;
4113  007a 9e            	ld	a,xh
4114  007b b700          	ld	_sendBuffer,a
4115                     ; 121 	sendBuffer[1] = dt;
4117  007d 9f            	ld	a,xl
4118  007e b701          	ld	_sendBuffer+1,a
4119                     ; 122 	sendBuffer[2] = sa;
4121  0080 7b06          	ld	a,(OFST+5,sp)
4122  0082 b702          	ld	_sendBuffer+2,a
4123                     ; 123 	sendBuffer[3] = st;
4125  0084 7b07          	ld	a,(OFST+6,sp)
4126  0086 b703          	ld	_sendBuffer+3,a
4127                     ; 124 	for (i = 4; i < size; i++){
4129  0088 a604          	ld	a,#4
4130  008a 6b01          	ld	(OFST+0,sp),a
4132  008c 2017          	jra	L3762
4133  008e               L7662:
4134                     ; 125 		sendBuffer[i] = data[i-4];
4136  008e 7b01          	ld	a,(OFST+0,sp)
4137  0090 5f            	clrw	x
4138  0091 97            	ld	xl,a
4139  0092 7b01          	ld	a,(OFST+0,sp)
4140  0094 905f          	clrw	y
4141  0096 9097          	ld	yl,a
4142  0098 72a20004      	subw	y,#4
4143  009c 72f908        	addw	y,(OFST+7,sp)
4144  009f 90f6          	ld	a,(y)
4145  00a1 e700          	ld	(_sendBuffer,x),a
4146                     ; 124 	for (i = 4; i < size; i++){
4148  00a3 0c01          	inc	(OFST+0,sp)
4149  00a5               L3762:
4152  00a5 7b01          	ld	a,(OFST+0,sp)
4153  00a7 110a          	cp	a,(OFST+9,sp)
4154  00a9 25e3          	jrult	L7662
4155                     ; 127 	UartSendData((char*)&sendBuffer, size);
4157  00ab 7b0a          	ld	a,(OFST+9,sp)
4158  00ad 88            	push	a
4159  00ae ae0000        	ldw	x,#_sendBuffer
4160  00b1 adaa          	call	_UartSendData
4162  00b3 84            	pop	a
4163                     ; 128 }
4166  00b4 5b03          	addw	sp,#3
4167  00b6 81            	ret
4205                     ; 180 void UART_RX_handler(void){
4206                     	switch	.text
4207  00b7               _UART_RX_handler:
4209  00b7 88            	push	a
4210       00000001      OFST:	set	1
4213                     ; 183 	_asm("SIM");
4216  00b8 9b            SIM
4218                     ; 184 	res(UART_SR,5);
4220  00b9 721b5240      	bres	_UART2_SR,#5
4221                     ; 185 	val = UART_DR;
4224  00bd c65241        	ld	a,_UART2_DR
4225  00c0 6b01          	ld	(OFST+0,sp),a
4226                     ; 186 	switch (urState.phase){
4228  00c2 b658          	ld	a,_urState
4230                     ; 221 		break;
4231  00c4 4d            	tnz	a
4232  00c5 275f          	jreq	L5072
4233  00c7 4a            	dec	a
4234  00c8 2746          	jreq	L3072
4235  00ca 4a            	dec	a
4236  00cb 2712          	jreq	L1072
4237  00cd 4a            	dec	a
4238  00ce 266c          	jrne	L7272
4239                     ; 187 		case 3: 
4239                     ; 188 			urState.phase = val == 3 ? 6 : 0;
4241  00d0 7b01          	ld	a,(OFST+0,sp)
4242  00d2 a103          	cp	a,#3
4243  00d4 2604          	jrne	L03
4244  00d6 a606          	ld	a,#6
4245  00d8 2001          	jra	L23
4246  00da               L03:
4247  00da 4f            	clr	a
4248  00db               L23:
4249  00db b758          	ld	_urState,a
4250                     ; 189 		break;
4252  00dd 205d          	jra	L7272
4253  00df               L1072:
4254                     ; 190 		case 2:
4254                     ; 191 			if (urState.index >= urState.size){
4256  00df b65a          	ld	a,_urState+2
4257  00e1 b159          	cp	a,_urState+1
4258  00e3 2519          	jrult	L1372
4259                     ; 192 				urState.phase = val == 3 ? 6 : (val == urState.crcCode ? 3 : 0);
4261  00e5 7b01          	ld	a,(OFST+0,sp)
4262  00e7 a103          	cp	a,#3
4263  00e9 2604          	jrne	L43
4264  00eb a606          	ld	a,#6
4265  00ed 200b          	jra	L63
4266  00ef               L43:
4267  00ef 7b01          	ld	a,(OFST+0,sp)
4268  00f1 b15b          	cp	a,_urState+3
4269  00f3 2604          	jrne	L04
4270  00f5 a603          	ld	a,#3
4271  00f7 2001          	jra	L24
4272  00f9               L04:
4273  00f9 4f            	clr	a
4274  00fa               L24:
4275  00fa               L63:
4276  00fa b758          	ld	_urState,a
4278  00fc 203e          	jra	L7272
4279  00fe               L1372:
4280                     ; 195 				receiveBuffer[urState.index] = val;
4282  00fe b65a          	ld	a,_urState+2
4283  0100 5f            	clrw	x
4284  0101 97            	ld	xl,a
4285  0102 7b01          	ld	a,(OFST+0,sp)
4286  0104 e728          	ld	(_receiveBuffer,x),a
4287                     ; 196 				urState.crcCode ^= val;
4289  0106 b65b          	ld	a,_urState+3
4290  0108 1801          	xor	a,	(OFST+0,sp)
4291  010a b75b          	ld	_urState+3,a
4292                     ; 197 				urState.index++;
4294  010c 3c5a          	inc	_urState+2
4295  010e 202c          	jra	L7272
4296  0110               L3072:
4297                     ; 200 		case 1:
4297                     ; 201 			if (val > 0){
4299  0110 0d01          	tnz	(OFST+0,sp)
4300  0112 270a          	jreq	L5372
4301                     ; 202 				urState.phase = 2;
4303  0114 35020058      	mov	_urState,#2
4304                     ; 203 				urState.size = val;				
4306  0118 7b01          	ld	a,(OFST+0,sp)
4307  011a b759          	ld	_urState+1,a
4309  011c 2004          	jra	L7372
4310  011e               L5372:
4311                     ; 206 				urState.phase = 0;
4313  011e 3f58          	clr	_urState
4314                     ; 207 				urState.size = 0;
4316  0120 3f59          	clr	_urState+1
4317  0122               L7372:
4318                     ; 209 			urState.index = 0;
4320  0122 3f5a          	clr	_urState+2
4321                     ; 210 		break;
4323  0124 2016          	jra	L7272
4324  0126               L5072:
4325                     ; 211 		case 0:
4325                     ; 212 			if (val == 1 || val == 2){
4327  0126 7b01          	ld	a,(OFST+0,sp)
4328  0128 a101          	cp	a,#1
4329  012a 2706          	jreq	L3472
4331  012c 7b01          	ld	a,(OFST+0,sp)
4332  012e a102          	cp	a,#2
4333  0130 2608          	jrne	L1472
4334  0132               L3472:
4335                     ; 216 				urState.crcCode = 222;
4337  0132 35de005b      	mov	_urState+3,#222
4338                     ; 218 				urState.phase = val;
4340  0136 7b01          	ld	a,(OFST+0,sp)
4341  0138 b758          	ld	_urState,a
4342  013a               L1472:
4343                     ; 220 			urState.index = 0;
4345  013a 3f5a          	clr	_urState+2
4346                     ; 221 		break;
4348  013c               L7272:
4349                     ; 223 	_asm("RIM");
4352  013c 9a            RIM
4354                     ; 224 }
4357  013d 84            	pop	a
4358  013e 81            	ret
4396                     ; 226 void UART_TX_handler(void){
4397                     	switch	.text
4398  013f               _UART_TX_handler:
4400  013f 88            	push	a
4401       00000001      OFST:	set	1
4404                     ; 229 	_asm("SIM");
4407  0140 9b            SIM
4409                     ; 230 	if (uwState.index >= uwState.size){
4411  0141 b656          	ld	a,_uwState+2
4412  0143 b155          	cp	a,_uwState+1
4413  0145 2516          	jrult	L3672
4414                     ; 231 		if (uwState.phase < 6){
4416  0147 b654          	ld	a,_uwState
4417  0149 a106          	cp	a,#6
4418  014b 240a          	jruge	L5672
4419                     ; 242 				UART_DR = 03;//EOT
4421  014d 35035241      	mov	_UART2_DR,#3
4422                     ; 243 				uwState.phase = 6;
4424  0151 35060054      	mov	_uwState,#6
4426  0155 203d          	jra	L1772
4427  0157               L5672:
4428                     ; 247 			UART_CR2 = UART_CR2 & ~bit7; //UART TX OFF
4430  0157 721f5245      	bres	_UART2_CR2,#7
4431  015b 2037          	jra	L1772
4432  015d               L3672:
4433                     ; 251 		if (uwState.phase == 2){
4435  015d b654          	ld	a,_uwState
4436  015f a102          	cp	a,#2
4437  0161 2616          	jrne	L3772
4438                     ; 252 			val = writeDataBuf[uwState.index];
4440  0163 b656          	ld	a,_uwState+2
4441  0165 5f            	clrw	x
4442  0166 97            	ld	xl,a
4443  0167 92d650        	ld	a,([_writeDataBuf.w],x)
4444  016a 6b01          	ld	(OFST+0,sp),a
4445                     ; 253 			UART_DR = val;
4447  016c 7b01          	ld	a,(OFST+0,sp)
4448  016e c75241        	ld	_UART2_DR,a
4449                     ; 254 			uwState.index++;			
4451  0171 3c56          	inc	_uwState+2
4452                     ; 255 			uwState.crcCode ^= val;
4454  0173 b657          	ld	a,_uwState+3
4455  0175 1801          	xor	a,	(OFST+0,sp)
4456  0177 b757          	ld	_uwState+3,a
4457  0179               L3772:
4458                     ; 257 		if (uwState.phase == 1){
4460  0179 b654          	ld	a,_uwState
4461  017b a101          	cp	a,#1
4462  017d 2609          	jrne	L5772
4463                     ; 258 			UART_DR = uwState.size;
4465  017f 5500555241    	mov	_UART2_DR,_uwState+1
4466                     ; 259 			uwState.phase = 2;
4468  0184 35020054      	mov	_uwState,#2
4469  0188               L5772:
4470                     ; 261 		if (uwState.phase == 0){
4472  0188 3d54          	tnz	_uwState
4473  018a 2608          	jrne	L1772
4474                     ; 266 			UART_DR = 1;//SOH
4476  018c 35015241      	mov	_UART2_DR,#1
4477                     ; 267 			uwState.phase = 1;
4479  0190 35010054      	mov	_uwState,#1
4480  0194               L1772:
4481                     ; 274 	_asm("RIM");
4484  0194 9a            RIM
4486                     ; 275 }
4489  0195 84            	pop	a
4490  0196 81            	ret
4514                     ; 278 @interrupt void UART_RX_IRQHandler(void){
4515                     	switch	.text
4516  0197               _UART_RX_IRQHandler:
4518  0197 3b0002        	push	c_x+2
4519  019a be00          	ldw	x,c_x
4520  019c 89            	pushw	x
4521  019d 3b0002        	push	c_y+2
4522  01a0 be00          	ldw	x,c_y
4523  01a2 89            	pushw	x
4526                     ; 279 	UART_RX_handler();
4528  01a3 cd00b7        	call	_UART_RX_handler
4530                     ; 280 }
4533  01a6 85            	popw	x
4534  01a7 bf00          	ldw	c_y,x
4535  01a9 320002        	pop	c_y+2
4536  01ac 85            	popw	x
4537  01ad bf00          	ldw	c_x,x
4538  01af 320002        	pop	c_x+2
4539  01b2 80            	iret
4563                     ; 282 @interrupt void UART_TX_IRQHandler(void){
4564                     	switch	.text
4565  01b3               _UART_TX_IRQHandler:
4567  01b3 3b0002        	push	c_x+2
4568  01b6 be00          	ldw	x,c_x
4569  01b8 89            	pushw	x
4570  01b9 3b0002        	push	c_y+2
4571  01bc be00          	ldw	x,c_y
4572  01be 89            	pushw	x
4575                     ; 283 	UART_TX_handler();
4577  01bf cd013f        	call	_UART_TX_handler
4579                     ; 284 }
4582  01c2 85            	popw	x
4583  01c3 bf00          	ldw	c_y,x
4584  01c5 320002        	pop	c_y+2
4585  01c8 85            	popw	x
4586  01c9 bf00          	ldw	c_x,x
4587  01cb 320002        	pop	c_x+2
4588  01ce 80            	iret
4698                     	xdef	_UART_TX_IRQHandler
4699                     	xdef	_UART_RX_IRQHandler
4700                     	xdef	_UART_TX_handler
4701                     	xdef	_UART_RX_handler
4702                     	xdef	_WaitSend
4703                     	switch	.ubsct
4704  0000               _sendBuffer:
4705  0000 000000000000  	ds.b	40
4706                     	xdef	_sendBuffer
4707  0028               _receiveBuffer:
4708  0028 000000000000  	ds.b	40
4709                     	xdef	_receiveBuffer
4710  0050               _writeDataBuf:
4711  0050 0000          	ds.b	2
4712                     	xdef	_writeDataBuf
4713  0052               _readDataBuf:
4714  0052 0000          	ds.b	2
4715                     	xdef	_readDataBuf
4716  0054               _uwState:
4717  0054 00000000      	ds.b	4
4718                     	xdef	_uwState
4719  0058               _urState:
4720  0058 00000000      	ds.b	4
4721                     	xdef	_urState
4722                     	xdef	_UartSendMessage
4723                     	xdef	_UartSendData
4724                     	xdef	_ClearUart
4725                     	xdef	_GetUartData
4726                     	xdef	_CheckUart
4727                     	xdef	_InitUART
4728                     	xref.b	c_x
4729                     	xref.b	c_y
4749                     	end
