#include "button.h"
#include "lpc17xx.h"

#include "../led/led.h"

extern int translate_morse(char* vett_input, int vett_input_lenght, char* vett_output, 
		int vett_output_lenght, char change_symbol, char space, char sentence_end);

char* vett_input = "00002111201002013112001210210021113011112001114";
int vett_input_lenght = 47;
char vett_output[100/6+3];
int vett_output_lenght;
char change_symbol = '2';
char space = '3';
char sentence_end = '4';
int RES = 0;

//INT0
void EINT0_IRQHandler (void) {
	LED_Out(0);
	
	BUTTON_enabled(1);							//KEY1 button is enabled
	BUTTON_disabled(2);							//KEY2 button is disabled
	
	for(int i=0; i<vett_output_lenght; i++) {
		vett_output[i] = '0';
	}
	
  LPC_SC->EXTINT &= (1 << 0);     /* clear pending interrupt         */
}

//KEY1
void EINT1_IRQHandler (void) {
  LED_Out(0);
	
	int read = 0;
	for(int i=0; i<vett_input_lenght; i++) {
		if(vett_input[i] == '2' || vett_input[i] == '3' || vett_input[i] == '4') {
				read++;
				LED_Out(read);
		}
	}
	
	LED_Out(-1);										//all leds are switched on
	BUTTON_enabled(2);							//KEY2 button is enabled
	
	LPC_SC->EXTINT &= (1 << 1);     /* clear pending interrupt         */
}

//KEY2
void EINT2_IRQHandler (void) {
	BUTTON_disabled(0);							//INT0 and KEY1 buttons are disabled
	
	RES = translate_morse(vett_input, vett_input_lenght, vett_output, vett_output_lenght, change_symbol, space, sentence_end);
	
	LED_Out(RES);										//all leds that represent RES value are switched on
	BUTTON_enabled(0);							//INT0 and KEY1 buttons are enabled
	
  LPC_SC->EXTINT &= (1 << 2);     /* clear pending interrupt         */    
}


