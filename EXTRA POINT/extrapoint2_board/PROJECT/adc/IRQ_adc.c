/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_adc.c
** Last modified Date:  20184-12-30
** Last Version:        V1.00
** Descriptions:        functions to manage A/D interrupts
** Correlated files:    adc.h
**--------------------------------------------------------------------------------------------------------       
*********************************************************************************************************/

#include "lpc17xx.h"
#include "adc.h"
#include "../timer/timer.h"

/*----------------------------------------------------------------------------
  A/D IRQ: Executed when A/D Conversion is ready (signal from ADC peripheral)
 *----------------------------------------------------------------------------*/

unsigned short AD_current;   
unsigned short AD_last = 0xFF;     /* Last converted value               */

/* k=1/f'*f/n  k=f/(f'*n) k=25MHz/(f'*45) */

//const int freqs[8]={4240,3779,3367,3175,2834,2525,2249,2120};
/* 
131Hz		k=4240 C3
147Hz		k=3779
165Hz		k=3367
175Hz		k=3175
196Hz		k=2834		
220Hz		k=2525
247Hz		k=2249
262Hz		k=2120 C4
*/

const int freqs[8]={2120,1890,1684,1592,1417,1263,1125,1062};
/*
262Hz	k=2120		c4
294Hz	k=1890		
330Hz	k=1684		
349Hz	k=1592		
392Hz	k=1417		
440Hz	k=1263		
494Hz	k=1125		
523Hz	k=1062		c5

*/

volatile float volume = 0;

void ADC_IRQHandler(void) {
  	
  AD_current = ((LPC_ADC->ADGDR>>4) & 0xFFF);/* Read Conversion Result             */
	
  if(AD_current != AD_last){
		
		//min 0x0000 	max 0x0FFF
		
		if(AD_current <= 0x0006) {
			volume = 0;
		} else if(AD_current > 0x0006 && AD_current <= 0x01C8) {		//	6			456
			volume = 1.2;
		} else if(AD_current > 0x01C8 && AD_current <= 0x0390) {		//	457		912
			volume = 2.5;
		} else if(AD_current > 0x0390 && AD_current <= 0x0558) {		//	913		1368
			volume = 3.5;
		} else if(AD_current > 0x0558 && AD_current <= 0x0720) {		//	1369	1824
			volume = 4;
		} else if(AD_current > 0x0720 && AD_current <= 0x08E8) {		//	1825	2280
			volume = 5;
		} else if(AD_current > 0x08E8 && AD_current <= 0x0AB0) {		//	2281	2736
			volume = 6;
		} else if(AD_current > 0x0AB0 && AD_current <= 0x0C78) {		//	2737	3192
			volume = 7;
		} else if(AD_current > 0x0C78 && AD_current <= 0x0E40) {		//	3193	3648
			volume = 8;
		} else if(AD_current > 0x0E40 && AD_current <= 0x0FFF) {		//	3649	4095
			volume = 9;
		}
		
		/*disable_timer(0);
		reset_timer(0);
		init_timer(0,freqs[AD_current*7/0xFFF]);
		enable_timer(0);*/
		
		AD_last = AD_current;
  }
	
}
