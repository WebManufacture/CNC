   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.8 - 03 Dec 2008
3768                     ; 8 struct CONFIGURATION_STRUCT* LoadConfiguration(void)
3768                     ; 9 {
3770                     	switch	.text
3771  0000               _LoadConfiguration:
3773  0000 88            	push	a
3774       00000001      OFST:	set	1
3777                     ; 10 	char i = 0;
3779  0001 0f01          	clr	(OFST+0,sp)
3780                     ; 24 	return &DeviceConfig;
3782  0003 ae4000        	ldw	x,#_DeviceConfig
3785  0006 84            	pop	a
3786  0007 81            	ret
3898                     	xdef	_LoadConfiguration
3899                     	switch	.bss
3900  0000               _deviceState:
3901  0000 00            	ds.b	1
3902                     	xdef	_deviceState
3922                     	end
