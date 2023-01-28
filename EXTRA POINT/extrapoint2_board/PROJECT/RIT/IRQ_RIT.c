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
#include "../timer/timer.h"
#include "../GLCD/GLCD.h" 
#include "../ADC/adc.h"
#include "../TouchPanel/TouchPanel.h"

#define RIT_SEMIMINIMA 8
#define RIT_MINIMA 16
#define RIT_INTERA 32

#define UPTICKS 1

volatile uint8_t enable_RIT_software = 1;

NOTE song_move_left_right[] = {
	{c5, time_semibiscroma},
	{c5, time_biscroma},
	{c5, time_semibiscroma}
};

NOTE song_move_select[] = {
	{c5, time_biscroma},
	{c5, time_semibiscroma}
};

NOTE song_iron_man_goes_to_eat[] = {
	{a2b, time_semicroma},
	{d4, time_croma},
	{a3, time_croma},
	{d4, time_croma},
	{a3, time_croma},
	{d4, time_croma},
	{a3, time_croma},
	{d4, time_croma},
	{a3, time_croma},
	{d4, time_croma},
	{a3, time_croma},
	{d4, time_croma},
	{a3, time_croma},
	{a3b, time_semicroma}
};

NOTE song_iron_man_goes_away[] = {
	{a2b, time_semicroma},
	{a2b, time_semicroma},
	{d4, time_croma},
	{a3, time_croma},
	{a3b, time_biscroma},
	{a3b, time_semicroma},
	{a3b, time_semicroma},
	{d4, time_croma},
	{a3b, time_semicroma},
	{a2b, time_biscroma},
	{d4, time_croma},
	{a3, time_croma},
	{a3b, time_semicroma}
};

NOTE song_cuddles[] = {
	{a2b, time_semicroma},
	{a2b, time_semicroma},
	{d4, time_croma},
	{a2b, time_biscroma},
	{a3, time_croma},
	{a2b, time_biscroma},
	{a2b, time_biscroma},
	{a2b, time_biscroma},
	{a2b, time_biscroma},
	{a3, time_croma},
	{a3, time_croma},
	{a3, time_croma},
	{a3, time_croma},
	{a3, time_croma},
	{a2b, time_biscroma},
	{pause, time_semicroma},
	{a3b, time_semicroma},
	{a3b, time_semicroma},
	{a3b, time_semicroma},
	{a2b, time_semicroma},
	{a2b, time_semicroma},
	{d4, time_croma},
	{a3, time_croma},
	{pause, time_semicroma},
	{a3b, time_semicroma}
};

/******************************************************************************
** Function name:		cuddlesAnimation
**
** Descriptions:		This will do the animation of cuddles
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void cuddlesAnimation() {
	extern volatile uint8_t enable_update_image_eating;
	extern volatile uint8_t enable_animation_cuddles;
	
	enable_update_image_eating = 1;	//disable the update of image in the timer
	enable_animation_cuddles = 1;		//enable cuddles animation
	
	disable_timer(1);
	reset_timer(1);
	init_timer(1, 25000000*0.667);					//2s/3 * 25MHz (but it will be repeated 3 times)
	enable_timer(1);
	
	return;
}


static int selection = 0;		//indicates the selection choosed between meal and snack

extern int16_t happiness;			//happiness level
extern int16_t hungry;				//satiety level

/******************************************************************************
** Function name:		RIT_IRQHandler
**
** Descriptions:		REPETITIVE INTERRUPT TIMER handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void RIT_IRQHandler (void) {
	
	if(enable_RIT_software == 1) {			//this will execute this operations only when RIT is enabled
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
		
		//check display
		if(getDisplayPoint(&display, Read_Ads7846(), &matrix )){
			extern Box_Coordinate box_meal;
			extern Image mega_iron_man;
			
			int y_start = box_meal.y_0 - mega_iron_man.heigth;
			int y_end = y_start + mega_iron_man.width;
			int x_start = MAX_X/2 - (mega_iron_man.width/2);
			int x_end = x_start + mega_iron_man.heigth;
			
			if((display.y >= y_start && display.y <= y_end) &&
					(display.x >= x_start && display.x <= x_end)){			//this the case when iron man is touched
				cuddlesAnimation();
				increaseSnackLevel(0);
			}
		} else {
			//do nothing if touch returns values out of bounds
		}
	}
	
	extern volatile uint8_t execute_song;
	if((LPC_GPIO1->FIOPIN & (1<<25)) == 0){					/* Joytick sel pressed p1.28 */
			if(happiness <= 0 || hungry <= 0) {
				execute_song = 5;
				selection = 0;
				setDisplay();
				LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
				return;
			}
			
			switch(selection) {
				case 1:
					selection = 0;
					execute_song = 5;
					increaseSnackLevel(1);
					break;
				case 2:
					selection = 0;
					execute_song = 5;
					increaseMealLevel();
					break;
				default:
					break;
			}
	}
	
	ADC_start_conversion();
	updateVolume();
	
	//play song
	if(execute_song >= 1) {
		static int length_song = 0;
		
		static int currentNote = 0;
		static int ticks = 0;
		if(!isNotePlaying()) {
			++ticks;
			if(ticks == UPTICKS) {
				ticks = 0;
				
				/*
					execute_song
						1 : sound when the joystick is pressed on right or on left
						2 : sound when iron man goes to eat
						3 : sound when iron man dieds
						4 : sound for cuddles
						5 : sound when select is pressed
				*/
				
				switch(execute_song) {
					case 1:
						playNote(song_move_left_right[currentNote++]);
						length_song = sizeof(song_move_left_right) / sizeof(song_move_left_right[0]);
						break;
					case 2:
						playNote(song_iron_man_goes_to_eat[currentNote++]);
						length_song = sizeof(song_iron_man_goes_to_eat) / sizeof(song_iron_man_goes_to_eat[0]);
						break;
					case 3:
						playNote(song_iron_man_goes_away[currentNote++]);
						length_song = sizeof(song_iron_man_goes_away) / sizeof(song_iron_man_goes_away[0]);
						break;
					case 4:
						playNote(song_cuddles[currentNote++]);
						length_song = sizeof(song_cuddles) / sizeof(song_cuddles[0]);
						break;
					case 5:
						playNote(song_move_select[currentNote++]);
						length_song = sizeof(song_move_select) / sizeof(song_move_select[0]);
						break;
					default:
						playNote(song_move_left_right[currentNote++]);
						length_song = sizeof(song_move_left_right) / sizeof(song_move_left_right[0]);
						break;
					}
				
			}
		}
		
		if(currentNote >= length_song) {
			execute_song = 0;
			currentNote = 0;
			disable_timer(2);
			disable_timer(3);
		}
		
	}
	
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
  return;
}


/******************************************************************************
**                            End Of File
******************************************************************************/
