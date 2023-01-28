/*----------------------------------------------------------------------------
 * Name:    sample.c
 * Purpose: 
 *		to control led11 and led 10 through EINT buttons (similarly to project 03_)
 *		to control leds9 to led4 by the timer handler (1 second - circular cycling)
 * Note(s): this version supports the LANDTIGER Emulator
 * Author: 	Paolo BERNARDI - PoliTO - last modified 15/12/2020
 *----------------------------------------------------------------------------
 *
 * This software is supplied "AS IS" without warranties of any kind.
 *
 * Copyright (c) 2017 Politecnico di Torino. All rights reserved.
 *----------------------------------------------------------------------------*/

                  
#include <stdio.h>
#include "LPC17xx.H"                    /* LPC17xx definitions                */
#include "led/led.h"
#include "button_EXINT/button.h"
#include "timer/timer.h"

/* Led external variables from funct_led */
extern unsigned char led_value;					/* defined in lib_led								*/
#ifdef SIMULATOR
extern uint8_t ScaleFlag; // <- ScaleFlag needs to visible in order for the emulator to find the symbol (can be placed also inside system_LPC17xx.h but since it is RO, it needs more work)
#endif
/*----------------------------------------------------------------------------
  Main Program
 *----------------------------------------------------------------------------*/


int main (void) {
  	
	SystemInit();  												/* System Initialization (i.e., PLL)  */
  LED_init();                           /* LED Initialization                 */
  //BUTTON_init();												/* BUTTON Initialization              */
	
	/* TIMER2 Initialization              */
	/* K = T*Fr = [s]*[Hz] = [s]*[1/s]	  */
	
	uint32_t tot_time = 0x88B8;							//1,4 ms * 25 MHz
	uint32_t perc_time = 0x222E;						//tot_time * 25%
	//uint32_t perc_time = 0x445C;						//tot_time * 50%
	//uint32_t perc_time = 0x668A;						//tot_time * 75%
	
	/*
		for MR0											for MR1												for MR2															for MR3
		MCR = 1		001		interrupt		MCR = 8		001 000	interrupt		MCR = 64		001 000 000	interrupt		MCR = 512			001 000 000 000	interrupt
		MCR = 3		011		reset				MCR = 24	011	000	reset				MCR = 192		011	000	000 reset				MCR = 1536		011	000	000 000 reset
		MCR = 7		111		stop				MCR = 56	111	000	stop				MCR = 448		111	000	000 stop				MCR = 3584		111	000	000 000 stop
	*/
	
	//MCR = 25		011 001
	init_timer(2, 25, 0, perc_time, tot_time, 0, 0);
							
	enable_timer(2);
	
	LED_On(2);
	LED_On(4);
	
	LPC_SC->PCON |= 0x1;									/* power-down	mode										*/
	LPC_SC->PCON &= 0xFFFFFFFFD;						
		
  while (1) {                           /* Loop forever                       */	
		__ASM("wfi");
  }

}


/*char* conversion_decimal_hexadecimal(int num) {
	char* table = "0123456789ABCDEF";
	char* conversion = (char *) malloc(10);
	int i = 9;							//index of conversion string
	
	for(i=0; i<10; i++) {
	    conversion[i] = '0';
	}
	i = 9;
	
	int quotient = 0;
	do {
		quotient = num / 16;
		while(num>=16) num -= 16;
		conversion[i--] = table[num];
		num = quotient;
	}while(quotient != 0);

	conversion[1] = 'x';
	return conversion;
}*/
