;values

nul: equ 0


bit_set: macro
	bset \1, #\2
	endm
		
bit_res: macro
	bres \1, #\2
	endm
	

copy: macro \dst, \src
  ldw X, \src
	ldw \dst, X
	endm



wait_off: macro \port, \pin
\@wait_local: btjt \port, #\pin, \@wait_local
  endm
		
wait_on: macro \port, \pin
\@wait_local: btjf \port, #\pin, \@wait_local
  endm
		
wait: macro \wait
  LDW X, \wait
\@local:
  decw X
	jrne \@local
  endm
	
setClock: macro
  mov CLK_SWR, #$E1
	mov CLK_CKDIVR, #\1;
	endm	

exClock: macro
	BSET CLK_ECKR, #0 ;//HSEEN Разрешаем работу генератора с внешним кварцем (HSEEN)
	BSET CLK_SWCR, #1 ;//SWENРазрешаем переключение генераторов;
	mov CLK_SWR, #$B4 ;//Выбираем clock от кварцевого генератора (HSE)
	mov CLK_CKDIVR, \1;
	endm

	
load_counter: macro
  ldw x, #\3
	ld a, xh
	ld \1, a
	ld a, xl
	ld \2, a
	endm

timer: macro \timNum, \prsc, \arr
  #if \timNum = 2
		bit_set TIM2_CR1, TIM_CR_bit_ARPE;      //Разрешаем буферизацию ARR
		MOV TIM2_IER, #01 ;Update overflow and Capture/Compare 1
		mov TIM2_PSCR, #\prsc;       //Предделитель 16000000 / 1 = 16000000 Hz
		load_counter TIM2_ARRH, TIM2_ARRL, \arr
		BSET TIM2_CR1, #0 ;START
	#endif
	#if \timNum = 3
		bit_set TIM3_CR1, TIM_CR_bit_ARPE;      //Разрешаем буферизацию ARR
		MOV TIM3_IER, #01 ;Update overflow and Capture/Compare 1
		mov TIM3_PSCR, #\prsc;       //Предделитель 16000000 / 1 = 16000000 Hz
		load_counter TIM3_ARRH, TIM3_ARRL, \arr
		BSET TIM3_CR1, #0 ;START
	#endif
	#if \timNum = 4
		bit_set TIM4_CR1, TIM_CR_bit_ARPE;      //Разрешаем буферизацию ARR
		MOV TIM4_IER, #01 ;Update overflow and Capture/Compare 1
		MOV TIM4_PSCR, #\prsc;       //Предделитель 16000000 / 1 = 16000000 Hz
		MOV TIM4_ARR, \arr
		BSET TIM4_CR1, #0 ;START
	#endif
	#if \timNum = 5
		bit_set TIM5_CR1, TIM_CR_bit_ARPE;      //Разрешаем буферизацию ARR
		MOV TIM5_IER, #01 ;Update overflow and Capture/Compare 1
		mov TIM5_PSCR, #\prsc;       //Предделитель 16000000 / 1 = 16000000 Hz
		load_counter TIM5_ARRH, TIM5_ARRL, \arr
		BSET TIM5_CR1, #0 ;START
	#endif
	endm
		
timerCC: macro \timNum, \prsc, \arr, \ccm
  BSET TIM\timNum_CR1, TIM_CR_bit_ARPE;      //Разрешаем буферизацию ARR
	MOV TIM\timNum_IER, #03 ;Update overflow and Capture/Compare 1
  MOV TIM\timNum_CCMR1, #00   ;Frozen Mode
  mov TIM\timNum_PSCR, #\prsc;       //Предделитель 16000000 / 1 = 16000000 Hz
	LDW X, #\arr
	mov TIM\timNum_ARRH, xh;       //Автозагрузка счетчика старший байт 16000000 / 65535 = 244 Hz
  mov TIM\timNum_ARRL, xl;       //Автозагрузка счетчика младший байт
	LDW X, #\ccm
	MOV TIM\timNum_CCR1H, xh
  MOV TIM\timNum_CCR1L, xl
	BSET TIM\timNum_CR1, #0 ;START
	endm
	
PORT_INIT: macro \portbase, \ddr, \odr
	MOV (\portbase + 2), \ddr ; установить режим работы порта
	MOV \portbase + 3, #$ff
	MOV \portbase + 4, #$00
	#if \odr
		MOV \portbase, \odr
	#endif
	endm
