   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.8 - 03 Dec 2008
3405                     	bsct
3406  0000               _stateSended:
3407  0000 00            	dc.b	0
3408  0001               _stopPending:
3409  0001 00            	dc.b	0
3410  0002               _currentCommand:
3411  0002 00            	dc.b	0
3446                     ; 35 void push(void){
3448                     	switch	.text
3449  0000               _push:
3453                     ; 43 }
3456  0000 81            	ret
3479                     ; 45 void pop(void){
3480                     	switch	.text
3481  0001               _pop:
3485                     ; 53 }        
3488  0001 81            	ret
3530                     ; 56 void sendTable(char command){
3531                     	switch	.text
3532  0002               _sendTable:
3536                     ; 57 	OutCommand.address = 06;//Adress
3538  0002 35060000      	mov	_OutCommand,#6
3539                     ; 58 	OutCommand.command = command;
3541  0006 c70001        	ld	_OutCommand+1,a
3542                     ; 59 	OutCommand.X = mX.Steps;
3544  0009 be02          	ldw	x,_mX+2
3545  000b cf0009        	ldw	_OutCommand+9,x
3546  000e be00          	ldw	x,_mX
3547  0010 cf0007        	ldw	_OutCommand+7,x
3548                     ; 60 	OutCommand.Y = mY.Steps;
3550  0013 be02          	ldw	x,_mY+2
3551  0015 cf000d        	ldw	_OutCommand+13,x
3552  0018 be00          	ldw	x,_mY
3553  001a cf000b        	ldw	_OutCommand+11,x
3554                     ; 61 	OutCommand.Z = mZ.Steps;
3556  001d be02          	ldw	x,_mZ+2
3557  001f cf0011        	ldw	_OutCommand+17,x
3558  0022 be00          	ldw	x,_mZ
3559  0024 cf000f        	ldw	_OutCommand+15,x
3560                     ; 62 	OutCommand.XL = mX.Limit;
3562  0027 be06          	ldw	x,_mX+6
3563  0029 cf0015        	ldw	_OutCommand+21,x
3564  002c be04          	ldw	x,_mX+4
3565  002e cf0013        	ldw	_OutCommand+19,x
3566                     ; 63 	OutCommand.YL = mY.Limit;
3568  0031 be06          	ldw	x,_mY+6
3569  0033 cf0019        	ldw	_OutCommand+25,x
3570  0036 be04          	ldw	x,_mY+4
3571  0038 cf0017        	ldw	_OutCommand+23,x
3572                     ; 64 	OutCommand.ZL = mZ.Limit;
3574  003b be06          	ldw	x,_mZ+6
3575  003d cf001d        	ldw	_OutCommand+29,x
3576  0040 be04          	ldw	x,_mZ+4
3577  0042 cf001b        	ldw	_OutCommand+27,x
3578                     ; 65 	OutCommand.state = current.state;
3580  0045 5500090002    	mov	_OutCommand+2,_current+9
3581                     ; 66 	OutCommand.line = current.line;
3583  004a be06          	ldw	x,_current+6
3584  004c cf0005        	ldw	_OutCommand+5,x
3585  004f be04          	ldw	x,_current+4
3586  0051 cf0003        	ldw	_OutCommand+3,x
3587                     ; 67 	OutCommand.paramA = PA_IDR;
3589  0054 555001001f    	mov	_OutCommand+31,_PA_IDR
3590                     ; 68 	OutCommand.paramB = PB_IDR;
3592  0059 5550060020    	mov	_OutCommand+32,_PB_IDR
3593                     ; 69 	UartSendData((char*)(&OutCommand), sizeof(OutCommand));
3595  005e 4b21          	push	#33
3596  0060 ae0000        	ldw	x,#_OutCommand
3597  0063 cd0000        	call	_UartSendData
3599  0066 84            	pop	a
3600                     ; 70 }
3603  0067 81            	ret
3678                     ; 73 void sendState(char command, char state, char line, char A, char B){
3679                     	switch	.text
3680  0068               _sendState:
3682  0068 89            	pushw	x
3683       00000000      OFST:	set	0
3686                     ; 74 	OutCommand.address = 06;//Adress
3688  0069 35060000      	mov	_OutCommand,#6
3689                     ; 75 	OutCommand.command = command;
3691  006d 9e            	ld	a,xh
3692  006e c70001        	ld	_OutCommand+1,a
3693                     ; 76 	OutCommand.X = mX.Steps;
3695  0071 be02          	ldw	x,_mX+2
3696  0073 cf0009        	ldw	_OutCommand+9,x
3697  0076 be00          	ldw	x,_mX
3698  0078 cf0007        	ldw	_OutCommand+7,x
3699                     ; 77 	OutCommand.Y = mY.Steps;
3701  007b be02          	ldw	x,_mY+2
3702  007d cf000d        	ldw	_OutCommand+13,x
3703  0080 be00          	ldw	x,_mY
3704  0082 cf000b        	ldw	_OutCommand+11,x
3705                     ; 78 	OutCommand.Z = mZ.Steps;
3707  0085 be02          	ldw	x,_mZ+2
3708  0087 cf0011        	ldw	_OutCommand+17,x
3709  008a be00          	ldw	x,_mZ
3710  008c cf000f        	ldw	_OutCommand+15,x
3711                     ; 79 	OutCommand.XL = mX.Limit;
3713  008f be06          	ldw	x,_mX+6
3714  0091 cf0015        	ldw	_OutCommand+21,x
3715  0094 be04          	ldw	x,_mX+4
3716  0096 cf0013        	ldw	_OutCommand+19,x
3717                     ; 80 	OutCommand.YL = mY.Limit;
3719  0099 be06          	ldw	x,_mY+6
3720  009b cf0019        	ldw	_OutCommand+25,x
3721  009e be04          	ldw	x,_mY+4
3722  00a0 cf0017        	ldw	_OutCommand+23,x
3723                     ; 81 	OutCommand.ZL = mZ.Limit;
3725  00a3 be06          	ldw	x,_mZ+6
3726  00a5 cf001d        	ldw	_OutCommand+29,x
3727  00a8 be04          	ldw	x,_mZ+4
3728  00aa cf001b        	ldw	_OutCommand+27,x
3729                     ; 82 	OutCommand.state = state;
3731  00ad 7b02          	ld	a,(OFST+2,sp)
3732  00af c70002        	ld	_OutCommand+2,a
3733                     ; 83 	OutCommand.line = line;
3735  00b2 7b05          	ld	a,(OFST+5,sp)
3736  00b4 c70006        	ld	_OutCommand+6,a
3737  00b7 4f            	clr	a
3738  00b8 c70005        	ld	_OutCommand+5,a
3739  00bb c70004        	ld	_OutCommand+4,a
3740  00be c70003        	ld	_OutCommand+3,a
3741                     ; 84 	OutCommand.paramA = A;
3743  00c1 7b06          	ld	a,(OFST+6,sp)
3744  00c3 c7001f        	ld	_OutCommand+31,a
3745                     ; 85 	OutCommand.paramB = B;
3747  00c6 7b07          	ld	a,(OFST+7,sp)
3748  00c8 c70020        	ld	_OutCommand+32,a
3749                     ; 86 	UartSendData((char*)(&OutCommand), sizeof(OutCommand));
3751  00cb 4b21          	push	#33
3752  00cd ae0000        	ldw	x,#_OutCommand
3753  00d0 cd0000        	call	_UartSendData
3755  00d3 84            	pop	a
3756                     ; 87 }
3759  00d4 85            	popw	x
3760  00d5 81            	ret
3786                     ; 90 void initCommands(void){
3787                     	switch	.text
3788  00d6               _initCommands:
3792                     ; 91 	current.state = 9;
3794  00d6 35090009      	mov	_current+9,#9
3795                     ; 92 	current.line = RST_ST;
3797  00da c650b3        	ld	a,_RST_ST
3798  00dd b707          	ld	_current+7,a
3799  00df 3f06          	clr	_current+6
3800  00e1 3f05          	clr	_current+5
3801  00e3 3f04          	clr	_current+4
3802                     ; 93 	current.currentSpeed = 10000;
3804  00e5 ae2710        	ldw	x,#10000
3805  00e8 bf00          	ldw	_current,x
3806                     ; 94 	current.maxSpeed = 0;
3808  00ea 5f            	clrw	x
3809  00eb bf02          	ldw	_current+2,x
3810                     ; 96   sendTable(0);
3812  00ed 4f            	clr	a
3813  00ee cd0002        	call	_sendTable
3815                     ; 98 	current.state = 0;
3817  00f1 3f09          	clr	_current+9
3818                     ; 99 	current.line = 0;
3820  00f3 ae0000        	ldw	x,#0
3821  00f6 bf06          	ldw	_current+6,x
3822  00f8 ae0000        	ldw	x,#0
3823  00fb bf04          	ldw	_current+4,x
3824                     ; 100 }
3827  00fd 81            	ret
3863                     ; 103 void setState(char state){
3864                     	switch	.text
3865  00fe               _setState:
3869                     ; 104 	current.state = state;
3871  00fe b709          	ld	_current+9,a
3872                     ; 105 	stateSended = 0;
3874  0100 3f00          	clr	_stateSended
3875                     ; 106 }
3878  0102 81            	ret
3902                     ; 108 void moving_finished(void){
3903                     	switch	.text
3904  0103               _moving_finished:
3908                     ; 109 	stopPending = 1;
3910  0103 35010001      	mov	_stopPending,#1
3911                     ; 110 }
3914  0107 81            	ret
3960                     ; 112 void idleCommand(void){
3961                     	switch	.text
3962  0108               _idleCommand:
3964  0108 88            	push	a
3965       00000001      OFST:	set	1
3968                     ; 114 	if (current.state == 1 && (ticks > 50 || lastA != PA_IDR)){
3970  0109 b609          	ld	a,_current+9
3971  010b a101          	cp	a,#1
3972  010d 2619          	jrne	L7152
3974  010f b610          	ld	a,_ticks
3975  0111 a133          	cp	a,#51
3976  0113 2407          	jruge	L1252
3978  0115 b60f          	ld	a,_lastA
3979  0117 c15001        	cp	a,_PA_IDR
3980  011a 270c          	jreq	L7152
3981  011c               L1252:
3982                     ; 115 		lastA = PA_IDR;
3984  011c 555001000f    	mov	_lastA,_PA_IDR
3985                     ; 116 		ticks = 0;
3987  0121 3f10          	clr	_ticks
3988                     ; 117 		sendTable(current.command);
3990  0123 b608          	ld	a,_current+8
3991  0125 cd0002        	call	_sendTable
3993  0128               L7152:
3994                     ; 119 	if (stateSended == 0){
3996  0128 3d00          	tnz	_stateSended
3997  012a 2615          	jrne	L3252
3998                     ; 120 		sendTable(current.command);
4000  012c b608          	ld	a,_current+8
4001  012e cd0002        	call	_sendTable
4003                     ; 121 		if (current.state == 2){
4005  0131 b609          	ld	a,_current+9
4006  0133 a102          	cp	a,#2
4007  0135 2606          	jrne	L5252
4008                     ; 122 			current.state = 0;
4010  0137 3f09          	clr	_current+9
4011                     ; 123 			current.waitingMaskA = 0;
4013  0139 3f0a          	clr	_current+10
4014                     ; 124 			current.waitingMaskB = 0;
4016  013b 3f0b          	clr	_current+11
4017  013d               L5252:
4018                     ; 126 		stateSended = 1;
4020  013d 35010000      	mov	_stateSended,#1
4021  0141               L3252:
4022                     ; 128 	if (stopPending){
4024  0141 3d01          	tnz	_stopPending
4025  0143 2714          	jreq	L7252
4026                     ; 129 		motor_stop();
4028  0145 cd0000        	call	_motor_stop
4030                     ; 130 		stopPending = 0;
4032  0148 3f01          	clr	_stopPending
4033                     ; 131 		current.state = 2;
4035  014a 35020009      	mov	_current+9,#2
4036                     ; 132 		sendTable(current.command);
4038  014e b608          	ld	a,_current+8
4039  0150 cd0002        	call	_sendTable
4041                     ; 133 		current.state = 0;
4043  0153 3f09          	clr	_current+9
4044                     ; 134 		current.waitingMaskA = 0;
4046  0155 3f0a          	clr	_current+10
4047                     ; 135 		current.waitingMaskB = 0;
4049  0157 3f0b          	clr	_current+11
4050  0159               L7252:
4051                     ; 137 	if (current.state != 1 && lastA != PA_IDR && waitCicles == 0){
4053  0159 b609          	ld	a,_current+9
4054  015b a101          	cp	a,#1
4055  015d 271a          	jreq	L1352
4057  015f b60f          	ld	a,_lastA
4058  0161 c15001        	cp	a,_PA_IDR
4059  0164 2713          	jreq	L1352
4061  0166 be0d          	ldw	x,_waitCicles
4062  0168 260f          	jrne	L1352
4063                     ; 138 		lastA = PA_IDR;
4065  016a 555001000f    	mov	_lastA,_PA_IDR
4066                     ; 139 		waitCicles = 30;
4068  016f ae001e        	ldw	x,#30
4069  0172 bf0d          	ldw	_waitCicles,x
4070                     ; 140 		sendTable(18);//ENDS COMMAND
4072  0174 a612          	ld	a,#18
4073  0176 cd0002        	call	_sendTable
4075  0179               L1352:
4076                     ; 142 	mask = PB_IDR & 244;	
4078  0179 c65006        	ld	a,_PB_IDR
4079  017c a4f4          	and	a,#244
4080  017e 6b01          	ld	(OFST+0,sp),a
4081                     ; 143 	if (waitCicles == 0){
4083  0180 be0d          	ldw	x,_waitCicles
4084  0182 2629          	jrne	L3352
4085                     ; 144 		if (current.state == 1){
4087  0184 b609          	ld	a,_current+9
4088  0186 a101          	cp	a,#1
4089  0188 260f          	jrne	L5352
4090                     ; 145 			if ((mask & 16) == 0){
4092  018a 7b01          	ld	a,(OFST+0,sp)
4093  018c a510          	bcp	a,#16
4094  018e 261d          	jrne	L3352
4095                     ; 146 				waitCicles = 30;
4097  0190 ae001e        	ldw	x,#30
4098  0193 bf0d          	ldw	_waitCicles,x
4099                     ; 147 				pause();
4101  0195 ad47          	call	_pause
4103  0197 2014          	jra	L3352
4104  0199               L5352:
4105                     ; 151 			if (lastB != mask){
4107  0199 b60c          	ld	a,_lastB
4108  019b 1101          	cp	a,(OFST+0,sp)
4109  019d 270e          	jreq	L3352
4110                     ; 152 				lastB = mask;
4112  019f 7b01          	ld	a,(OFST+0,sp)
4113  01a1 b70c          	ld	_lastB,a
4114                     ; 153 				waitCicles = 30;
4116  01a3 ae001e        	ldw	x,#30
4117  01a6 bf0d          	ldw	_waitCicles,x
4118                     ; 154 				sendTable(19);//ENDS COMMAND
4120  01a8 a613          	ld	a,#19
4121  01aa cd0002        	call	_sendTable
4123  01ad               L3352:
4124                     ; 158 	if (waitCicles > 0){
4126  01ad 9c            	rvf
4127  01ae be0d          	ldw	x,_waitCicles
4128  01b0 2d07          	jrsle	L5452
4129                     ; 159 		waitCicles--;
4131  01b2 be0d          	ldw	x,_waitCicles
4132  01b4 1d0001        	subw	x,#1
4133  01b7 bf0d          	ldw	_waitCicles,x
4134  01b9               L5452:
4135                     ; 161 }
4138  01b9 84            	pop	a
4139  01ba 81            	ret
4248                     ; 163 void processCommand(InCommandPtr command){
4249                     	switch	.text
4250  01bb               _processCommand:
4254                     ; 164 	current.command = command->command;
4256  01bb e601          	ld	a,(1,x)
4257  01bd b708          	ld	_current+8,a
4258                     ; 165 	current.line = command->line;
4260  01bf e607          	ld	a,(7,x)
4261  01c1 b707          	ld	_current+7,a
4262  01c3 e606          	ld	a,(6,x)
4263  01c5 b706          	ld	_current+6,a
4264  01c7 e605          	ld	a,(5,x)
4265  01c9 b705          	ld	_current+5,a
4266  01cb e604          	ld	a,(4,x)
4267  01cd b704          	ld	_current+4,a
4268                     ; 166 	commands[current.command](command);
4270  01cf b608          	ld	a,_current+8
4271  01d1 905f          	clrw	y
4272  01d3 9097          	ld	yl,a
4273  01d5 9058          	sllw	y
4274  01d7 90de0000      	ldw	y,(_commands,y)
4275  01db 90fd          	call	(y)
4277                     ; 167 	return;
4280  01dd 81            	ret
4308                     ; 170 void pause(void){
4309                     	switch	.text
4310  01de               _pause:
4314                     ; 171 	if (current.state == 1){
4316  01de b609          	ld	a,_current+9
4317  01e0 a101          	cp	a,#1
4318  01e2 2603          	jrne	L5262
4319                     ; 172 		motor_stop();
4321  01e4 cd0000        	call	_motor_stop
4323  01e7               L5262:
4324                     ; 174 	LEDS_OFF
4326  01e7 c6501e        	ld	a,_PG_ODR
4327  01ea aa03          	or	a,#3
4328  01ec c7501e        	ld	_PG_ODR,a
4331  01ef 72105014      	bset	_PE_ODR,#0
4332                     ; 175 	LED_RED_ON
4334  01f3 7211501e      	bres	_PG_ODR,#0
4335                     ; 176 	LED_GREEN_ON
4337  01f7 7213501e      	bres	_PG_ODR,#1
4338                     ; 177 	setState(3);
4340  01fb a603          	ld	a,#3
4341  01fd cd00fe        	call	_setState
4343                     ; 178 }
4346  0200 81            	ret
4374                     ; 180 void error(void){
4375                     	switch	.text
4376  0201               _error:
4380                     ; 181 	if (current.state == 1){
4382  0201 b609          	ld	a,_current+9
4383  0203 a101          	cp	a,#1
4384  0205 2603          	jrne	L7362
4385                     ; 182 		motor_stop();
4387  0207 cd0000        	call	_motor_stop
4389  020a               L7362:
4390                     ; 184 	LEDS_OFF
4392  020a c6501e        	ld	a,_PG_ODR
4393  020d aa03          	or	a,#3
4394  020f c7501e        	ld	_PG_ODR,a
4397  0212 72105014      	bset	_PE_ODR,#0
4398                     ; 185 	LED_RED_ON
4400  0216 7211501e      	bres	_PG_ODR,#0
4401                     ; 186 	setState(4);
4403  021a a604          	ld	a,#4
4404  021c cd00fe        	call	_setState
4406                     ; 187 }
4409  021f 81            	ret
4435                     ; 189 void resume(void){
4436                     	switch	.text
4437  0220               _resume:
4441                     ; 190 	if (current.state > 1){
4443  0220 b609          	ld	a,_current+9
4444  0222 a102          	cp	a,#2
4445  0224 250a          	jrult	L1562
4446                     ; 191 		motor_start(current.currentSpeed);
4448  0226 be00          	ldw	x,_current
4449  0228 cd0000        	call	_motor_start
4451                     ; 192 		setState(1);
4453  022b a601          	ld	a,#1
4454  022d cd00fe        	call	_setState
4456  0230               L1562:
4457                     ; 194 }
4460  0230 81            	ret
4487                     ; 196 void stop(void){
4488                     	switch	.text
4489  0231               _stop:
4493                     ; 197 	motor_stop();
4495  0231 cd0000        	call	_motor_stop
4497                     ; 198 	setState(0);
4499  0234 4f            	clr	a
4500  0235 cd00fe        	call	_setState
4502                     ; 199 	LEDS_OFF
4504  0238 c6501e        	ld	a,_PG_ODR
4505  023b aa03          	or	a,#3
4506  023d c7501e        	ld	_PG_ODR,a
4509  0240 72105014      	bset	_PE_ODR,#0
4510                     ; 200 }
4513  0244 81            	ret
4551                     ; 203 void StopCommand(InCommandPtr cmd){		//3
4552                     	switch	.text
4553  0245               _StopCommand:
4557                     ; 204 	stop();
4559  0245 adea          	call	_stop
4561                     ; 205 }
4564  0247 81            	ret
4603                     ; 207 void StateCommand(InCommandPtr cmd){ //4
4604                     	switch	.text
4605  0248               _StateCommand:
4609                     ; 208 	sendTable(current.command);
4611  0248 b608          	ld	a,_current+8
4612  024a cd0002        	call	_sendTable
4614                     ; 209 }
4617  024d 81            	ret
4656                     ; 211 void WaitMaskCommand(InCommandPtr cmd){ //10
4657                     	switch	.text
4658  024e               _WaitMaskCommand:
4662                     ; 212 	sendTable(current.command);
4664  024e b608          	ld	a,_current+8
4665  0250 cd0002        	call	_sendTable
4667                     ; 213 	current.state = 2;
4669  0253 35020009      	mov	_current+9,#2
4670                     ; 214 }
4673  0257 81            	ret
4713                     ; 216 void PauseCommand(InCommandPtr cmd) {//6
4714                     	switch	.text
4715  0258               _PauseCommand:
4719                     ; 217 	pause();
4721  0258 ad84          	call	_pause
4723                     ; 218 	sendTable(current.command);
4725  025a b608          	ld	a,_current+8
4726  025c cd0002        	call	_sendTable
4728                     ; 219 }
4731  025f 81            	ret
4771                     ; 221 void ResumeCommand(InCommandPtr cmd) {//7
4772                     	switch	.text
4773  0260               _ResumeCommand:
4777                     ; 222 	resume();
4779  0260 adbe          	call	_resume
4781                     ; 223 	sendTable(current.command);
4783  0262 b608          	ld	a,_current+8
4784  0264 cd0002        	call	_sendTable
4786                     ; 224 }	
4789  0267 81            	ret
4826                     ; 226 void InternalCommand(InCommandPtr cmd) {//11
4827                     	switch	.text
4828  0268               _InternalCommand:
4832                     ; 227 }
4835  0268 81            	ret
4873                     ; 229 void ResetCommand(InCommandPtr cmd) {//12
4874                     	switch	.text
4875  0269               _ResetCommand:
4879                     ; 230 	Reset();
4881  0269 cd0000        	call	_Reset
4883                     ; 231 }
4886  026c 81            	ret
4924                     ; 233 void SpindleCommand(InCommandPtr cmd){//8, 9
4925                     	switch	.text
4926  026d               _SpindleCommand:
4930                     ; 234 	PC_ODR = cmd->paramA;
4932  026d e614          	ld	a,(20,x)
4933  026f c7500a        	ld	_PC_ODR,a
4934                     ; 235 }
4937  0272 81            	ret
4988                     ; 237 void MoveCommand(InCommandPtr cmd){ // 1, 5
4989                     	switch	.text
4990  0273               _MoveCommand:
4992  0273 89            	pushw	x
4993       00000000      OFST:	set	0
4996                     ; 238 	if (cmd->command == 5){
4998  0274 e601          	ld	a,(1,x)
4999  0276 a105          	cp	a,#5
5000  0278 2646          	jrne	L3013
5001                     ; 239 		 cmd->x = cmd->x + mX.Steps;
5003  027a b603          	ld	a,_mX+3
5004  027c b703          	ld	c_lreg+3,a
5005  027e b602          	ld	a,_mX+2
5006  0280 b702          	ld	c_lreg+2,a
5007  0282 b601          	ld	a,_mX+1
5008  0284 b701          	ld	c_lreg+1,a
5009  0286 b600          	ld	a,_mX
5010  0288 b700          	ld	c_lreg,a
5011  028a 1c0008        	addw	x,#8
5012  028d cd0000        	call	c_lgadd
5014                     ; 240 		 cmd->y = cmd->y + mY.Steps;
5016  0290 1e01          	ldw	x,(OFST+1,sp)
5017  0292 b603          	ld	a,_mY+3
5018  0294 b703          	ld	c_lreg+3,a
5019  0296 b602          	ld	a,_mY+2
5020  0298 b702          	ld	c_lreg+2,a
5021  029a b601          	ld	a,_mY+1
5022  029c b701          	ld	c_lreg+1,a
5023  029e b600          	ld	a,_mY
5024  02a0 b700          	ld	c_lreg,a
5025  02a2 1c000c        	addw	x,#12
5026  02a5 cd0000        	call	c_lgadd
5028                     ; 241 		 cmd->z = cmd->z + mZ.Steps;
5030  02a8 1e01          	ldw	x,(OFST+1,sp)
5031  02aa b603          	ld	a,_mZ+3
5032  02ac b703          	ld	c_lreg+3,a
5033  02ae b602          	ld	a,_mZ+2
5034  02b0 b702          	ld	c_lreg+2,a
5035  02b2 b601          	ld	a,_mZ+1
5036  02b4 b701          	ld	c_lreg+1,a
5037  02b6 b600          	ld	a,_mZ
5038  02b8 b700          	ld	c_lreg,a
5039  02ba 1c0010        	addw	x,#16
5040  02bd cd0000        	call	c_lgadd
5042  02c0               L3013:
5043                     ; 243 	motor_stop();
5045  02c0 cd0000        	call	_motor_stop
5047                     ; 244 	if (cmd->speed > 0){
5049  02c3 1e01          	ldw	x,(OFST+1,sp)
5050  02c5 e603          	ld	a,(3,x)
5051  02c7 ea02          	or	a,(2,x)
5052  02c9 270c          	jreq	L5013
5053                     ; 245 		current.currentSpeed = cmd->speed;
5055  02cb 1e01          	ldw	x,(OFST+1,sp)
5056  02cd ee02          	ldw	x,(2,x)
5057  02cf bf00          	ldw	_current,x
5058                     ; 246 		current.maxSpeed = cmd->speed;
5060  02d1 1e01          	ldw	x,(OFST+1,sp)
5061  02d3 ee02          	ldw	x,(2,x)
5062  02d5 bf02          	ldw	_current+2,x
5063  02d7               L5013:
5064                     ; 248 	if (cmd->x == mX.Steps && cmd->y == mY.Steps && cmd->z == mZ.Steps)
5066  02d7 1e01          	ldw	x,(OFST+1,sp)
5067  02d9 1c0008        	addw	x,#8
5068  02dc cd0000        	call	c_ltor
5070  02df ae0000        	ldw	x,#_mX
5071  02e2 cd0000        	call	c_lcmp
5073  02e5 2637          	jrne	L7013
5075  02e7 1e01          	ldw	x,(OFST+1,sp)
5076  02e9 1c000c        	addw	x,#12
5077  02ec cd0000        	call	c_ltor
5079  02ef ae0000        	ldw	x,#_mY
5080  02f2 cd0000        	call	c_lcmp
5082  02f5 2627          	jrne	L7013
5084  02f7 1e01          	ldw	x,(OFST+1,sp)
5085  02f9 1c0010        	addw	x,#16
5086  02fc cd0000        	call	c_ltor
5088  02ff ae0000        	ldw	x,#_mZ
5089  0302 cd0000        	call	c_lcmp
5091  0305 2617          	jrne	L7013
5092                     ; 250 		current.line = cmd->line;
5094  0307 1e01          	ldw	x,(OFST+1,sp)
5095  0309 e607          	ld	a,(7,x)
5096  030b b707          	ld	_current+7,a
5097  030d e606          	ld	a,(6,x)
5098  030f b706          	ld	_current+6,a
5099  0311 e605          	ld	a,(5,x)
5100  0313 b705          	ld	_current+5,a
5101  0315 e604          	ld	a,(4,x)
5102  0317 b704          	ld	_current+4,a
5103                     ; 251 		moving_finished();
5105  0319 cd0103        	call	_moving_finished
5107                     ; 252 		return;
5109  031c 202f          	jra	L06
5110  031e               L7013:
5111                     ; 254 	current.waitingMaskA = cmd->paramA;
5113  031e 1e01          	ldw	x,(OFST+1,sp)
5114  0320 e614          	ld	a,(20,x)
5115  0322 b70a          	ld	_current+10,a
5116                     ; 255 	current.waitingMaskB = cmd->paramB;
5118  0324 1e01          	ldw	x,(OFST+1,sp)
5119  0326 e615          	ld	a,(21,x)
5120  0328 b70b          	ld	_current+11,a
5121                     ; 256 	current.line = cmd->line;
5123  032a 1e01          	ldw	x,(OFST+1,sp)
5124  032c e607          	ld	a,(7,x)
5125  032e b707          	ld	_current+7,a
5126  0330 e606          	ld	a,(6,x)
5127  0332 b706          	ld	_current+6,a
5128  0334 e605          	ld	a,(5,x)
5129  0336 b705          	ld	_current+5,a
5130  0338 e604          	ld	a,(4,x)
5131  033a b704          	ld	_current+4,a
5132                     ; 257 	loadCommand(cmd);
5134  033c 1e01          	ldw	x,(OFST+1,sp)
5135  033e cd0000        	call	_loadCommand
5137                     ; 258 	if (!CheckBtns()){
5139  0341 cd0000        	call	_CheckBtns
5141  0344 4d            	tnz	a
5142  0345 2608          	jrne	L1113
5143                     ; 259 		motor_stop();
5145  0347 cd0000        	call	_motor_stop
5147                     ; 260 		pause();
5149  034a cd01de        	call	_pause
5151                     ; 261 		return;
5152  034d               L06:
5155  034d 85            	popw	x
5156  034e 81            	ret
5157  034f               L1113:
5158                     ; 263 	if (!CheckEnds()){
5160  034f cd0000        	call	_CheckEnds
5162  0352 4d            	tnz	a
5163  0353 2608          	jrne	L3113
5164                     ; 264 		motor_stop();
5166  0355 cd0000        	call	_motor_stop
5168                     ; 265 		error();
5170  0358 cd0201        	call	_error
5172                     ; 266 		return;
5174  035b 20f0          	jra	L06
5175  035d               L3113:
5176                     ; 268 	ticks = 0;
5178  035d 3f10          	clr	_ticks
5179                     ; 269 	setState(1);
5181  035f a601          	ld	a,#1
5182  0361 cd00fe        	call	_setState
5184                     ; 270 	motor_start(current.currentSpeed);
5186  0364 be00          	ldw	x,_current
5187  0366 cd0000        	call	_motor_start
5189                     ; 271 	return;
5191  0369 20e2          	jra	L06
5232                     ; 274 void RebaseCommand(InCommandPtr cmd){ //2
5233                     	switch	.text
5234  036b               _RebaseCommand:
5236  036b 89            	pushw	x
5237       00000000      OFST:	set	0
5240                     ; 275 	mX.Steps = cmd->x;		
5242  036c e60b          	ld	a,(11,x)
5243  036e b703          	ld	_mX+3,a
5244  0370 e60a          	ld	a,(10,x)
5245  0372 b702          	ld	_mX+2,a
5246  0374 e609          	ld	a,(9,x)
5247  0376 b701          	ld	_mX+1,a
5248  0378 e608          	ld	a,(8,x)
5249  037a b700          	ld	_mX,a
5250                     ; 276 	mY.Steps = cmd->y;	
5252  037c e60f          	ld	a,(15,x)
5253  037e b703          	ld	_mY+3,a
5254  0380 e60e          	ld	a,(14,x)
5255  0382 b702          	ld	_mY+2,a
5256  0384 e60d          	ld	a,(13,x)
5257  0386 b701          	ld	_mY+1,a
5258  0388 e60c          	ld	a,(12,x)
5259  038a b700          	ld	_mY,a
5260                     ; 277 	mZ.Steps = cmd->z;
5262  038c e613          	ld	a,(19,x)
5263  038e b703          	ld	_mZ+3,a
5264  0390 e612          	ld	a,(18,x)
5265  0392 b702          	ld	_mZ+2,a
5266  0394 e611          	ld	a,(17,x)
5267  0396 b701          	ld	_mZ+1,a
5268  0398 e610          	ld	a,(16,x)
5269  039a b700          	ld	_mZ,a
5270                     ; 278 	mX.Limit = 0;		
5272  039c ae0000        	ldw	x,#0
5273  039f bf06          	ldw	_mX+6,x
5274  03a1 ae0000        	ldw	x,#0
5275  03a4 bf04          	ldw	_mX+4,x
5276                     ; 279 	mY.Limit = 0;	
5278  03a6 ae0000        	ldw	x,#0
5279  03a9 bf06          	ldw	_mY+6,x
5280  03ab ae0000        	ldw	x,#0
5281  03ae bf04          	ldw	_mY+4,x
5282                     ; 280 	mZ.Limit = 0;	
5284  03b0 ae0000        	ldw	x,#0
5285  03b3 bf06          	ldw	_mZ+6,x
5286  03b5 ae0000        	ldw	x,#0
5287  03b8 bf04          	ldw	_mZ+4,x
5288                     ; 281 	mX.Dir = 0;
5290  03ba 3f10          	clr	_mX+16
5291                     ; 282 	mY.Dir = 0;
5293  03bc 3f10          	clr	_mY+16
5294                     ; 283 	mZ.Dir = 0;
5296  03be 3f10          	clr	_mZ+16
5297                     ; 284 	mX.Delta = 0;
5299  03c0 ae0000        	ldw	x,#0
5300  03c3 bf0e          	ldw	_mX+14,x
5301  03c5 ae0000        	ldw	x,#0
5302  03c8 bf0c          	ldw	_mX+12,x
5303                     ; 285 	mY.Delta = 0;
5305  03ca ae0000        	ldw	x,#0
5306  03cd bf0e          	ldw	_mY+14,x
5307  03cf ae0000        	ldw	x,#0
5308  03d2 bf0c          	ldw	_mY+12,x
5309                     ; 286 	mZ.Delta = 0;	
5311  03d4 ae0000        	ldw	x,#0
5312  03d7 bf0e          	ldw	_mZ+14,x
5313  03d9 ae0000        	ldw	x,#0
5314  03dc bf0c          	ldw	_mZ+12,x
5315                     ; 287 	sendTable(cmd->command);
5317  03de 1e01          	ldw	x,(OFST+1,sp)
5318  03e0 e601          	ld	a,(1,x)
5319  03e2 cd0002        	call	_sendTable
5321                     ; 288 	return;
5324  03e5 85            	popw	x
5325  03e6 81            	ret
5377                     ; 291 void ConfigCommand(InCommandPtr cmd){ //13
5378                     	switch	.text
5379  03e7               _ConfigCommand:
5381  03e7 89            	pushw	x
5382  03e8 88            	push	a
5383       00000001      OFST:	set	1
5386                     ; 293 	if (cmd->speed = 1){
5388  03e9 90ae0001      	ldw	y,#1
5389  03ed ef02          	ldw	(2,x),y
5390  03ef e603          	ld	a,(3,x)
5391  03f1 ea02          	or	a,(2,x)
5392  03f3 2771          	jreq	L1613
5393                     ; 294 		OutCommand.address = 06;//Adress
5395  03f5 35060000      	mov	_OutCommand,#6
5396                     ; 295 		OutCommand.command = 12;
5398  03f9 350c0001      	mov	_OutCommand+1,#12
5399                     ; 296 		OutCommand.X = config.X;
5401  03fd ce4002        	ldw	x,_config+2
5402  0400 cf0009        	ldw	_OutCommand+9,x
5403  0403 ce4000        	ldw	x,_config
5404  0406 cf0007        	ldw	_OutCommand+7,x
5405                     ; 297 		OutCommand.Y = config.Y;
5407  0409 ce4006        	ldw	x,_config+6
5408  040c cf000d        	ldw	_OutCommand+13,x
5409  040f ce4004        	ldw	x,_config+4
5410  0412 cf000b        	ldw	_OutCommand+11,x
5411                     ; 298 		OutCommand.Z = config.Z;
5413  0415 ce400a        	ldw	x,_config+10
5414  0418 cf0011        	ldw	_OutCommand+17,x
5415  041b ce4008        	ldw	x,_config+8
5416  041e cf000f        	ldw	_OutCommand+15,x
5417                     ; 299 		OutCommand.XL = 0;
5419  0421 ae0000        	ldw	x,#0
5420  0424 cf0015        	ldw	_OutCommand+21,x
5421  0427 ae0000        	ldw	x,#0
5422  042a cf0013        	ldw	_OutCommand+19,x
5423                     ; 300 		OutCommand.YL = 0;
5425  042d ae0000        	ldw	x,#0
5426  0430 cf0019        	ldw	_OutCommand+25,x
5427  0433 ae0000        	ldw	x,#0
5428  0436 cf0017        	ldw	_OutCommand+23,x
5429                     ; 301 		OutCommand.ZL = 0;
5431  0439 ae0000        	ldw	x,#0
5432  043c cf001d        	ldw	_OutCommand+29,x
5433  043f ae0000        	ldw	x,#0
5434  0442 cf001b        	ldw	_OutCommand+27,x
5435                     ; 302 		OutCommand.state = 1;
5437  0445 35010002      	mov	_OutCommand+2,#1
5438                     ; 303 		OutCommand.line = current.line;
5440  0449 be06          	ldw	x,_current+6
5441  044b cf0005        	ldw	_OutCommand+5,x
5442  044e be04          	ldw	x,_current+4
5443  0450 cf0003        	ldw	_OutCommand+3,x
5444                     ; 304 		OutCommand.paramA = config.settingsA;
5446  0453 554010001f    	mov	_OutCommand+31,_config+16
5447                     ; 305 		OutCommand.paramB = config.settingsB;
5449  0458 5540110020    	mov	_OutCommand+32,_config+17
5450                     ; 306 		UartSendData((char*)(&OutCommand), sizeof(OutCommand));
5452  045d 4b21          	push	#33
5453  045f ae0000        	ldw	x,#_OutCommand
5454  0462 cd0000        	call	_UartSendData
5456  0465 84            	pop	a
5457  0466               L1613:
5458                     ; 308 	if (cmd->speed = 2){
5460  0466 1e02          	ldw	x,(OFST+1,sp)
5461  0468 90ae0002      	ldw	y,#2
5462  046c ef02          	ldw	(2,x),y
5463  046e e603          	ld	a,(3,x)
5464  0470 ea02          	or	a,(2,x)
5465  0472 2767          	jreq	L3613
5466                     ; 309 		dataState = FLASH_IAPSR;
5468  0474 c6505f        	ld	a,_FLASH_IAPSR
5469  0477 6b01          	ld	(OFST+0,sp),a
5470                     ; 310 		dataState &= bit3;
5472  0479 7b01          	ld	a,(OFST+0,sp)
5473  047b a408          	and	a,#8
5474  047d 6b01          	ld	(OFST+0,sp),a
5475                     ; 311 		if (dataState == 0){
5477  047f 0d01          	tnz	(OFST+0,sp)
5478  0481 2608          	jrne	L5613
5479                     ; 312 			FLASH_DUKR = 0xAE;
5481  0483 35ae5064      	mov	_FLASH_DUKR,#174
5482                     ; 313 			FLASH_DUKR = 0x56;
5484  0487 35565064      	mov	_FLASH_DUKR,#86
5485  048b               L5613:
5486                     ; 315 		config.X = cmd->x;
5488  048b 1e02          	ldw	x,(OFST+1,sp)
5489  048d e60b          	ld	a,(11,x)
5490  048f c74003        	ld	_config+3,a
5491  0492 e60a          	ld	a,(10,x)
5492  0494 c74002        	ld	_config+2,a
5493  0497 e609          	ld	a,(9,x)
5494  0499 c74001        	ld	_config+1,a
5495  049c e608          	ld	a,(8,x)
5496  049e c74000        	ld	_config,a
5497                     ; 316 		config.Y = cmd->y;
5499  04a1 1e02          	ldw	x,(OFST+1,sp)
5500  04a3 e60f          	ld	a,(15,x)
5501  04a5 c74007        	ld	_config+7,a
5502  04a8 e60e          	ld	a,(14,x)
5503  04aa c74006        	ld	_config+6,a
5504  04ad e60d          	ld	a,(13,x)
5505  04af c74005        	ld	_config+5,a
5506  04b2 e60c          	ld	a,(12,x)
5507  04b4 c74004        	ld	_config+4,a
5508                     ; 317 		config.Z = cmd->z;
5510  04b7 1e02          	ldw	x,(OFST+1,sp)
5511  04b9 e613          	ld	a,(19,x)
5512  04bb c7400b        	ld	_config+11,a
5513  04be e612          	ld	a,(18,x)
5514  04c0 c7400a        	ld	_config+10,a
5515  04c3 e611          	ld	a,(17,x)
5516  04c5 c74009        	ld	_config+9,a
5517  04c8 e610          	ld	a,(16,x)
5518  04ca c74008        	ld	_config+8,a
5519                     ; 318 		config.settingsA = cmd->paramA;
5521  04cd 1e02          	ldw	x,(OFST+1,sp)
5522  04cf e614          	ld	a,(20,x)
5523  04d1 c74010        	ld	_config+16,a
5524                     ; 319 		config.settingsB = cmd->paramB;
5526  04d4 1e02          	ldw	x,(OFST+1,sp)
5527  04d6 e615          	ld	a,(21,x)
5528  04d8 c74011        	ld	_config+17,a
5529  04db               L3613:
5530                     ; 321 	return;
5533  04db 5b03          	addw	sp,#3
5534  04dd 81            	ret
5572                     ; 325 void BufferFlush(InCommandPtr cmd){ //13
5573                     	switch	.text
5574  04de               _BufferFlush:
5578                     ; 326 	currentCommand = 0;
5580  04de 3f02          	clr	_currentCommand
5581                     ; 327 	return;
5584  04e0 81            	ret
5587                     .const:	section	.text
5588  0000               _commands:
5590  0000 0248          	dc.w	_StateCommand
5592  0002 0273          	dc.w	_MoveCommand
5594  0004 036b          	dc.w	_RebaseCommand
5596  0006 0245          	dc.w	_StopCommand
5598  0008 0248          	dc.w	_StateCommand
5600  000a 0273          	dc.w	_MoveCommand
5602  000c 0258          	dc.w	_PauseCommand
5604  000e 0260          	dc.w	_ResumeCommand
5606  0010 026d          	dc.w	_SpindleCommand
5608  0012 026d          	dc.w	_SpindleCommand
5610  0014 024e          	dc.w	_WaitMaskCommand
5612  0016 03e7          	dc.w	_ConfigCommand
5614  0018 0269          	dc.w	_ResetCommand
5616  001a 04de          	dc.w	_BufferFlush
5617  001c 0000          	dc.w	0
5619  001e 0273          	dc.w	_MoveCommand
5620  0020 0000          	dc.w	0
5621  0022 0000          	dc.w	0
5622  0024 0000          	dc.w	0
5623  0026 0000          	dc.w	0
5949                     	xdef	_BufferFlush
5950                     	xdef	_ConfigCommand
5951                     	xdef	_RebaseCommand
5952                     	xdef	_MoveCommand
5953                     	xdef	_SpindleCommand
5954                     	xdef	_ResetCommand
5955                     	xdef	_InternalCommand
5956                     	xdef	_ResumeCommand
5957                     	xdef	_PauseCommand
5958                     	xdef	_WaitMaskCommand
5959                     	xdef	_StateCommand
5960                     	xdef	_StopCommand
5961                     	xdef	_sendState
5962                     	xdef	_sendTable
5963                     	xdef	_pop
5964                     	xdef	_push
5965                     	switch	.ubsct
5966  0000               _current:
5967  0000 000000000000  	ds.b	12
5968                     	xdef	_current
5969                     	switch	.bss
5970  0000               _OutCommand:
5971  0000 000000000000  	ds.b	33
5972                     	xdef	_OutCommand
5973  0021               _Buffer:
5974  0021 000000000000  	ds.b	44
5975                     	xdef	_Buffer
5976                     	switch	.ubsct
5977  000c               _lastB:
5978  000c 00            	ds.b	1
5979                     	xdef	_lastB
5980  000d               _waitCicles:
5981  000d 0000          	ds.b	2
5982                     	xdef	_waitCicles
5983  000f               _lastA:
5984  000f 00            	ds.b	1
5985                     	xdef	_lastA
5986                     	xdef	_currentCommand
5987  0010               _ticks:
5988  0010 00            	ds.b	1
5989                     	xdef	_ticks
5990                     	xdef	_stopPending
5991                     	xdef	_stateSended
5992                     	xdef	_commands
5993                     	xref.b	_mZ
5994                     	xref.b	_mY
5995                     	xref.b	_mX
5996                     	xref	_Reset
5997                     	xref	_CheckBtns
5998                     	xref	_CheckEnds
5999                     	xref	_loadCommand
6000                     	xref	_motor_start
6001                     	xref	_motor_stop
6002                     	xdef	_stop
6003                     	xdef	_resume
6004                     	xdef	_error
6005                     	xdef	_pause
6006                     	xdef	_setState
6007                     	xdef	_processCommand
6008                     	xdef	_idleCommand
6009                     	xdef	_initCommands
6010                     	xdef	_moving_finished
6011                     	xref	_UartSendData
6012                     	xref.b	c_lreg
6032                     	xref	c_lcmp
6033                     	xref	c_ltor
6034                     	xref	c_lgadd
6035                     	end
