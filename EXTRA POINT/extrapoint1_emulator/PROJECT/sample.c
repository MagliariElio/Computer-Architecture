/****************************************Copyright (c)****************************************************
**                                      
**                                 http://www.powermcu.com
**
**--------------File Info---------------------------------------------------------------------------------
** File name:               main.c
** Descriptions:            The GLCD application function
**
**--------------------------------------------------------------------------------------------------------
** Created by:              AVRman
** Created date:            2010-11-7
** Version:                 v1.0
** Descriptions:            The original version
**
**--------------------------------------------------------------------------------------------------------
** Modified by:             Paolo Bernardi
** Modified date:           03/01/2020
** Version:                 v2.0
** Descriptions:            basic program for LCD and Touch Panel teaching
**
*********************************************************************************************************/

/* Includes ------------------------------------------------------------------*/
#include "LPC17xx.h"
#include "GLCD/GLCD.h" 
#include "TouchPanel/TouchPanel.h"
#include "timer/timer.h"
#include "joystick/joystick.h"
#include "RIT/RIT.h"
#include "Controller/IronManController.h"

#define SIMULATOR 1

#ifdef SIMULATOR
extern uint8_t ScaleFlag; // <- ScaleFlag needs to visible in order for the emulator to find the symbol (can be placed also inside system_LPC17xx.h but since it is RO, it needs more work)
#endif

	
int main(void) {
	SystemInit();  													/* System Initialization (i.e., PLL)  */
	
  LCD_Initialization();
	//TP_Init();
	//TouchPanel_Calibrate();
	
	init_RIT(0x004C4B40);										/* 50ms * 100MHz = 0x004C4B40 	*/
	enable_RIT();														/* RIT enabled								*/
	
	init_timer(0, 0x17D7840); 						   /* 1s * 25MHz = 0x17D7840  */
	init_timer(1, 0x1312D0); 						   	 /* 50ms * 25MHz = 0x1312D0 */
	
	setDisplay();
	
	joystick_init();												/* Joystick Initialization            */
	
	LPC_SC->PCON |= 0x1;										/* power-down	mode										*/
	LPC_SC->PCON &= ~(0x2);
	
  while (1) {
		__ASM("wfi");
  }
}


/*********************************************************************************************************
      END FILE
*********************************************************************************************************/
