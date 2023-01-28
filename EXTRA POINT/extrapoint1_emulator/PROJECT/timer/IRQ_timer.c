/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_timer.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    timer.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "lpc17xx.h"
#include "timer.h"
#include "../GLCD/GLCD.h" 
#include "../TouchPanel/TouchPanel.h"
#include "../Controller/IronManController.h"
#include "../RIT/RIT.h"
#include "../GLCD/IronManPicture.h"


#define fly_value 10

volatile int seconds = 0;
volatile int minutes = 0;
volatile int hours = 0;

volatile uint16_t enable_update_image_eating = 0;

extern uint16_t background_color;

volatile int16_t seconds_passed = seconds_passed_last_level;

/******************************************************************************
** Function name:		TIMER0_IRQHandler
**
** Descriptions:		Timer/Counter 0 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void TIMER0_IRQHandler (void) {
	
	//this manages the time
	seconds++;
	if(seconds >= 60) {
		minutes++;
		seconds = 0;
		if(minutes >= 60) {
			hours++;
			minutes = 0;
		}
	}
	
	updateAge();														//update the new age
	
	if(enable_update_image_eating == 0) {
		updateImage(seconds%2==0, 0);					//this will paint the energy around the iron man
		seconds_passed--;											//it is decreased only when Iron man is not eating
		
		if(seconds_passed % seconds_passed_last_level == 0) {
			decreaseBatteryLevel();													//this will decrease the level of battery depending on the seconds
			seconds_passed = seconds_passed_last_level;
		}
	}
	
  LPC_TIM0->IR = 1;			/* clear interrupt flag */
  return;
}

/******************************************************************************
** Function name:		TIMER1_IRQHandler
**
** Descriptions:		It has the responssability to animate the Iron man
**									when it must eat
**
** parameters:			go_to_eat is used to know which image must be painted
**										1 = meal
**										2 = snack
**										3 = iron man while eats
** Returned value:	None
**
******************************************************************************/
void TIMER1_IRQHandler (void) {
	extern uint16_t go_to_eat;
	
	if(go_to_eat != 0) {
		enable_update_image_eating = 1;	//disable the update of image in the timer
		
		extern Image mega_iron_man;
		extern Image iron_man_eating;
		extern Box_Coordinate box_meal;
		extern uint16_t image_iron_man_eating[][2];
		
		uint16_t x = MAX_X/2 - (mega_iron_man.width/2);
		uint16_t y = box_meal.y_0 - mega_iron_man.heigth;
		
		//coordinate for cleaning
		Box_Coordinate coordinate;
		coordinate.x_0 = x;	coordinate.x_1 = x+mega_iron_man.width;
		coordinate.y_0 = y;	coordinate.y_1 = y+mega_iron_man.heigth;
		
		LCD_ClearFaster(&coordinate, background_color);
		
		//coordinate for the position of Iron Man
		x = MAX_X/2 - (iron_man_eating.width/2);
		y = box_meal.y_0 - iron_man_eating.heigth;
		coordinate.x_0 = x;	coordinate.x_1 = x+iron_man_eating.width;
		coordinate.y_0 = y;	coordinate.y_1 = y+iron_man_eating.heigth;
		
		uint16_t animation = 15;	//used to move the image on the display
		
		//draws the food/snack on display
		drawImageEating(x+(animation*3)+iron_man_eating.width, coordinate.y_1, go_to_eat);
		
		//normal image (go to eat)
		for(int16_t i=0; i<=animation*5; i+=animation) {
			x += animation;
			coordinate.x_0 = x;	coordinate.x_1 = x+iron_man_eating.width;
			
			if(i == animation*5) {
				//there it will set the coordinate and after it will draw the image
				extern uint16_t width_iron_man_eating_1;
				extern uint16_t heigth_iron_man_eating_1;
				
				uint16_t xPos = MAX_X/2 - (width_iron_man_eating_1/2) + (animation*5) - 6;
				uint16_t yPos = box_meal.y_0 - heigth_iron_man_eating_1;
				
				Box_Coordinate coordinatePos;
				coordinatePos.x_0 = xPos;	coordinatePos.x_1 = xPos+width_iron_man_eating_1;
				coordinatePos.y_0 = yPos;	coordinatePos.y_1 = yPos+heigth_iron_man_eating_1;
				
				drawImageEating(xPos, yPos, 3);	//this will draw the image where iron man is eating
				LCD_ClearFaster(&coordinatePos, background_color);
			} else {
				drawImage(x, y, &iron_man_eating, image_iron_man_eating, background_color, 2, 0);
				LCD_ClearFaster(&coordinate, background_color);
			}
		}
	
		//reversed image (go to the normal position)
		for(int16_t i=animation*5; i>0; i-=animation) {
			x -= animation;
			coordinate.x_0 = x;	coordinate.x_1 = x+iron_man_eating.width;
			drawImage(x, y, &iron_man_eating, image_iron_man_eating, background_color, 2, 1);
			LCD_ClearFaster(&coordinate, background_color);
		}
		
		//redraw the image of iron man on the display
		updateImage(2, 0);
		enable_update_image_eating = 0;
		go_to_eat = 0;														//reset the variable
		enable_RIT();															//enable the RIT
	}
		
  LPC_TIM1->IR = 1;			/* clear interrupt flag */
  return;
}


/******************************************************************************
**                            End Of File
******************************************************************************/
