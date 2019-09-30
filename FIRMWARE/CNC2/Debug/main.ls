   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.8 - 03 Dec 2008
3401                     .const:	section	.text
3402  0000               _uartConfig:
3403  0000 0b08          	dc.w	2824
3404  0002 02            	dc.b	2
3447                     ; 13 void init(void){	
3449                     	switch	.text
3450  0000               _init:
3454                     ; 14 	CLK_CKDIVR = 0;
3456  0000 725f50c6      	clr	_CLK_CKDIVR
3457                     ; 18 	PG.DDR = 03;
3459  0004 35035020      	mov	_PG+2,#3
3460                     ; 19 	PG.CR1 = 03;
3462  0008 35035021      	mov	_PG+3,#3
3463                     ; 20 	PG.CR2 = 0;
3465  000c 725f5022      	clr	_PG+4
3466                     ; 21 	PG.Out = 03;
3468  0010 3503501e      	mov	_PG,#3
3469                     ; 23 	PE.DDR = bit0;
3471  0014 35015016      	mov	_PE+2,#1
3472                     ; 24   PE.CR1 = bit0;
3474  0018 35015017      	mov	_PE+3,#1
3475                     ; 25 	PE.CR2 = 0;
3477  001c 725f5018      	clr	_PE+4
3478                     ; 26 	PE.Out = bit0;
3480  0020 35015014      	mov	_PE,#1
3481                     ; 29 	initMotors();
3483  0024 cd0000        	call	_initMotors
3485                     ; 30 	InitUART(&uartConfig);
3487  0027 ae0000        	ldw	x,#_uartConfig
3488  002a cd0000        	call	_InitUART
3490                     ; 31 	initCommands();
3492  002d cd0000        	call	_initCommands
3494                     ; 33 	_asm("rim");
3497  0030 9a            rim
3499                     ; 34 }
3502  0031 81            	ret
3618                     ; 36 void main(void){	 
3619                     	switch	.text
3620  0032               _main:
3622  0032 89            	pushw	x
3623       00000002      OFST:	set	2
3626                     ; 38 	init();
3628  0033 adcb          	call	_init
3630                     ; 39 	LEDS_OFF
3632  0035 c6501e        	ld	a,_PG_ODR
3633  0038 aa03          	or	a,#3
3634  003a c7501e        	ld	_PG_ODR,a
3637  003d 72105014      	bset	_PE_ODR,#0
3638                     ; 40 	LED_RED_ON
3640  0041 7211501e      	bres	_PG_ODR,#0
3641                     ; 41 	LED_BLUE_ON
3643  0045 72115014      	bres	_PE_ODR,#0
3644                     ; 42 	Delay(600000);
3646  0049 ae27c0        	ldw	x,#10176
3647  004c 89            	pushw	x
3648  004d ae0009        	ldw	x,#9
3649  0050 89            	pushw	x
3650  0051 cd0000        	call	_Delay
3652  0054 5b04          	addw	sp,#4
3653                     ; 43 	LEDS_OFF
3655  0056 c6501e        	ld	a,_PG_ODR
3656  0059 aa03          	or	a,#3
3657  005b c7501e        	ld	_PG_ODR,a
3660  005e 72105014      	bset	_PE_ODR,#0
3661  0062               L5242:
3662                     ; 45 		if (CheckUart()){
3664  0062 cd0000        	call	_CheckUart
3666  0065 4d            	tnz	a
3667  0066 270d          	jreq	L1342
3668                     ; 46 			command = (InCommandPtr)(GetUartData());
3670  0068 cd0000        	call	_GetUartData
3672  006b 1f01          	ldw	(OFST-1,sp),x
3673                     ; 47 			processCommand(command);
3675  006d 1e01          	ldw	x,(OFST-1,sp)
3676  006f cd0000        	call	_processCommand
3678                     ; 48 			ClearUart();
3680  0072 cd0000        	call	_ClearUart
3682  0075               L1342:
3683                     ; 50 		idleCommand();
3685  0075 cd0000        	call	_idleCommand
3688  0078 20e8          	jra	L5242
3767                     	xdef	_main
3768                     	xdef	_init
3769                     	xdef	_uartConfig
3770                     	xref	_Delay
3771                     	xref	_initMotors
3772                     	xref	_processCommand
3773                     	xref	_idleCommand
3774                     	xref	_initCommands
3775                     	xref	_ClearUart
3776                     	xref	_GetUartData
3777                     	xref	_CheckUart
3778                     	xref	_InitUART
3797                     	end
