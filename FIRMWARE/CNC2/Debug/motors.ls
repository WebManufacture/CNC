   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Generator V4.2.8 - 03 Dec 2008
3452                     ; 18 void initMotors(){
3454                     	switch	.text
3455  0000               _initMotors:
3459                     ; 19 	mX.coef = 1;
3461  0000 35010069      	mov	_mX+21,#1
3462                     ; 20 	mY.coef = 1;
3464  0004 35010042      	mov	_mY+21,#1
3465                     ; 21 	mZ.coef = 1;
3467  0008 3501001b      	mov	_mZ+21,#1
3468                     ; 23 	mX.out = &PE_ODR;
3470  000c ae5014        	ldw	x,#_PE_ODR
3471  000f bf77          	ldw	_mX+35,x
3472                     ; 24 	mX.port = &PE;
3474  0011 ae5014        	ldw	x,#_PE
3475  0014 bf79          	ldw	_mX+37,x
3476                     ; 25 	mX.mask = 0b00010111;
3478  0016 3517006d      	mov	_mX+25,#23
3479                     ; 26 	mX.stopMask = 0b00010111;
3481  001a 3517006e      	mov	_mX+26,#23
3482                     ; 27 	mX.phases[0] = 0b10000000;
3484  001e 3580006f      	mov	_mX+27,#128
3485                     ; 28 	mX.phases[1] = 0b10100000;
3487  0022 35a00070      	mov	_mX+28,#160
3488                     ; 29 	mX.phases[2] = 0b00100000;
3490  0026 35200071      	mov	_mX+29,#32
3491                     ; 30 	mX.phases[3] = 0b01100000;
3493  002a 35600072      	mov	_mX+30,#96
3494                     ; 31 	mX.phases[4] = 0b01000000;
3496  002e 35400073      	mov	_mX+31,#64
3497                     ; 32 	mX.phases[5] = 0b01001000;
3499  0032 35480074      	mov	_mX+32,#72
3500                     ; 33 	mX.phases[6] = 0b00001000;
3502  0036 35080075      	mov	_mX+33,#8
3503                     ; 34 	mX.phases[7] = 0b10001000;	
3505  003a 35880076      	mov	_mX+34,#136
3506                     ; 36 	mY.out = &PD_ODR;
3508  003e ae500f        	ldw	x,#_PD_ODR
3509  0041 bf50          	ldw	_mY+35,x
3510                     ; 37 	mY.port = &PD;
3512  0043 ae500f        	ldw	x,#_PD
3513  0046 bf52          	ldw	_mY+37,x
3514                     ; 38 	mY.mask = 0b11100010;
3516  0048 35e20046      	mov	_mY+25,#226
3517                     ; 39 	mY.stopMask = 0b11100010;
3519  004c 35e20047      	mov	_mY+26,#226
3520                     ; 40 	mY.phases[0] = 0b00010000;
3522  0050 35100048      	mov	_mY+27,#16
3523                     ; 41 	mY.phases[1] = 0b00010100;
3525  0054 35140049      	mov	_mY+28,#20
3526                     ; 42 	mY.phases[2] = 0b00000100;
3528  0058 3504004a      	mov	_mY+29,#4
3529                     ; 43 	mY.phases[3] = 0b00001100;
3531  005c 350c004b      	mov	_mY+30,#12
3532                     ; 44 	mY.phases[4] = 0b00001000;
3534  0060 3508004c      	mov	_mY+31,#8
3535                     ; 45 	mY.phases[5] = 0b00001001;
3537  0064 3509004d      	mov	_mY+32,#9
3538                     ; 46 	mY.phases[6] = 0b00000001;
3540  0068 3501004e      	mov	_mY+33,#1
3541                     ; 47 	mY.phases[7] = 0b00010001;
3543  006c 3511004f      	mov	_mY+34,#17
3544                     ; 50 	mZ.out = &PC_ODR;
3546  0070 ae500a        	ldw	x,#_PC_ODR
3547  0073 bf29          	ldw	_mZ+35,x
3548                     ; 51 	mZ.port = &PC;
3550  0075 ae500a        	ldw	x,#_PC
3551  0078 bf2b          	ldw	_mZ+37,x
3552                     ; 52 	mZ.mask = 0b00001111;
3554  007a 350f001f      	mov	_mZ+25,#15
3555                     ; 53 	mZ.stopMask =  0b00001111;
3557  007e 350f0020      	mov	_mZ+26,#15
3558                     ; 67 	mZ.phases[0] = 0b11000000;
3560  0082 35c00021      	mov	_mZ+27,#192
3561                     ; 68 	mZ.phases[1] = 0b11000000;
3563  0086 35c00022      	mov	_mZ+28,#192
3564                     ; 69 	mZ.phases[2] = 0b01000000;
3566  008a 35400023      	mov	_mZ+29,#64
3567                     ; 70 	mZ.phases[3] = 0b01010000;
3569  008e 35500024      	mov	_mZ+30,#80
3570                     ; 71 	mZ.phases[4] = 0b00010000;
3572  0092 35100025      	mov	_mZ+31,#16
3573                     ; 72 	mZ.phases[5] = 0b00110000;
3575  0096 35300026      	mov	_mZ+32,#48
3576                     ; 73 	mZ.phases[6] = 0b00100000;
3578  009a 35200027      	mov	_mZ+33,#32
3579                     ; 74 	mZ.phases[7] = 0b10100000;
3581  009e 35a00028      	mov	_mZ+34,#160
3582                     ; 77   PB.DDR = 0;
3584  00a2 725f5007      	clr	_PB+2
3585                     ; 78 	PB.CR1 = 255;
3587  00a6 35ff5008      	mov	_PB+3,#255
3588                     ; 79 	PB.CR2 = 0;
3590  00aa 725f5009      	clr	_PB+4
3591                     ; 81   PA.DDR = 0;
3593  00ae 725f5002      	clr	_PA+2
3594                     ; 82 	PA.CR1 = 0xFF;
3596  00b2 35ff5003      	mov	_PA+3,#255
3597                     ; 83 	PA.CR2 = 0;
3599  00b6 725f5004      	clr	_PA+4
3600                     ; 85 	TIM2_CR1 = bit7;    //Разрешаем буферизацию ARR
3602  00ba 35805300      	mov	_TIM2_CR1,#128
3603                     ; 86 	TIM2_ARRH = 0x10;      //1000000 / 100 ~ 10000Hz;
3605  00be 3510530d      	mov	_TIM2_ARRH,#16
3606                     ; 87 	TIM2_ARRL = 0x15;    //1000000 / 100 ~ 10000Hz;
3608  00c2 3515530e      	mov	_TIM2_ARRL,#21
3609                     ; 88 	TIM2_IER =  1;      //Update overflow and Capture/Compare 1
3611  00c6 35015301      	mov	_TIM2_IER,#1
3612                     ; 89 	TIM2_PSCR = 4;      //Предделитель 16000000 /16 = 1000000 Hz
3614  00ca 3504530c      	mov	_TIM2_PSCR,#4
3615                     ; 91 	motor_stop();
3617  00ce cd03d6        	call	_motor_stop
3619                     ; 93 	mX.port->DDR |= ~mX.mask;
3621  00d1 be79          	ldw	x,_mX+37
3622  00d3 b66d          	ld	a,_mX+25
3623  00d5 43            	cpl	a
3624  00d6 ea02          	or	a,(2,x)
3625  00d8 e702          	ld	(2,x),a
3626                     ; 94 	mX.port->CR1 |= ~mX.mask;
3628  00da be79          	ldw	x,_mX+37
3629  00dc b66d          	ld	a,_mX+25
3630  00de 43            	cpl	a
3631  00df ea03          	or	a,(3,x)
3632  00e1 e703          	ld	(3,x),a
3633                     ; 95 	mX.port->CR2 = 0;
3635  00e3 be79          	ldw	x,_mX+37
3636  00e5 6f04          	clr	(4,x)
3637                     ; 96 	mX.port->Out = mX.stopMask;
3639  00e7 b66e          	ld	a,_mX+26
3640  00e9 92c779        	ld	[_mX+37.w],a
3641                     ; 98 	mY.port->DDR |= ~mY.mask;
3643  00ec be52          	ldw	x,_mY+37
3644  00ee b646          	ld	a,_mY+25
3645  00f0 43            	cpl	a
3646  00f1 ea02          	or	a,(2,x)
3647  00f3 e702          	ld	(2,x),a
3648                     ; 99 	mY.port->CR1 |= ~mY.mask;
3650  00f5 be52          	ldw	x,_mY+37
3651  00f7 b646          	ld	a,_mY+25
3652  00f9 43            	cpl	a
3653  00fa ea03          	or	a,(3,x)
3654  00fc e703          	ld	(3,x),a
3655                     ; 100 	mY.port->CR2 = 0;
3657  00fe be52          	ldw	x,_mY+37
3658  0100 6f04          	clr	(4,x)
3659                     ; 101 	mY.port->Out = mY.stopMask;
3661  0102 b647          	ld	a,_mY+26
3662  0104 92c752        	ld	[_mY+37.w],a
3663                     ; 103 	mZ.port->DDR |= ~mZ.mask;
3665  0107 be2b          	ldw	x,_mZ+37
3666  0109 b61f          	ld	a,_mZ+25
3667  010b 43            	cpl	a
3668  010c ea02          	or	a,(2,x)
3669  010e e702          	ld	(2,x),a
3670                     ; 104 	mZ.port->CR1 |= ~mZ.mask;
3672  0110 be2b          	ldw	x,_mZ+37
3673  0112 b61f          	ld	a,_mZ+25
3674  0114 43            	cpl	a
3675  0115 ea03          	or	a,(3,x)
3676  0117 e703          	ld	(3,x),a
3677                     ; 105 	mZ.port->CR2 = 0;
3679  0119 be2b          	ldw	x,_mZ+37
3680  011b 6f04          	clr	(4,x)
3681                     ; 106 	mZ.port->Out = mZ.stopMask;
3683  011d b620          	ld	a,_mZ+26
3684  011f 92c72b        	ld	[_mZ+37.w],a
3685                     ; 107 }
3688  0122 81            	ret
3729                     ; 110 char CheckEnds(void){
3730                     	switch	.text
3731  0123               _CheckEnds:
3733  0123 88            	push	a
3734       00000001      OFST:	set	1
3737                     ; 112 	inp = PA.In & 126;
3739  0124 c65001        	ld	a,_PA+1
3740  0127 a47e          	and	a,#126
3741  0129 6b01          	ld	(OFST+0,sp),a
3742                     ; 113 	if (inp == 126){
3744  012b 7b01          	ld	a,(OFST+0,sp)
3745  012d a17e          	cp	a,#126
3746  012f 2605          	jrne	L5732
3747                     ; 114 		return 1;
3749  0131 a601          	ld	a,#1
3752  0133 5b01          	addw	sp,#1
3753  0135 81            	ret
3754  0136               L5732:
3755                     ; 116 	if (PpA.in1 == 0 && mX.Limit < mX.Steps && settingsA.dig2){
3757  0136 c65001        	ld	a,_PpA+1
3758  0139 a502          	bcp	a,#2
3759  013b 261a          	jrne	L7732
3761  013d 9c            	rvf
3762  013e ae0058        	ldw	x,#_mX+4
3763  0141 cd0000        	call	c_ltor
3765  0144 ae0054        	ldw	x,#_mX
3766  0147 cd0000        	call	c_lcmp
3768  014a 2e0b          	jrsge	L7732
3770  014c c64010        	ld	a,_settingsA
3771  014f a502          	bcp	a,#2
3772  0151 2704          	jreq	L7732
3773                     ; 117 		return 0;
3775  0153 4f            	clr	a
3778  0154 5b01          	addw	sp,#1
3779  0156 81            	ret
3780  0157               L7732:
3781                     ; 119 	if (PpA.in2 == 0 && mX.Limit > mX.Steps && settingsA.dig4){
3783  0157 c65001        	ld	a,_PpA+1
3784  015a a504          	bcp	a,#4
3785  015c 261a          	jrne	L1042
3787  015e 9c            	rvf
3788  015f ae0058        	ldw	x,#_mX+4
3789  0162 cd0000        	call	c_ltor
3791  0165 ae0054        	ldw	x,#_mX
3792  0168 cd0000        	call	c_lcmp
3794  016b 2d0b          	jrsle	L1042
3796  016d c64010        	ld	a,_settingsA
3797  0170 a504          	bcp	a,#4
3798  0172 2704          	jreq	L1042
3799                     ; 120 		return 0;
3801  0174 4f            	clr	a
3804  0175 5b01          	addw	sp,#1
3805  0177 81            	ret
3806  0178               L1042:
3807                     ; 122 	if (PpA.in3 == 0 && mZ.Limit > mZ.Steps && settingsA.dig8){
3809  0178 c65001        	ld	a,_PpA+1
3810  017b a508          	bcp	a,#8
3811  017d 261a          	jrne	L3042
3813  017f 9c            	rvf
3814  0180 ae000a        	ldw	x,#_mZ+4
3815  0183 cd0000        	call	c_ltor
3817  0186 ae0006        	ldw	x,#_mZ
3818  0189 cd0000        	call	c_lcmp
3820  018c 2d0b          	jrsle	L3042
3822  018e c64010        	ld	a,_settingsA
3823  0191 a508          	bcp	a,#8
3824  0193 2704          	jreq	L3042
3825                     ; 123 		return 0;
3827  0195 4f            	clr	a
3830  0196 5b01          	addw	sp,#1
3831  0198 81            	ret
3832  0199               L3042:
3833                     ; 125 	if (PpA.in4 == 0 && mZ.Limit < mZ.Steps && settingsA.dig16){
3835  0199 c65001        	ld	a,_PpA+1
3836  019c a510          	bcp	a,#16
3837  019e 261a          	jrne	L5042
3839  01a0 9c            	rvf
3840  01a1 ae000a        	ldw	x,#_mZ+4
3841  01a4 cd0000        	call	c_ltor
3843  01a7 ae0006        	ldw	x,#_mZ
3844  01aa cd0000        	call	c_lcmp
3846  01ad 2e0b          	jrsge	L5042
3848  01af c64010        	ld	a,_settingsA
3849  01b2 a510          	bcp	a,#16
3850  01b4 2704          	jreq	L5042
3851                     ; 126 		return 0;
3853  01b6 4f            	clr	a
3856  01b7 5b01          	addw	sp,#1
3857  01b9 81            	ret
3858  01ba               L5042:
3859                     ; 128 	if (PpA.in5 == 0 && mY.Limit < mY.Steps && settingsA.dig32){
3861  01ba c65001        	ld	a,_PpA+1
3862  01bd a520          	bcp	a,#32
3863  01bf 261a          	jrne	L7042
3865  01c1 9c            	rvf
3866  01c2 ae0031        	ldw	x,#_mY+4
3867  01c5 cd0000        	call	c_ltor
3869  01c8 ae002d        	ldw	x,#_mY
3870  01cb cd0000        	call	c_lcmp
3872  01ce 2e0b          	jrsge	L7042
3874  01d0 c64010        	ld	a,_settingsA
3875  01d3 a520          	bcp	a,#32
3876  01d5 2704          	jreq	L7042
3877                     ; 129 		return 0;
3879  01d7 4f            	clr	a
3882  01d8 5b01          	addw	sp,#1
3883  01da 81            	ret
3884  01db               L7042:
3885                     ; 131 	if (PpA.in6 == 0 && mY.Limit > mY.Steps && settingsA.dig64){                                                   
3887  01db c65001        	ld	a,_PpA+1
3888  01de a540          	bcp	a,#64
3889  01e0 261a          	jrne	L1142
3891  01e2 9c            	rvf
3892  01e3 ae0031        	ldw	x,#_mY+4
3893  01e6 cd0000        	call	c_ltor
3895  01e9 ae002d        	ldw	x,#_mY
3896  01ec cd0000        	call	c_lcmp
3898  01ef 2d0b          	jrsle	L1142
3900  01f1 c64010        	ld	a,_settingsA
3901  01f4 a540          	bcp	a,#64
3902  01f6 2704          	jreq	L1142
3903                     ; 132 		return 0;
3905  01f8 4f            	clr	a
3908  01f9 5b01          	addw	sp,#1
3909  01fb 81            	ret
3910  01fc               L1142:
3911                     ; 134 	inp = PA.In & current.waitingMaskA;
3913  01fc c65001        	ld	a,_PA+1
3914  01ff b40a          	and	a,_current+10
3915  0201 6b01          	ld	(OFST+0,sp),a
3916                     ; 135 	if (current.waitingMaskA & 127 > 0){
3918  0203 b60a          	ld	a,_current+10
3919  0205 a501          	bcp	a,#1
3920  0207 270c          	jreq	L3142
3921                     ; 136 		if (current.waitingMaskA > 0 && inp > 0){
3923  0209 3d0a          	tnz	_current+10
3924  020b 2714          	jreq	L7142
3926  020d 0d01          	tnz	(OFST+0,sp)
3927  020f 2710          	jreq	L7142
3928                     ; 137 			return 0;
3930  0211 4f            	clr	a
3933  0212 5b01          	addw	sp,#1
3934  0214 81            	ret
3935  0215               L3142:
3936                     ; 141 		if (current.waitingMaskA > 0 && inp == 0){
3938  0215 3d0a          	tnz	_current+10
3939  0217 2708          	jreq	L7142
3941  0219 0d01          	tnz	(OFST+0,sp)
3942  021b 2604          	jrne	L7142
3943                     ; 142 			return 0;
3945  021d 4f            	clr	a
3948  021e 5b01          	addw	sp,#1
3949  0220 81            	ret
3950  0221               L7142:
3951                     ; 145 	return 1;
3953  0221 a601          	ld	a,#1
3956  0223 5b01          	addw	sp,#1
3957  0225 81            	ret
3993                     ; 148 char CheckBtns(void){
3994                     	switch	.text
3995  0226               _CheckBtns:
3997  0226 88            	push	a
3998       00000001      OFST:	set	1
4001                     ; 150   inp = PB.In & 252;
4003  0227 c65006        	ld	a,_PB+1
4004  022a a4fc          	and	a,#252
4005  022c 6b01          	ld	(OFST+0,sp),a
4006                     ; 151 	inp = inp & current.waitingMaskB;
4008  022e 7b01          	ld	a,(OFST+0,sp)
4009  0230 b40b          	and	a,_current+11
4010  0232 6b01          	ld	(OFST+0,sp),a
4011                     ; 152 	if (current.waitingMaskB > 0 && inp == 0){
4013  0234 3d0b          	tnz	_current+11
4014  0236 2708          	jreq	L1442
4016  0238 0d01          	tnz	(OFST+0,sp)
4017  023a 2604          	jrne	L1442
4018                     ; 153 		return 0;
4020  023c 4f            	clr	a
4023  023d 5b01          	addw	sp,#1
4024  023f 81            	ret
4025  0240               L1442:
4026                     ; 155 	return 1;
4028  0240 a601          	ld	a,#1
4031  0242 5b01          	addw	sp,#1
4032  0244 81            	ret
4148                     ; 158 void loadCommand(InCommandPtr cmd){
4149                     	switch	.text
4150  0245               _loadCommand:
4152  0245 89            	pushw	x
4153       00000000      OFST:	set	0
4156                     ; 159 	  mX.Limit = cmd->x;		
4158  0246 e60b          	ld	a,(11,x)
4159  0248 b75b          	ld	_mX+7,a
4160  024a e60a          	ld	a,(10,x)
4161  024c b75a          	ld	_mX+6,a
4162  024e e609          	ld	a,(9,x)
4163  0250 b759          	ld	_mX+5,a
4164  0252 e608          	ld	a,(8,x)
4165  0254 b758          	ld	_mX+4,a
4166                     ; 160 		mY.Limit = cmd->y;	
4168  0256 e60f          	ld	a,(15,x)
4169  0258 b734          	ld	_mY+7,a
4170  025a e60e          	ld	a,(14,x)
4171  025c b733          	ld	_mY+6,a
4172  025e e60d          	ld	a,(13,x)
4173  0260 b732          	ld	_mY+5,a
4174  0262 e60c          	ld	a,(12,x)
4175  0264 b731          	ld	_mY+4,a
4176                     ; 161 		mZ.Limit = cmd->z;		
4178  0266 e613          	ld	a,(19,x)
4179  0268 b70d          	ld	_mZ+7,a
4180  026a e612          	ld	a,(18,x)
4181  026c b70c          	ld	_mZ+6,a
4182  026e e611          	ld	a,(17,x)
4183  0270 b70b          	ld	_mZ+5,a
4184  0272 e610          	ld	a,(16,x)
4185  0274 b70a          	ld	_mZ+4,a
4186                     ; 162 		mX.Dir = sign(mX.Limit, mX.Steps);
4188  0276 be56          	ldw	x,_mX+2
4189  0278 89            	pushw	x
4190  0279 be54          	ldw	x,_mX
4191  027b 89            	pushw	x
4192  027c be5a          	ldw	x,_mX+6
4193  027e 89            	pushw	x
4194  027f be58          	ldw	x,_mX+4
4195  0281 89            	pushw	x
4196  0282 cd0000        	call	_sign
4198  0285 5b08          	addw	sp,#8
4199  0287 b764          	ld	_mX+16,a
4200                     ; 163 		mY.Dir = sign(mY.Limit, mY.Steps);
4202  0289 be2f          	ldw	x,_mY+2
4203  028b 89            	pushw	x
4204  028c be2d          	ldw	x,_mY
4205  028e 89            	pushw	x
4206  028f be33          	ldw	x,_mY+6
4207  0291 89            	pushw	x
4208  0292 be31          	ldw	x,_mY+4
4209  0294 89            	pushw	x
4210  0295 cd0000        	call	_sign
4212  0298 5b08          	addw	sp,#8
4213  029a b73d          	ld	_mY+16,a
4214                     ; 164 		mZ.Dir = sign(mZ.Limit, mZ.Steps);
4216  029c be08          	ldw	x,_mZ+2
4217  029e 89            	pushw	x
4218  029f be06          	ldw	x,_mZ
4219  02a1 89            	pushw	x
4220  02a2 be0c          	ldw	x,_mZ+6
4221  02a4 89            	pushw	x
4222  02a5 be0a          	ldw	x,_mZ+4
4223  02a7 89            	pushw	x
4224  02a8 cd0000        	call	_sign
4226  02ab 5b08          	addw	sp,#8
4227  02ad b716          	ld	_mZ+16,a
4228                     ; 165   	mX.Delta = abs(mX.Limit - mX.Steps);
4230  02af ae0058        	ldw	x,#_mX+4
4231  02b2 cd0000        	call	c_ltor
4233  02b5 ae0054        	ldw	x,#_mX
4234  02b8 cd0000        	call	c_lsub
4236  02bb be02          	ldw	x,c_lreg+2
4237  02bd 89            	pushw	x
4238  02be be00          	ldw	x,c_lreg
4239  02c0 89            	pushw	x
4240  02c1 cd0000        	call	_abs
4242  02c4 5b04          	addw	sp,#4
4243  02c6 ae0060        	ldw	x,#_mX+12
4244  02c9 cd0000        	call	c_rtol
4246                     ; 166 		mY.Delta = abs(mY.Limit - mY.Steps);
4248  02cc ae0031        	ldw	x,#_mY+4
4249  02cf cd0000        	call	c_ltor
4251  02d2 ae002d        	ldw	x,#_mY
4252  02d5 cd0000        	call	c_lsub
4254  02d8 be02          	ldw	x,c_lreg+2
4255  02da 89            	pushw	x
4256  02db be00          	ldw	x,c_lreg
4257  02dd 89            	pushw	x
4258  02de cd0000        	call	_abs
4260  02e1 5b04          	addw	sp,#4
4261  02e3 ae0039        	ldw	x,#_mY+12
4262  02e6 cd0000        	call	c_rtol
4264                     ; 167 		mZ.Delta = abs(mZ.Limit - mZ.Steps);
4266  02e9 ae000a        	ldw	x,#_mZ+4
4267  02ec cd0000        	call	c_ltor
4269  02ef ae0006        	ldw	x,#_mZ
4270  02f2 cd0000        	call	c_lsub
4272  02f5 be02          	ldw	x,c_lreg+2
4273  02f7 89            	pushw	x
4274  02f8 be00          	ldw	x,c_lreg
4275  02fa 89            	pushw	x
4276  02fb cd0000        	call	_abs
4278  02fe 5b04          	addw	sp,#4
4279  0300 ae0012        	ldw	x,#_mZ+12
4280  0303 cd0000        	call	c_rtol
4282                     ; 168 		mX.speed2 = cmd->speed;
4284  0306 1e01          	ldw	x,(OFST+1,sp)
4285  0308 ee02          	ldw	x,(2,x)
4286  030a bf67          	ldw	_mX+19,x
4287                     ; 169 		mY.speed2 = cmd->speed;
4289  030c 1e01          	ldw	x,(OFST+1,sp)
4290  030e ee02          	ldw	x,(2,x)
4291  0310 bf40          	ldw	_mY+19,x
4292                     ; 170 		mZ.speed2 = cmd->speed;
4294  0312 1e01          	ldw	x,(OFST+1,sp)
4295  0314 ee02          	ldw	x,(2,x)
4296  0316 bf19          	ldw	_mZ+19,x
4297                     ; 171 	  mX.Error = 0;		
4299  0318 ae0000        	ldw	x,#0
4300  031b bf5e          	ldw	_mX+10,x
4301  031d ae0000        	ldw	x,#0
4302  0320 bf5c          	ldw	_mX+8,x
4303                     ; 172 		mY.Error = 0;	
4305  0322 ae0000        	ldw	x,#0
4306  0325 bf37          	ldw	_mY+10,x
4307  0327 ae0000        	ldw	x,#0
4308  032a bf35          	ldw	_mY+8,x
4309                     ; 173 		mZ.Error = 0;	
4311  032c ae0000        	ldw	x,#0
4312  032f bf10          	ldw	_mZ+10,x
4313  0331 ae0000        	ldw	x,#0
4314  0334 bf0e          	ldw	_mZ+8,x
4315                     ; 174 		mX.counter = 0;
4317  0336 5f            	clrw	x
4318  0337 bf6a          	ldw	_mX+22,x
4319                     ; 175 		mY.counter = 0;
4321  0339 5f            	clrw	x
4322  033a bf43          	ldw	_mY+22,x
4323                     ; 176 		mZ.counter = 0;
4325  033c 5f            	clrw	x
4326  033d bf1c          	ldw	_mZ+22,x
4327                     ; 177 		if (mX.Delta >= mY.Delta && mX.Delta >= mZ.Delta){
4329  033f 9c            	rvf
4330  0340 ae0060        	ldw	x,#_mX+12
4331  0343 cd0000        	call	c_ltor
4333  0346 ae0039        	ldw	x,#_mY+12
4334  0349 cd0000        	call	c_lcmp
4336  034c 2f1e          	jrslt	L1152
4338  034e 9c            	rvf
4339  034f ae0060        	ldw	x,#_mX+12
4340  0352 cd0000        	call	c_ltor
4342  0355 ae0012        	ldw	x,#_mZ+12
4343  0358 cd0000        	call	c_lcmp
4345  035b 2f0f          	jrslt	L1152
4346                     ; 178 			m1 = &mX;
4348  035d ae0054        	ldw	x,#_mX
4349  0360 bf04          	ldw	_m1,x
4350                     ; 179 			m2 = &mY;
4352  0362 ae002d        	ldw	x,#_mY
4353  0365 bf02          	ldw	_m2,x
4354                     ; 180 			m3 = &mZ;
4356  0367 ae0006        	ldw	x,#_mZ
4357  036a bf00          	ldw	_m3,x
4358  036c               L1152:
4359                     ; 182 		if (mY.Delta > mX.Delta && mY.Delta > mZ.Delta){
4361  036c 9c            	rvf
4362  036d ae0039        	ldw	x,#_mY+12
4363  0370 cd0000        	call	c_ltor
4365  0373 ae0060        	ldw	x,#_mX+12
4366  0376 cd0000        	call	c_lcmp
4368  0379 2d1e          	jrsle	L3152
4370  037b 9c            	rvf
4371  037c ae0039        	ldw	x,#_mY+12
4372  037f cd0000        	call	c_ltor
4374  0382 ae0012        	ldw	x,#_mZ+12
4375  0385 cd0000        	call	c_lcmp
4377  0388 2d0f          	jrsle	L3152
4378                     ; 183 			m1 = &mY;
4380  038a ae002d        	ldw	x,#_mY
4381  038d bf04          	ldw	_m1,x
4382                     ; 184 			m2 = &mX;
4384  038f ae0054        	ldw	x,#_mX
4385  0392 bf02          	ldw	_m2,x
4386                     ; 185 			m3 = &mZ;
4388  0394 ae0006        	ldw	x,#_mZ
4389  0397 bf00          	ldw	_m3,x
4390  0399               L3152:
4391                     ; 187 		if (mZ.Delta > mX.Delta && mZ.Delta > mY.Delta){
4393  0399 9c            	rvf
4394  039a ae0012        	ldw	x,#_mZ+12
4395  039d cd0000        	call	c_ltor
4397  03a0 ae0060        	ldw	x,#_mX+12
4398  03a3 cd0000        	call	c_lcmp
4400  03a6 2d1e          	jrsle	L5152
4402  03a8 9c            	rvf
4403  03a9 ae0012        	ldw	x,#_mZ+12
4404  03ac cd0000        	call	c_ltor
4406  03af ae0039        	ldw	x,#_mY+12
4407  03b2 cd0000        	call	c_lcmp
4409  03b5 2d0f          	jrsle	L5152
4410                     ; 188 			m1 = &mZ;
4412  03b7 ae0006        	ldw	x,#_mZ
4413  03ba bf04          	ldw	_m1,x
4414                     ; 189 			m2 = &mY;
4416  03bc ae002d        	ldw	x,#_mY
4417  03bf bf02          	ldw	_m2,x
4418                     ; 190 			m3 = &mX;
4420  03c1 ae0054        	ldw	x,#_mX
4421  03c4 bf00          	ldw	_m3,x
4422  03c6               L5152:
4423                     ; 192 		if (cmd->speed > 0){
4425  03c6 1e01          	ldw	x,(OFST+1,sp)
4426  03c8 e603          	ld	a,(3,x)
4427  03ca ea02          	or	a,(2,x)
4428  03cc 2706          	jreq	L7152
4429                     ; 193 			current.maxSpeed = cmd->speed;
4431  03ce 1e01          	ldw	x,(OFST+1,sp)
4432  03d0 ee02          	ldw	x,(2,x)
4433  03d2 bf02          	ldw	_current+2,x
4434  03d4               L7152:
4435                     ; 195 }
4438  03d4 85            	popw	x
4439  03d5 81            	ret
4479                     ; 199 void motor_stop(void){
4480                     	switch	.text
4481  03d6               _motor_stop:
4483  03d6 88            	push	a
4484       00000001      OFST:	set	1
4487                     ; 201 	TIM2_CR1 &= 254;
4489  03d7 72115300      	bres	_TIM2_CR1,#0
4490                     ; 203 	pvalue = *(mX.out);
4492  03db 92c677        	ld	a,[_mX+35.w]
4493  03de 6b01          	ld	(OFST+0,sp),a
4494                     ; 204 	pvalue &= mX.mask;
4496  03e0 7b01          	ld	a,(OFST+0,sp)
4497  03e2 b46d          	and	a,_mX+25
4498  03e4 6b01          	ld	(OFST+0,sp),a
4499                     ; 205 	pvalue |= mX.stopMask;
4501  03e6 7b01          	ld	a,(OFST+0,sp)
4502  03e8 ba6e          	or	a,_mX+26
4503  03ea 6b01          	ld	(OFST+0,sp),a
4504                     ; 206 	*(mX.out) = pvalue;
4506  03ec 7b01          	ld	a,(OFST+0,sp)
4507  03ee 92c777        	ld	[_mX+35.w],a
4508                     ; 208 	pvalue = *(mY.out);
4510  03f1 92c650        	ld	a,[_mY+35.w]
4511  03f4 6b01          	ld	(OFST+0,sp),a
4512                     ; 209 	pvalue &= mY.mask;
4514  03f6 7b01          	ld	a,(OFST+0,sp)
4515  03f8 b446          	and	a,_mY+25
4516  03fa 6b01          	ld	(OFST+0,sp),a
4517                     ; 210 	pvalue |= mY.stopMask;
4519  03fc 7b01          	ld	a,(OFST+0,sp)
4520  03fe ba47          	or	a,_mY+26
4521  0400 6b01          	ld	(OFST+0,sp),a
4522                     ; 211 	*(mY.out) = pvalue;
4524  0402 7b01          	ld	a,(OFST+0,sp)
4525  0404 92c750        	ld	[_mY+35.w],a
4526                     ; 213 	pvalue = *(mZ.out);
4528  0407 92c629        	ld	a,[_mZ+35.w]
4529  040a 6b01          	ld	(OFST+0,sp),a
4530                     ; 214 	pvalue &= mZ.mask;
4532  040c 7b01          	ld	a,(OFST+0,sp)
4533  040e b41f          	and	a,_mZ+25
4534  0410 6b01          	ld	(OFST+0,sp),a
4535                     ; 215 	pvalue |= mZ.stopMask;
4537  0412 7b01          	ld	a,(OFST+0,sp)
4538  0414 ba20          	or	a,_mZ+26
4539  0416 6b01          	ld	(OFST+0,sp),a
4540                     ; 216 	*(mZ.out) = pvalue;
4542  0418 7b01          	ld	a,(OFST+0,sp)
4543  041a 92c729        	ld	[_mZ+35.w],a
4544                     ; 220 	LEDS_OFF
4546  041d c6501e        	ld	a,_PG_ODR
4547  0420 aa03          	or	a,#3
4548  0422 c7501e        	ld	_PG_ODR,a
4551  0425 72105014      	bset	_PE_ODR,#0
4552                     ; 221 	LED_BLUE_ON
4554  0429 72115014      	bres	_PE_ODR,#0
4555                     ; 222 }
4558  042d 84            	pop	a
4559  042e 81            	ret
4597                     ; 224 void motor_start(unsigned int bspeed){
4598                     	switch	.text
4599  042f               _motor_start:
4603                     ; 225 	setSpeed(bspeed);
4605  042f ad15          	call	_setSpeed
4607                     ; 226 	TIM2_CR1 |= 1;
4609  0431 72105300      	bset	_TIM2_CR1,#0
4610                     ; 227 	LEDS_OFF
4612  0435 c6501e        	ld	a,_PG_ODR
4613  0438 aa03          	or	a,#3
4614  043a c7501e        	ld	_PG_ODR,a
4617  043d 72105014      	bset	_PE_ODR,#0
4618                     ; 228 	LED_GREEN_ON
4620  0441 7213501e      	bres	_PG_ODR,#1
4621                     ; 229 }
4624  0445 81            	ret
4660                     ; 231 void setSpeed(unsigned int bspeed){
4661                     	switch	.text
4662  0446               _setSpeed:
4666                     ; 232 	TIM2_ARRH = bspeed >> 8;
4668  0446 9e            	ld	a,xh
4669  0447 c7530d        	ld	_TIM2_ARRH,a
4670                     ; 233 	TIM2_ARRL = bspeed;
4672  044a 9f            	ld	a,xl
4673  044b c7530e        	ld	_TIM2_ARRL,a
4674                     ; 234 }
4677  044e 81            	ret
4888                     ; 236 void moveFunction(struct SMotorState *mstate){
4889                     	switch	.text
4890  044f               _moveFunction:
4892  044f 89            	pushw	x
4893  0450 88            	push	a
4894       00000001      OFST:	set	1
4897                     ; 238 	if (mstate->phase < 1){
4899  0451 6d18          	tnz	(24,x)
4900  0453 2604          	jrne	L7072
4901                     ; 239 		mstate->phase = sizeof(mstate->phases);
4903  0455 a608          	ld	a,#8
4904  0457 e718          	ld	(24,x),a
4905  0459               L7072:
4906                     ; 241 	if (mstate->phase > sizeof(mstate->phases)){
4908  0459 1e02          	ldw	x,(OFST+1,sp)
4909  045b e618          	ld	a,(24,x)
4910  045d a109          	cp	a,#9
4911  045f 2506          	jrult	L1172
4912                     ; 242 		mstate->phase = 1;
4914  0461 1e02          	ldw	x,(OFST+1,sp)
4915  0463 a601          	ld	a,#1
4916  0465 e718          	ld	(24,x),a
4917  0467               L1172:
4918                     ; 244 	pvalue = *(mstate->out);
4920  0467 1e02          	ldw	x,(OFST+1,sp)
4921  0469 ee23          	ldw	x,(35,x)
4922  046b f6            	ld	a,(x)
4923  046c 6b01          	ld	(OFST+0,sp),a
4924                     ; 245 	pvalue &= mstate->mask;
4926  046e 1e02          	ldw	x,(OFST+1,sp)
4927  0470 7b01          	ld	a,(OFST+0,sp)
4928  0472 e419          	and	a,(25,x)
4929  0474 6b01          	ld	(OFST+0,sp),a
4930                     ; 246 	pvalue |= mstate->phases[mstate->phase - 1];
4932  0476 1e02          	ldw	x,(OFST+1,sp)
4933  0478 e618          	ld	a,(24,x)
4934  047a 5f            	clrw	x
4935  047b 97            	ld	xl,a
4936  047c 5a            	decw	x
4937  047d 72fb02        	addw	x,(OFST+1,sp)
4938  0480 7b01          	ld	a,(OFST+0,sp)
4939  0482 ea1b          	or	a,(27,x)
4940  0484 6b01          	ld	(OFST+0,sp),a
4941                     ; 247 	*(mstate->out) = pvalue;
4943  0486 7b01          	ld	a,(OFST+0,sp)
4944  0488 1e02          	ldw	x,(OFST+1,sp)
4945  048a ee23          	ldw	x,(35,x)
4946  048c f7            	ld	(x),a
4947                     ; 248 	mstate->phase += mstate->Dir;
4949  048d 1e02          	ldw	x,(OFST+1,sp)
4950  048f 1602          	ldw	y,(OFST+1,sp)
4951  0491 e618          	ld	a,(24,x)
4952  0493 90eb10        	add	a,(16,y)
4953  0496 e718          	ld	(24,x),a
4954                     ; 249 	mstate->counter--;
4956  0498 1e02          	ldw	x,(OFST+1,sp)
4957  049a 9093          	ldw	y,x
4958  049c ee16          	ldw	x,(22,x)
4959  049e 1d0001        	subw	x,#1
4960  04a1 90ef16        	ldw	(22,y),x
4961                     ; 250 	if (mstate->counter == 0){
4963  04a4 1e02          	ldw	x,(OFST+1,sp)
4964  04a6 e617          	ld	a,(23,x)
4965  04a8 ea16          	or	a,(22,x)
4966  04aa 2616          	jrne	L3172
4967                     ; 251 	   mstate->Steps += mstate->Dir;
4969  04ac 1e02          	ldw	x,(OFST+1,sp)
4970  04ae 1602          	ldw	y,(OFST+1,sp)
4971  04b0 90e610        	ld	a,(16,y)
4972  04b3 b703          	ld	c_lreg+3,a
4973  04b5 48            	sll	a
4974  04b6 4f            	clr	a
4975  04b7 a200          	sbc	a,#0
4976  04b9 b702          	ld	c_lreg+2,a
4977  04bb b701          	ld	c_lreg+1,a
4978  04bd b700          	ld	c_lreg,a
4979  04bf cd0000        	call	c_lgadd
4981  04c2               L3172:
4982                     ; 253 }
4985  04c2 5b03          	addw	sp,#3
4986  04c4 81            	ret
5025                     ; 255 @interrupt unsigned char iTim2_overflow(){
5026                     	switch	.text
5027  04c5               _iTim2_overflow:
5029       00000002      OFST:	set	2
5030  04c5 3b0002        	push	c_x+2
5031  04c8 be00          	ldw	x,c_x
5032  04ca 89            	pushw	x
5033  04cb 3b0002        	push	c_y+2
5034  04ce be00          	ldw	x,c_y
5035  04d0 89            	pushw	x
5036  04d1 be02          	ldw	x,c_lreg+2
5037  04d3 89            	pushw	x
5038  04d4 be00          	ldw	x,c_lreg
5039  04d6 89            	pushw	x
5040  04d7 89            	pushw	x
5043                     ; 256 	_asm("SIM");
5046  04d8 9b            SIM
5048                     ; 257 	TIM2_SR1 &= 254;
5050  04d9 72115302      	bres	_TIM2_SR1,#0
5051                     ; 258 	if (current.state != 1 || (mX.Steps == mX.Limit && mY.Steps == mY.Limit && mZ.Steps == mZ.Limit)) {
5053  04dd b609          	ld	a,_current+9
5054  04df a101          	cp	a,#1
5055  04e1 262a          	jrne	L7272
5057  04e3 ae0054        	ldw	x,#_mX
5058  04e6 cd0000        	call	c_ltor
5060  04e9 ae0058        	ldw	x,#_mX+4
5061  04ec cd0000        	call	c_lcmp
5063  04ef 2623          	jrne	L5272
5065  04f1 ae002d        	ldw	x,#_mY
5066  04f4 cd0000        	call	c_ltor
5068  04f7 ae0031        	ldw	x,#_mY+4
5069  04fa cd0000        	call	c_lcmp
5071  04fd 2615          	jrne	L5272
5073  04ff ae0006        	ldw	x,#_mZ
5074  0502 cd0000        	call	c_ltor
5076  0505 ae000a        	ldw	x,#_mZ+4
5077  0508 cd0000        	call	c_lcmp
5079  050b 2607          	jrne	L5272
5080  050d               L7272:
5081                     ; 259 		moving_finished();
5083  050d cd0000        	call	_moving_finished
5085                     ; 260 		_asm("RIM");
5088  0510 9a            RIM
5090                     ; 261 		return 0;
5092  0511 4f            	clr	a
5094  0512 200b          	jra	L23
5095  0514               L5272:
5096                     ; 263 	if (!CheckBtns()){
5098  0514 cd0226        	call	_CheckBtns
5100  0517 4d            	tnz	a
5101  0518 261a          	jrne	L1372
5102                     ; 264 		pause();
5104  051a cd0000        	call	_pause
5106                     ; 265 		_asm("RIM");
5109  051d 9a            RIM
5111                     ; 266 		return 0;
5113  051e 4f            	clr	a
5115  051f               L23:
5117  051f 5b02          	addw	sp,#2
5118  0521 85            	popw	x
5119  0522 bf00          	ldw	c_lreg,x
5120  0524 85            	popw	x
5121  0525 bf02          	ldw	c_lreg+2,x
5122  0527 85            	popw	x
5123  0528 bf00          	ldw	c_y,x
5124  052a 320002        	pop	c_y+2
5125  052d 85            	popw	x
5126  052e bf00          	ldw	c_x,x
5127  0530 320002        	pop	c_x+2
5128  0533 80            	iret
5129  0534               L1372:
5130                     ; 268 	if (!CheckEnds()){
5132  0534 cd0123        	call	_CheckEnds
5134  0537 4d            	tnz	a
5135  0538 2607          	jrne	L3372
5136                     ; 269 		error();
5138  053a cd0000        	call	_error
5140                     ; 270 		_asm("RIM");
5143  053d 9a            RIM
5145                     ; 271 		return 0;
5147  053e 4f            	clr	a
5149  053f 20de          	jra	L23
5150  0541               L3372:
5151                     ; 273 	if (m1->counter > 0) moveFunction(m1);
5153  0541 9c            	rvf
5154  0542 5f            	clrw	x
5155  0543 1f01          	ldw	(OFST-1,sp),x
5156  0545 be04          	ldw	x,_m1
5157  0547 9093          	ldw	y,x
5158  0549 51            	exgw	x,y
5159  054a ee16          	ldw	x,(22,x)
5160  054c 1301          	cpw	x,(OFST-1,sp)
5161  054e 51            	exgw	x,y
5162  054f 2d05          	jrsle	L5372
5165  0551 be04          	ldw	x,_m1
5166  0553 cd044f        	call	_moveFunction
5168  0556               L5372:
5169                     ; 274 	if (m2->counter > 0) moveFunction(m2);
5171  0556 9c            	rvf
5172  0557 5f            	clrw	x
5173  0558 1f01          	ldw	(OFST-1,sp),x
5174  055a be02          	ldw	x,_m2
5175  055c 9093          	ldw	y,x
5176  055e 51            	exgw	x,y
5177  055f ee16          	ldw	x,(22,x)
5178  0561 1301          	cpw	x,(OFST-1,sp)
5179  0563 51            	exgw	x,y
5180  0564 2d05          	jrsle	L7372
5183  0566 be02          	ldw	x,_m2
5184  0568 cd044f        	call	_moveFunction
5186  056b               L7372:
5187                     ; 275 	if (m3->counter > 0) moveFunction(m3);
5189  056b 9c            	rvf
5190  056c 5f            	clrw	x
5191  056d 1f01          	ldw	(OFST-1,sp),x
5192  056f be00          	ldw	x,_m3
5193  0571 9093          	ldw	y,x
5194  0573 51            	exgw	x,y
5195  0574 ee16          	ldw	x,(22,x)
5196  0576 1301          	cpw	x,(OFST-1,sp)
5197  0578 51            	exgw	x,y
5198  0579 2d05          	jrsle	L1472
5201  057b be00          	ldw	x,_m3
5202  057d cd044f        	call	_moveFunction
5204  0580               L1472:
5205                     ; 276 	if (m1->counter == m2->counter == m3->counter == 0){
5207  0580 be04          	ldw	x,_m1
5208  0582 90be02        	ldw	y,_m2
5209  0585 ee16          	ldw	x,(22,x)
5210  0587 90e316        	cpw	x,(22,y)
5211  058a 2605          	jrne	L62
5212  058c ae0001        	ldw	x,#1
5213  058f 2001          	jra	L03
5214  0591               L62:
5215  0591 5f            	clrw	x
5216  0592               L03:
5217  0592 90be00        	ldw	y,_m3
5218  0595 90e316        	cpw	x,(22,y)
5219  0598 2603          	jrne	L43
5220  059a cc06ea        	jp	L3472
5221  059d               L43:
5222                     ; 277 		ticks++;
5224  059d 3c00          	inc	_ticks
5225                     ; 289 		if (m1->Steps != m1->Limit){
5227  059f be04          	ldw	x,_m1
5228  05a1 cd0000        	call	c_ltor
5230  05a4 be04          	ldw	x,_m1
5231  05a6 1c0004        	addw	x,#4
5232  05a9 cd0000        	call	c_lcmp
5234  05ac 2711          	jreq	L5472
5235                     ; 290 			m1->counter = m1->coef;
5237  05ae be04          	ldw	x,_m1
5238  05b0 e615          	ld	a,(21,x)
5239  05b2 5f            	clrw	x
5240  05b3 97            	ld	xl,a
5241  05b4 90be04        	ldw	y,_m1
5242  05b7 90ef16        	ldw	(22,y),x
5243                     ; 291 			moveFunction(m1);
5245  05ba be04          	ldw	x,_m1
5246  05bc cd044f        	call	_moveFunction
5248  05bf               L5472:
5249                     ; 294 		if (m2->Steps != m2->Limit && m2->Dir != 0){
5251  05bf be02          	ldw	x,_m2
5252  05c1 cd0000        	call	c_ltor
5254  05c4 be02          	ldw	x,_m2
5255  05c6 1c0004        	addw	x,#4
5256  05c9 cd0000        	call	c_lcmp
5258  05cc 2770          	jreq	L7472
5260  05ce be02          	ldw	x,_m2
5261  05d0 6d10          	tnz	(16,x)
5262  05d2 276a          	jreq	L7472
5263                     ; 295 			m2->Error += m2->Delta;
5265  05d4 be02          	ldw	x,_m2
5266  05d6 90be02        	ldw	y,_m2
5267  05d9 90e60f        	ld	a,(15,y)
5268  05dc b703          	ld	c_lreg+3,a
5269  05de 90e60e        	ld	a,(14,y)
5270  05e1 b702          	ld	c_lreg+2,a
5271  05e3 90e60d        	ld	a,(13,y)
5272  05e6 b701          	ld	c_lreg+1,a
5273  05e8 90e60c        	ld	a,(12,y)
5274  05eb b700          	ld	c_lreg,a
5275  05ed 1c0008        	addw	x,#8
5276  05f0 cd0000        	call	c_lgadd
5278                     ; 296 			if ((signed long)(2 * m2->Error) >= m1->Delta){
5280  05f3 9c            	rvf
5281  05f4 be02          	ldw	x,_m2
5282  05f6 1c0008        	addw	x,#8
5283  05f9 cd0000        	call	c_ltor
5285  05fc 3803          	sll	c_lreg+3
5286  05fe 3902          	rlc	c_lreg+2
5287  0600 3901          	rlc	c_lreg+1
5288  0602 3900          	rlc	c_lreg
5289  0604 be04          	ldw	x,_m1
5290  0606 1c000c        	addw	x,#12
5291  0609 cd0000        	call	c_lcmp
5293  060c 2f30          	jrslt	L7472
5294                     ; 297 				m2->Error -= m1->Delta;
5296  060e be02          	ldw	x,_m2
5297  0610 90be04        	ldw	y,_m1
5298  0613 90e60f        	ld	a,(15,y)
5299  0616 b703          	ld	c_lreg+3,a
5300  0618 90e60e        	ld	a,(14,y)
5301  061b b702          	ld	c_lreg+2,a
5302  061d 90e60d        	ld	a,(13,y)
5303  0620 b701          	ld	c_lreg+1,a
5304  0622 90e60c        	ld	a,(12,y)
5305  0625 b700          	ld	c_lreg,a
5306  0627 1c0008        	addw	x,#8
5307  062a cd0000        	call	c_lgsub
5309                     ; 298 				m2->counter = m2->coef;
5311  062d be02          	ldw	x,_m2
5312  062f e615          	ld	a,(21,x)
5313  0631 5f            	clrw	x
5314  0632 97            	ld	xl,a
5315  0633 90be02        	ldw	y,_m2
5316  0636 90ef16        	ldw	(22,y),x
5317                     ; 299 				moveFunction(m2);
5319  0639 be02          	ldw	x,_m2
5320  063b cd044f        	call	_moveFunction
5322  063e               L7472:
5323                     ; 303 		if (m3->Steps != m3->Limit && m3->Dir != 0){
5325  063e be00          	ldw	x,_m3
5326  0640 cd0000        	call	c_ltor
5328  0643 be00          	ldw	x,_m3
5329  0645 1c0004        	addw	x,#4
5330  0648 cd0000        	call	c_lcmp
5332  064b 2770          	jreq	L3572
5334  064d be00          	ldw	x,_m3
5335  064f 6d10          	tnz	(16,x)
5336  0651 276a          	jreq	L3572
5337                     ; 304 			m3->Error += m3->Delta;
5339  0653 be00          	ldw	x,_m3
5340  0655 90be00        	ldw	y,_m3
5341  0658 90e60f        	ld	a,(15,y)
5342  065b b703          	ld	c_lreg+3,a
5343  065d 90e60e        	ld	a,(14,y)
5344  0660 b702          	ld	c_lreg+2,a
5345  0662 90e60d        	ld	a,(13,y)
5346  0665 b701          	ld	c_lreg+1,a
5347  0667 90e60c        	ld	a,(12,y)
5348  066a b700          	ld	c_lreg,a
5349  066c 1c0008        	addw	x,#8
5350  066f cd0000        	call	c_lgadd
5352                     ; 305 			if ((signed long)(2 * m3->Error) >= m1->Delta){
5354  0672 9c            	rvf
5355  0673 be00          	ldw	x,_m3
5356  0675 1c0008        	addw	x,#8
5357  0678 cd0000        	call	c_ltor
5359  067b 3803          	sll	c_lreg+3
5360  067d 3902          	rlc	c_lreg+2
5361  067f 3901          	rlc	c_lreg+1
5362  0681 3900          	rlc	c_lreg
5363  0683 be04          	ldw	x,_m1
5364  0685 1c000c        	addw	x,#12
5365  0688 cd0000        	call	c_lcmp
5367  068b 2f30          	jrslt	L3572
5368                     ; 306 				m3->Error -= m1->Delta;
5370  068d be00          	ldw	x,_m3
5371  068f 90be04        	ldw	y,_m1
5372  0692 90e60f        	ld	a,(15,y)
5373  0695 b703          	ld	c_lreg+3,a
5374  0697 90e60e        	ld	a,(14,y)
5375  069a b702          	ld	c_lreg+2,a
5376  069c 90e60d        	ld	a,(13,y)
5377  069f b701          	ld	c_lreg+1,a
5378  06a1 90e60c        	ld	a,(12,y)
5379  06a4 b700          	ld	c_lreg,a
5380  06a6 1c0008        	addw	x,#8
5381  06a9 cd0000        	call	c_lgsub
5383                     ; 307 				m3->counter = m3->coef;
5385  06ac be00          	ldw	x,_m3
5386  06ae e615          	ld	a,(21,x)
5387  06b0 5f            	clrw	x
5388  06b1 97            	ld	xl,a
5389  06b2 90be00        	ldw	y,_m3
5390  06b5 90ef16        	ldw	(22,y),x
5391                     ; 308 				moveFunction(m3);
5393  06b8 be00          	ldw	x,_m3
5394  06ba cd044f        	call	_moveFunction
5396  06bd               L3572:
5397                     ; 312 		if (mX.Steps == mX.Limit && mY.Steps == mY.Limit && mZ.Steps == mZ.Limit)
5399  06bd ae0054        	ldw	x,#_mX
5400  06c0 cd0000        	call	c_ltor
5402  06c3 ae0058        	ldw	x,#_mX+4
5403  06c6 cd0000        	call	c_lcmp
5405  06c9 261f          	jrne	L3472
5407  06cb ae002d        	ldw	x,#_mY
5408  06ce cd0000        	call	c_ltor
5410  06d1 ae0031        	ldw	x,#_mY+4
5411  06d4 cd0000        	call	c_lcmp
5413  06d7 2611          	jrne	L3472
5415  06d9 ae0006        	ldw	x,#_mZ
5416  06dc cd0000        	call	c_ltor
5418  06df ae000a        	ldw	x,#_mZ+4
5419  06e2 cd0000        	call	c_lcmp
5421  06e5 2603          	jrne	L3472
5422                     ; 314 			moving_finished();
5424  06e7 cd0000        	call	_moving_finished
5426  06ea               L3472:
5427                     ; 317 	_asm("RIM");
5430  06ea 9a            RIM
5432                     ; 318 }
5434  06eb ac1f051f      	jpf	L23
5612                     	xdef	_iTim2_overflow
5613                     	xdef	_moveFunction
5614                     	xref.b	_current
5615                     	xref.b	_ticks
5616                     	switch	.ubsct
5617  0000               _m3:
5618  0000 0000          	ds.b	2
5619                     	xdef	_m3
5620  0002               _m2:
5621  0002 0000          	ds.b	2
5622                     	xdef	_m2
5623  0004               _m1:
5624  0004 0000          	ds.b	2
5625                     	xdef	_m1
5626  0006               _mZ:
5627  0006 000000000000  	ds.b	39
5628                     	xdef	_mZ
5629  002d               _mY:
5630  002d 000000000000  	ds.b	39
5631                     	xdef	_mY
5632  0054               _mX:
5633  0054 000000000000  	ds.b	39
5634                     	xdef	_mX
5635                     	xref	_abs
5636                     	xref	_sign
5637                     	xdef	_CheckBtns
5638                     	xdef	_CheckEnds
5639                     	xdef	_loadCommand
5640                     	xdef	_setSpeed
5641                     	xdef	_motor_start
5642                     	xdef	_motor_stop
5643                     	xdef	_initMotors
5644                     	xref	_error
5645                     	xref	_pause
5646                     	xref	_moving_finished
5647                     	xref.b	c_lreg
5648                     	xref.b	c_x
5649                     	xref.b	c_y
5669                     	xref	c_lgsub
5670                     	xref	c_lgadd
5671                     	xref	c_rtol
5672                     	xref	c_lsub
5673                     	xref	c_lcmp
5674                     	xref	c_ltor
5675                     	end
