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
#include "../Controller/IronManController.h"

/******************************************************************************
** Function name:		RIT_IRQHandler
**
** Descriptions:		REPETITIVE INTERRUPT TIMER handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
static int selection = 0;		//indicates the selection choosed between meal and snack

extern int16_t happiness;			//happiness level
extern int16_t hungry;				//satiety level

void RIT_IRQHandler (void) {
	static int J_right = 0;
	static int J_left = 0;
	
	if((LPC_GPIO1->FIOPIN & (1<<28)) == 0){					/* Joytick right pressed p1.28 */
		if(happiness > 0 && hungry > 0) {
			J_right++;
			switch(J_right){
				case 1:
					selection = 1;
					selectionRightJoystick();
					break;
				default:
					break;
			}
		}
	}
	else{
			J_right = 0;
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<27)) == 0){					/* Joytick left pressed p1.27 */
		if(happiness > 0 && hungry > 0) {
			J_left++;
			switch(J_left){
				case 1:
					selection = 2;
					selectionLeftJoystick();
					break;
				default:
					break;
			}
		}
	} else {
			J_left = 0;
	}

	
	if((LPC_GPIO1->FIOPIN & (1<<25)) == 0){					/* Joytick sel pressed p1.28 */
		if(happiness <= 0 || hungry <= 0) {
			setDisplay();
			selection = 0;
			LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
			return;
		}
		
		switch(selection) {
			case 1:
				increaseSnackLevel();
				break;
			case 2:
				increaseMealLevel();
				break;
			default:
				break;
		}
	}
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
