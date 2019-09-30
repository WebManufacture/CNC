   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.8 - 03 Dec 2008
3626                     ; 4 signed char __evt_init_clock(char event, char* data){
3628                     	switch	.text
3629  0000               ___evt_init_clock:
3633                     ; 5 	if (DeviceConfig.deviceSettings.ClockSource) {
3635  0000 c64008        	ld	a,_DeviceConfig+8
3636  0003 a503          	bcp	a,#3
3637  0005 2716          	jreq	L5642
3638                     ; 6 		CLK_ECKR = 0;//HSEEN Разрешаем работу генератора с внешним кварцем (HSEEN)
3640  0007 725f50c1      	clr	_CLK_ECKR
3641                     ; 7 		CLK_SWCR = 1;//SWENРазрешаем переключение генераторов;
3643  000b 350150c5      	mov	_CLK_SWCR,#1
3644                     ; 8 		CLK_SWR = 0xB4 ;//Выбираем clock от кварцевого генератора (HSE)
3646  000f 35b450c4      	mov	_CLK_SWR,#180
3647                     ; 9 		CLK_CKDIVR = DeviceConfig.deviceSettings.ClockDivider;
3649  0013 c64008        	ld	a,_DeviceConfig+8
3650  0016 44            	srl	a
3651  0017 44            	srl	a
3652  0018 c750c6        	ld	_CLK_CKDIVR,a
3654  001b 2008          	jra	L7642
3655  001d               L5642:
3656                     ; 12 		CLK_CKDIVR = DeviceConfig.deviceSettings.ClockDivider;
3658  001d c64008        	ld	a,_DeviceConfig+8
3659  0020 44            	srl	a
3660  0021 44            	srl	a
3661  0022 c750c6        	ld	_CLK_CKDIVR,a
3662  0025               L7642:
3663                     ; 14 }
3666  0025 81            	ret
3709                     ; 16 signed char sign (signed long x, signed long y) {
3710                     	switch	.text
3711  0026               _sign:
3713       00000000      OFST:	set	0
3716                     ; 17 		return x == y ? 0 : (x > y) ? 1 : -1;
3718  0026 96            	ldw	x,sp
3719  0027 1c0003        	addw	x,#OFST+3
3720  002a cd0000        	call	c_ltor
3722  002d 96            	ldw	x,sp
3723  002e 1c0007        	addw	x,#OFST+7
3724  0031 cd0000        	call	c_lcmp
3726  0034 2603          	jrne	L01
3727  0036 4f            	clr	a
3728  0037 2017          	jra	L21
3729  0039               L01:
3730  0039 9c            	rvf
3731  003a 96            	ldw	x,sp
3732  003b 1c0003        	addw	x,#OFST+3
3733  003e cd0000        	call	c_ltor
3735  0041 96            	ldw	x,sp
3736  0042 1c0007        	addw	x,#OFST+7
3737  0045 cd0000        	call	c_lcmp
3739  0048 2d04          	jrsle	L41
3740  004a a601          	ld	a,#1
3741  004c 2002          	jra	L61
3742  004e               L41:
3743  004e a6ff          	ld	a,#255
3744  0050               L61:
3745  0050               L21:
3748  0050 81            	ret
3782                     ; 21 signed long abs(signed long x) {
3783                     	switch	.text
3784  0051               _abs:
3786       00000000      OFST:	set	0
3789                     ; 22 	if (x < 0){
3791  0051 9c            	rvf
3792  0052 0d03          	tnz	(OFST+3,sp)
3793  0054 2e0b          	jrsge	L1352
3794                     ; 23 		return -x;
3796  0056 96            	ldw	x,sp
3797  0057 1c0003        	addw	x,#OFST+3
3798  005a cd0000        	call	c_ltor
3800  005d cd0000        	call	c_lneg
3804  0060 81            	ret
3805  0061               L1352:
3806                     ; 25 	return x;
3808  0061 96            	ldw	x,sp
3809  0062 1c0003        	addw	x,#OFST+3
3810  0065 cd0000        	call	c_ltor
3814  0068 81            	ret
3850                     ; 28 void UnblockEEPROM(void){
3851                     	switch	.text
3852  0069               _UnblockEEPROM:
3854  0069 88            	push	a
3855       00000001      OFST:	set	1
3858                     ; 30 	dataState = FLASH_IAPSR;
3860  006a c6505f        	ld	a,_FLASH_IAPSR
3861  006d 6b01          	ld	(OFST+0,sp),a
3862                     ; 31 	dataState &= bit3;
3864  006f 7b01          	ld	a,(OFST+0,sp)
3865  0071 a408          	and	a,#8
3866  0073 6b01          	ld	(OFST+0,sp),a
3867                     ; 32 	if (dataState == 0){
3869  0075 0d01          	tnz	(OFST+0,sp)
3870  0077 2608          	jrne	L1552
3871                     ; 33 		FLASH_DUKR = 0xAE;
3873  0079 35ae5064      	mov	_FLASH_DUKR,#174
3874                     ; 34 		FLASH_DUKR = 0x56;
3876  007d 35565064      	mov	_FLASH_DUKR,#86
3877  0081               L1552:
3878                     ; 36 }
3881  0081 84            	pop	a
3882  0082 81            	ret
3918                     ; 38 void UnblockFLASH(void){
3919                     	switch	.text
3920  0083               _UnblockFLASH:
3922  0083 88            	push	a
3923       00000001      OFST:	set	1
3926                     ; 40 	dataState = FLASH_IAPSR;
3928  0084 c6505f        	ld	a,_FLASH_IAPSR
3929  0087 6b01          	ld	(OFST+0,sp),a
3930                     ; 41 	dataState &= bit3;
3932  0089 7b01          	ld	a,(OFST+0,sp)
3933  008b a408          	and	a,#8
3934  008d 6b01          	ld	(OFST+0,sp),a
3935                     ; 42 	if (dataState == 0){
3937  008f 0d01          	tnz	(OFST+0,sp)
3938  0091 2608          	jrne	L1752
3939                     ; 43 		FLASH_PUKR = 0x56;
3941  0093 35565062      	mov	_FLASH_PUKR,#86
3942                     ; 44 		FLASH_PUKR = 0xAE;
3944  0097 35ae5062      	mov	_FLASH_PUKR,#174
3945  009b               L1752:
3946                     ; 46 }
3949  009b 84            	pop	a
3950  009c 81            	ret
3994                     ; 48 void Delay(long waitCalc){
3995                     	switch	.text
3996  009d               _Delay:
3998  009d 5204          	subw	sp,#4
3999       00000004      OFST:	set	4
4002                     ; 50 	for (i = waitCalc; i > 0; i--){
4004  009f 1e09          	ldw	x,(OFST+5,sp)
4005  00a1 1f03          	ldw	(OFST-1,sp),x
4006  00a3 1e07          	ldw	x,(OFST+3,sp)
4007  00a5 1f01          	ldw	(OFST-3,sp),x
4009  00a7 200a          	jra	L1262
4010  00a9               L5162:
4011                     ; 51 		_asm("nop");
4014  00a9 9d            nop
4016                     ; 50 	for (i = waitCalc; i > 0; i--){
4018  00aa 96            	ldw	x,sp
4019  00ab 1c0001        	addw	x,#OFST-3
4020  00ae a601          	ld	a,#1
4021  00b0 cd0000        	call	c_lgsbc
4023  00b3               L1262:
4026  00b3 9c            	rvf
4027  00b4 96            	ldw	x,sp
4028  00b5 1c0001        	addw	x,#OFST-3
4029  00b8 cd0000        	call	c_lzmp
4031  00bb 2cec          	jrsgt	L5162
4032                     ; 53 }
4035  00bd 5b04          	addw	sp,#4
4036  00bf 81            	ret
4060                     ; 55 void Reset(void){
4061                     	switch	.text
4062  00c0               _Reset:
4066                     ; 56 	WWDG_CR = bit7;
4068  00c0 358050d1      	mov	_WWDG_CR,#128
4069                     ; 57 }
4072  00c4 81            	ret
4085                     	xdef	_Reset
4086                     	xdef	_UnblockFLASH
4087                     	xdef	_UnblockEEPROM
4088                     	xdef	_Delay
4089                     	xdef	_abs
4090                     	xdef	_sign
4091                     	xdef	___evt_init_clock
4110                     	xref	c_lzmp
4111                     	xref	c_lgsbc
4112                     	xref	c_lneg
4113                     	xref	c_lcmp
4114                     	xref	c_ltor
4115                     	end
