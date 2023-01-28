;/**************************************************************************//**
; * @file     startup_LPC17xx.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           NXP LPC17xx Device Series
; * @version  V1.10
; * @date     06. April 2011
; *
; * @note
; * Copyright (C) 2009-2011 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000000

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF

				AREA	MY_DATA, DATA, READWRITE, align=3
Calories_ordered	SPACE	6*4
Quantity_ordered	SPACE	6*4

				

				AREA    |.text|, CODE, READONLY, align=3

array			RN R0			;array to sort				argument and result
len				RN R1			;len of array				argument
temp_array		RN R2			;							argument

internal_len	RN R3			;							variable
i				RN R4			;index						variable
j				RN R5			;index						variable
value			RN R6			;							variable
next_value		RN R7			;							variable

max			RN	R11				;max caloric ingredient		variable



Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]                                            
                LDR     R0, =Reset_Handler
				
				LDRB len, Num_ingredients
				
				MOV i, #1								;i = 1		index for Ingredient_calories
				MOV j, #0								;j = 0		index for Calories_ordered
				MOV max, #0
				
				LDR temp_array, =Ingredient_calories
				LDR array, =Calories_ordered
loop_first_array
				LDR next_value, [temp_array, i, LSL #2]		;get the value from the array in ROM
				STR next_value, [array, j, LSL #2]			;put the value in the array in RAM
				
				
				;put in the stack only what I want to preserve and I will calculate the product
				PUSH {array, temp_array, i}
				SUB i, #1
				LDR value, [temp_array, i, LSL #2]
				LDR temp_array, =Ingredient_quantity	;it is used in this loop to search the max value
				
				BL Finder_value
				
				MUL value, next_value, array			;value = calories * quantity
				
				CMP value, max
				MOVHI max, value
				
				POP {array, temp_array, i}
				
				;here I will continue with the normal loop
				ADD i, #2
				ADD j, #1
				
				CMP i, len, LSL #1
				BLO loop_first_array
				
				BL Sort					;sort array
				
				nop
				
				BL Replace_ID			;search the own id for each value in the sorted array


	;repeat for the second array
				MOV i, #1
				MOV j, #0
				LDR temp_array, =Ingredient_quantity
				LDR array, =Quantity_ordered
loop_second_array
				LDR value, [temp_array, i, LSL #2]		;get the value from the array in ROM
				STR value, [array, j, LSL #2]			;put the value in the array in RAM
				ADD i, #2
				ADD j, #1
				
				CMP i, len, LSL #1
				BLO loop_second_array
				
				BL Sort					;sort array
				BL Replace_ID			;search the own id for each value in the sorted array
				
				BX      R0
                ENDP

;algorithm in C
;void bubble_sort(int array[], int len) {
;    for (int i = 0; i < len - 1; i++) {
;        for (int j = 0; j < len - i - 1; j++) {
;            if (array[j] < array[j + 1]) {
;                int value = array[j + 1];
;                array[j + 1] = array[j];
;                array[j] = value;
;            }
;        }
;    }
;}

;	@parameter: 	array, len
Sort			PROC
				PUSH {LR, len, array, internal_len, i, j, value, next_value}
				
				MOV i, #-1								;i = -1
external_loop
				ADD i, #1
				CMP i, len
				BEQ exit
				
				SUB internal_len, len, i				;internal_len = len - i
				SUB internal_len, len, #1				;internal_len = (len-i) - 1
				MOV j, #-1								;j = -1
internal_loop	
				ADD j, #1
				CMP j, internal_len
				BHS external_loop
				
				LDR value, [array, j, LSL #2]			;value = array[j]
				
				ADD j, #1
				LDR next_value, [array, j, LSL #2]		;next_value = array[j+1]
				ADD j, #-1
				
				CMP next_value, value
				BLO internal_loop
				
				;LDR value, [array, j, LSL #2]			;value = array[j]
				;LDR next_value, [array, j, LSL #2]		;next_value = array[j+1]	
				
				STR next_value, [array, j, LSL #2]		;array[j] = array[j+1]
				ADD j, #1
				STR value, [array, j, LSL #2]			;array[j+1] = array[j]
				ADD j, #-1
				
				
				B internal_loop
exit			
				POP {PC, len, array, internal_len, i, j, value, next_value}
				ENDP

; @parameter array, len, temp_array
Replace_ID		PROC
				PUSH {LR, value, i, j, len, next_value, temp_array, array}

				MOV i, #-1
loop_id
				ADD i, #1
				CMP i, len
				BHS exit_loop_id
				
				LDR value, [array, i, LSL #2]			;value = array[i]
				
				MOV j, #-1
internal_loop_id
				ADD j, #2
				
				LDR next_value, [temp_array, j, LSL #2]
				
				CMP value, next_value
				BNE internal_loop_id
				
				SUB j, #1
				LDR value, [temp_array, j, LSL #2]				;ID from ROM
				STR value, [array, i, LSL #2]					;ID in RAM
				
				B loop_id
exit_loop_id
				POP {PC, value, i, j, len, next_value, temp_array, array}
				ENDP


; @parameter temp_array, len, value
; @result array (value of key)
Finder_value	PROC
				PUSH {LR, len, i, value, temp_array, next_value}
				
				MOV i, #-2									;i = 0
loop
				ADD i, #2									;i += 2
				CMP i, len, LSL #1							;if(i >= len) goto exit
				BHS exit_finder
				
				LDR next_value, [temp_array, i, LSL #2]		;next_value = temp_array[i]
				CMP value, next_value						;if(value != next_value) goto LOOP
				
				BNE loop
				
				ADD i, #1
				LDR array, [temp_array, i, LSL #2]			;value of key
				
exit_finder
				POP {PC, len, i, value, temp_array, next_value}
				ENDP

Ingredient_calories 	DCD 0x01, 30, 0x02, 70, 0x03, 200
						DCD 0x04, 42, 0x05, 81, 0x06, 20

Ingredient_quantity 	DCD 0x02, 50, 0x05, 3, 0x03, 10, 0x01, 5, 0x04, 8, 0x06, 30

Num_ingredients 		DCB 6

						LTORG

 
; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]
                B       .
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                B       .
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit                

                END
