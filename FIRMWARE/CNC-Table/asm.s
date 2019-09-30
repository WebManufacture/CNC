#include "stm8s105.s"
#include "macro.s"
#include "consts.s"

xref _move, _init, _cicle, _tim2_overflow, _tim3_overflow
xdef setSpeed, _moveX, _moveY, _moveZ,_iPORTB_EXTI, _iTim4_OVF
xdef _main, _motor_stop, _motor_start

_main:
	setClock 8
	;exClock 0
	;PG - Служебный порт
	BRES CLK_CCOR, #0
	
	LDW X, #00
clear_ram:
	clr (X)
	incw X
	cpw X, #$07FF
	jrule clear_ram
	
	MOV PG_DDR, #$ff ; установить режим работы порта
	MOV PG_CR1, #$ff
	MOV PG_CR2, #$00
	MOV PG_ODR, #$ff
	
	MOV PD_DDR, #$1D ; установить режим работы порта
	MOV PD_CR1, #$FF
	MOV PD_CR2, #$00
	
	MOV PC_DDR, #$ff ; 
	MOV PC_CR1, #$ff
	MOV PC_CR2, #$00
	
	MOV PE_DDR, #$ff ; установить режим работы порта
	MOV PE_CR1, #$ff
	MOV PE_CR2, #$00
	
	MOV PG_DDR, #$03 ; установить режим работы порта
	MOV PG_CR1, #$03
	MOV PG_CR2, #$00

	;Внешние прерывания для порта E (Кнопка 5)
	
	;BSET EXTI_CR2, #0 ;11 Rising and falling edge
	;BSET EXTI_CR2, #1
	
	;Внешние прерывания для порта B
	MOV PB_DDR, #$00 ;КнопкИ
	MOV PB_CR1, #$00 ;1: With pull-up
	MOV PB_CR2, #$00 ;1: External interrupt enabled
	;BRES EXTI_CR1, #2 ;11 Rising and falling edge
	;BSET EXTI_CR1, #3
	
	MOV PA_DDR, #$00 ;Концевые
	MOV PA_CR1, #$ff ;1: With pull-up
	MOV PA_CR2, #$00 ;1: External interrupt enabled
	
	MOV PG_ODR, #$00 ;шпиндель
	MOV PC_ODR, 0;
		
	;TIM1 - 3й двигатель \ Контроль инструмента
	;timer 3, 1, $1015	;TIM3 - 3й двигатель Z
	timer 2, 1, $1015	;TIM2 - 1й двигатель X
	;timer 4, 4, $77		;TIM4 - Кнопки
	
	call _init
	RIM	
_start:
	call _cicle;	
	jra _start
	

; FUNCTIONS! ---------------------------------------------------------------------------------------
	
_setSpeed:
	PUSH A
	CPW X, #2500
	JRULT _exit_ss
	ld a, xh
	ld TIM2_ARRH, a
	ld a, xl
	ld TIM2_ARRL, a
_exit_ss:
	POP A	
  ret
	
_motor_start:
	PUSH A
	CPW X, #00
	JREQ _mot_cont
	ld a, xh
	ld TIM2_ARRH, a
	ld a, xl
	ld TIM2_ARRL, a
_mot_cont:
	POP A	
	BSET TIM2_CR1, #0 ;STOP	
  ret

_motor_stop:
	BRES TIM2_CR1, #0 ;STOP	
	LD A, #15
	AND A, PC_ODR
	LD PC_ODR, A
	MOV PD_ODR, #$00
	MOV PE_ODR, #$00
  ret
	
; ---------------------------------------------------------------------------------------
		
		
_iPORTB_EXTI:	
	;BSET EXTI_SR1, #0
	iret


_iTim4_OVF:
	SIM
  BRES TIM4_SR, #0

_tim4Exit:
	RIM
	iret

;_iADC Compare --------------------------------
_iADC:
	SIM
	
	RIM
	iret
	
NonHandledInterrupt:
	iret
		
end:
	end
	