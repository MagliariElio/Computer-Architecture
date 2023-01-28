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
#include "../Controller/IronManController.h"
#include "../RIT/RIT.h"
#include "../GLCD/IronManPicture.h"

#define fly_value 10

volatile int seconds = 0;
volatile int minutes = 0;
volatile int hours = 0;

volatile uint8_t enable_update_image_eating = 0;
volatile uint8_t enable_animation_cuddles = 0;
volatile uint8_t count_animation_cuddles = 0;

extern uint16_t background_color;

extern Box_Coordinate box_meal;
extern Box_Coordinate box_snack;

volatile int16_t seconds_passed = seconds_passed_last_level;

uint16_t SinTable[45] = {
    410, 467, 523, 576, 627, 673, 714, 749, 778,
    799, 813, 819, 817, 807, 789, 764, 732, 694, 
    650, 602, 550, 495, 438, 381, 324, 270, 217,
    169, 125, 87 , 55 , 30 , 12 , 2  , 0  , 6  ,   
    20 , 41 , 70 , 105, 146, 193, 243, 297, 353
};

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
	
	updateVolume();													//it updates the icon speaker
	
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
	extern uint8_t go_to_eat;
	extern volatile uint8_t execute_song;
	
	if(go_to_eat != 0) {
		enable_update_image_eating = 1;	//disable the update of image (energy) in the timer
		
		extern Image mega_iron_man;
		extern Image iron_man_eating;
		extern Box_Coordinate box_meal;
		extern uint16_t image_iron_man_eating[][2];
		
		static Box_Coordinate coordinate;
		uint16_t animation = 15;	//used to move the image on the display
		
		static uint16_t x = 0;
		static uint16_t y = 0;
		
		if(go_to_eat <= 3) {
			x = MAX_X/2 - (mega_iron_man.width/2);
			y = box_meal.y_0 - mega_iron_man.heigth;
			
			//coordinate for cleaning
			coordinate.x_0 = x;	coordinate.x_1 = x+mega_iron_man.width;
			coordinate.y_0 = y;	coordinate.y_1 = y+mega_iron_man.heigth;
			
			LCD_ClearFaster(&coordinate, background_color);
			
			//coordinate for the position of Iron Man
			x = MAX_X/2 - (iron_man_eating.width/2);
			y = box_meal.y_0 - iron_man_eating.heigth;
			coordinate.x_0 = x;	coordinate.x_1 = x+iron_man_eating.width;
			coordinate.y_0 = y;	coordinate.y_1 = y+iron_man_eating.heigth;
			
			//draws the food/snack on display
			drawImageEating(x+(animation*3)+iron_man_eating.width, coordinate.y_1, go_to_eat);
			
			go_to_eat = 4;
		}
		
		static int16_t i=0;
		if(go_to_eat == 4) {		//normal image (go to eat)
			
			coordinate.x_0 = x;	coordinate.x_1 = x+iron_man_eating.width;
			LCD_ClearFaster(&coordinate, background_color);
			
			static Box_Coordinate coordinatePos;
			if(i == animation*5) {
				//there it will set the coordinate and after it will draw the image
				extern uint16_t width_iron_man_eating_1;
				extern uint16_t heigth_iron_man_eating_1;
				
				uint16_t xPos = MAX_X/2 - (width_iron_man_eating_1/2) + (animation*5) - 6;
				uint16_t yPos = box_meal.y_0 - heigth_iron_man_eating_1;
				
				coordinatePos.x_0 = xPos;	coordinatePos.x_1 = xPos+width_iron_man_eating_1;
				coordinatePos.y_0 = yPos;	coordinatePos.y_1 = yPos+heigth_iron_man_eating_1;
				
				drawImageEating(xPos, yPos, 3);	//this will draw the image where iron man is eating
				
				execute_song = 2;
			} else {
				x += animation;
				drawImage(x, y, &iron_man_eating, image_iron_man_eating, background_color, 2, 0);
			}
			
			if(i<=animation*5) {
				i += animation;
			} else {
				LCD_ClearFaster(&coordinatePos, background_color);
				go_to_eat = 5;
			}
		}
		
		//reversed image (go to the normal position)
		if(go_to_eat == 5) {
			//for(int16_t i=animation*5; i>0; i-=animation) {
				LCD_ClearFaster(&coordinate, background_color);
				x -= animation;
				coordinate.x_0 = x;	coordinate.x_1 = x+iron_man_eating.width;
				drawImage(x, y, &iron_man_eating, image_iron_man_eating, background_color, 2, 1);
			
			if(i>0) {
				i -= animation;
			} else {
				go_to_eat = 6;
			}
	  }
		
		//redraw the image of iron man on the display
		if(go_to_eat == 6) {
			LCD_ClearFaster(&coordinate, background_color);
			updateImage(2, 0);
			enable_update_image_eating = 0;
			go_to_eat = 0;														//reset the variable
			enable_RIT();															//enable the RIT
		}
	}
	
	if(enable_animation_cuddles == 1) {
		enable_RIT();									//enable the RIT
		count_animation_cuddles++;			//it counts how many times the timer has reached the count
		
		Image image_battery;
		extern uint16_t width_battery, heigth_battery, elements_full_heart;
		image_battery.width = width_battery;
		image_battery.heigth = heigth_battery;
		image_battery.elements = elements_full_heart;
		
		uint16_t x_1 = MAX_X/2+50 + image_battery.width;
		uint16_t x_2 = MAX_X/2-80 - image_battery.width;
		uint16_t y = 200;
		
		Box_Coordinate coordinate;			//coordinate used for cleaning
		coordinate.x_0 = x_1;	coordinate.x_1 = x_1 + image_battery.width;
		coordinate.y_0 = y;	coordinate.y_1 = y + image_battery.heigth;
		
		Box_Coordinate coordinate_2;	//coordinate used for cleaning
		coordinate_2.x_0 = x_2;	coordinate_2.x_1 = x_2 + image_battery.width;
		coordinate_2.y_0 = y;	coordinate_2.y_1 = y + image_battery.heigth;
		
		execute_song = 4;
		
		if(count_animation_cuddles % 2 == 0) {
			drawImage(x_1, y, &image_battery, image_full_heart, top_background_color, 2, 0);			//first heart
			drawImage(x_2, y, &image_battery, image_full_heart, top_background_color, 2, 0);			//second heart
		} else {
			LCD_ClearFaster(&coordinate, background_color);
			//LCD_Clear(background_color, coordinate.x_0, coordinate.y_0, coordinate.x_1, coordinate.y_1);
			
			LCD_ClearFaster(&coordinate_2, background_color);
			//LCD_Clear(background_color, coordinate_2.x_0, coordinate_2.y_0, coordinate_2.x_1, coordinate_2.y_1);
		}
		
		if(count_animation_cuddles >= 6) {
			LCD_ClearFaster(&coordinate, background_color);
			LCD_ClearFaster(&coordinate_2, background_color);
			
			
			enable_update_image_eating = 0;
			enable_animation_cuddles = 0;
			count_animation_cuddles = 0;
			
			disable_timer(1);
			reset_timer(1);
			//init_timer(1, 0x1312D0);			//original settings
			init_timer(1, 0.5*25000000); 						   	 /* 50ms * 25MHz = 0x1312D0 */
			enable_timer(1);
		}
	}
	
  LPC_TIM1->IR = 1;			/* clear interrupt flag */
  return;
}

/******************************************************************************
** Function name:		TIMER2_IRQHandler
**
** Descriptions:		Timer/Counter 2 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void TIMER2_IRQHandler (void) {
	static int sineticks=0;
	/* DAC management */	
	static int currentValue;
	extern volatile float volume;
	
	float redFact = 0.8 + (volume * 6/40);
	if(volume == 0) redFact = 0;
	
	currentValue = SinTable[sineticks] * redFact;
	
	LPC_DAC->DACR = currentValue <<6;
	sineticks++;
	if(sineticks >= 45) sineticks=0;
	
  LPC_TIM2->IR = 1;			/* clear interrupt flag */
  return;
}

/******************************************************************************
** Function name:		Timer3_IRQHandler
**
** Descriptions:		Timer/Counter 3 interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void TIMER3_IRQHandler (void) {
	disable_timer(2);
	
  LPC_TIM3->IR = 1;			/* clear interrupt flag */
  return;
}


/******************************************************************************
**                            End Of File
******************************************************************************/
