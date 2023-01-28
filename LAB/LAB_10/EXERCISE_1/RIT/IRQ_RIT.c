/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_RIT.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    RIT.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "lpc17xx.h"
#include "RIT.h"
#include "../led/led.h"

/******************************************************************************
** Function name:		RIT_IRQHandler
**
** Descriptions:		REPETITIVE INTERRUPT TIMER handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/

volatile int down_0 = 0;				//variabile che indica la pressione del bottone INT0
volatile int down_1 = 0;				//variabile che indica la pressione del bottone KEY1
volatile int down_2 = 0;				//variabile che indica la pressione del bottone KEY2

void RIT_IRQHandler (void) {
	
	if(down_0 != 0) {
		if((LPC_GPIO2->FIOPIN & (1<<10)) == 0){
			reset_RIT();
		} else {																		/* button released */
			down_0 = 0;			
			disable_RIT();
			reset_RIT();
			NVIC_EnableIRQ(EINT0_IRQn);							 /* disable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 20);     /* External interrupt 0 pin selection */
		}
	} 
	
	if(down_1 != 0) {
		if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){
			reset_RIT();
		} else {																		/* button released */
			down_1 = 0;			
			disable_RIT();
			reset_RIT();
			NVIC_EnableIRQ(EINT1_IRQn);							 /* disable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 22);     /* External interrupt 0 pin selection */
		}
	} 
	
	if(down_2 != 0) {
		if((LPC_GPIO2->FIOPIN & (1<<12)) == 0){
			reset_RIT();
		} else {																		/* button released */
			down_2 = 0;			
			disable_RIT();
			reset_RIT();
			NVIC_EnableIRQ(EINT2_IRQn);							 /* disable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 24);     /* External interrupt 0 pin selection */
		}
	}
	
  LPC_RIT->RICTRL |= 0x1;					/* clear interrupt flag */
	
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
