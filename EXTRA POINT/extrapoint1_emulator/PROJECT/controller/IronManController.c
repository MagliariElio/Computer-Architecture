
#include <string.h>
#include <stdio.h>
#include "../GLCD/GLCD.h" 
#include "../GLCD/IronManPicture.h"
#include "../timer/timer.h"
#include "../RIT/RIT.h"

/*	COORDINATE MEAL AND SNACK	*/
Box_Coordinate box_meal;
Box_Coordinate box_snack;


/*		TIME								*/
extern int seconds;
extern int minutes;
extern int hours;
extern int16_t seconds_passed;

char age[20];


/*		IRON MAN IMAGE			*/
extern uint16_t image_mega_iron_man[][2];
Image mega_iron_man;


/*		HEART AND STAR IMAGE		*/
extern uint16_t width_battery;
extern uint16_t heigth_battery;

extern uint16_t elements_full_heart;
extern uint16_t image_full_heart[][2];

extern uint16_t elements_empty_heart;
extern uint16_t image_empty_heart[][2];

extern uint16_t elements_star;
extern uint16_t image_star[][2];

extern uint16_t elements_dead_star;
extern uint16_t image_dead_star[][2];


/*	HAPPINESS AND HUNGRY	*/
#define max_happiness 100
#define max_hungry 100
static uint16_t reduction_factor = max_happiness/4;
volatile int16_t happiness = max_happiness;			//happiness level
volatile int16_t hungry = max_hungry;						//satiety level
#define start_x_happiness MAX_X/4-40
#define start_x_hungry MAX_X/2+10


/*		BACKGROUND COLOR		*/
extern uint16_t background_color;


/*		EATING 							*/
extern uint16_t image_iron_man_eating[][2];
Image iron_man_eating;
uint16_t go_to_eat = 0;

extern uint16_t enable_update_image_eating;	//variable defined in the handler of timer

/******************************************************************************
** Function name:		updateAge
**
** Descriptions:		Update the Iron Man's age
**
** parameters:				None
** Returned value:		None
**
******************************************************************************/
void updateAge() {
	char second[3], minute[3], hour[3];
	(seconds<10) ? sprintf(second, "0%d", seconds) : sprintf(second, "%d", seconds);
	(minutes<10) ? sprintf(minute, "0%d", minutes) : sprintf(minute, "%d", minutes);
	hours = (hours >= 1000) ? 0 : hours;																									//if hours is greater than 4 characters
	(hours<10) ? sprintf(hour, "0%d", hours) : sprintf(hour, "%d", hours);
	
	sprintf(age, "%s %s:%s:%s", "Age:", hour, minute, second);
	GUI_Text(MAX_X/3-strlen(age), 0, (uint8_t *) age, text_color, top_background_color, 1);
	return;
}


/******************************************************************************
** Function name:		updateImage
**
** Descriptions:		Update the Iron Man's image
**
** parameters:			Coordinates of image in the display
** Returned value:	None
**
******************************************************************************/
void updateImage(uint16_t refresh, uint16_t change_iron_man) {
	uint16_t x = MAX_X/2 - (width_mega_iron_man/2);
	uint16_t y = box_meal.y_0 - heigth_mega_iron_man;
	
	Box_Coordinate coordinate;
	coordinate.x_0 = x;	coordinate.x_1 = x+heigth_mega_iron_man;
	coordinate.y_0 = y;	coordinate.y_1 = y+width_mega_iron_man;
	
	if(change_iron_man == 1) {		//only if the display must be updated it can clean it
		LCD_ClearFaster(&coordinate, background_color);
	}
	
	drawImage(x, y, &mega_iron_man, image_mega_iron_man, background_color, refresh, 0);
	
	return;
}

/******************************************************************************
** Function name:		updateBatteryLevelGraphically
**
** Descriptions:		Update the happiness and hungry level of Iron Man
**									in the display
**
** parameters:			None
** Returned value:	None
**
******************************************************************************/
void updateBatteryLevelGraphically() {
	if(happiness < 0 || hungry < 0) return;
	
	uint16_t distance = 2;
	
	uint16_t times_star = happiness/reduction_factor;
	uint16_t times_heart = hungry/reduction_factor;
	
	Image image_battery;
	image_battery.width = width_battery;
	image_battery.heigth = heigth_battery;
	
	image_battery.elements = elements_star;
	//this will paint #times the star in the display
	for(int16_t i=0; i<times_star; i++) {
		drawImage(start_x_happiness+(i*(width_battery+distance)), 40, &image_battery, image_star, top_background_color, 2, 0);
	}
	
	image_battery.elements = elements_dead_star;
	//this will paint 100/4 - #times_star the 'dead star' in the display
	for(int16_t i=times_star; i<max_hungry/reduction_factor; i++) {
		drawImage(start_x_happiness+(i*(width_battery+distance)), 40, &image_battery, image_dead_star, top_background_color, 2, 0);
	}
	
	image_battery.elements = elements_full_heart;
	//this will paint #times the 'full heart' in the display
	for(int16_t i=0; i<times_heart; i++) {
		drawImage(start_x_hungry+(i*(width_battery+distance)), 40, &image_battery, image_full_heart, top_background_color, 2, 0);
	}
	
	image_battery.elements = elements_empty_heart;
	//this will paint 100/4 - #times_heart the 'empty heart' in the display
	for(int16_t i=times_heart; i<max_happiness/reduction_factor; i++) {
		drawImage(start_x_hungry+(i*(width_battery+distance)), 40, &image_battery, image_empty_heart, top_background_color, 2, 0);
	}
	
	return;
}

/******************************************************************************
** Function name:		ironManExit
**
** Descriptions:		This implements the behaviour of Iron Man when it will have
**									value equal or less to 0 of hungry or happiness
**
** parameters:			None
** Returned value:	None
**
******************************************************************************/
void ironManRunAway() {
	uint16_t distance_from_parent_left = 40;
	uint16_t distance_from_parent_top = 5;
	char *reset = "Reset";
	char *gameOver = "GAME OVER";
	
	Box_Coordinate box;
	box.x_0 = box_meal.x_0;	box.x_1 = box_snack.x_1;
	box.y_0 = box_meal.y_0+1;	box.y_1 = MAX_Y;
	
	LCD_ClearFaster(&box, background_color);
	GUI_Text(MAX_X/2-(strlen(reset)+distance_from_parent_left), box_meal.y_0+distance_from_parent_top, (uint8_t *) reset, Red, background_color, 2);
	
	uint16_t x = MAX_X/2 - (width_mega_iron_man/2);
	uint16_t y = box_meal.y_0 - heigth_mega_iron_man;
	
	Box_Coordinate coordinate;
	coordinate.x_0 = x;	coordinate.x_1 = x+width_mega_iron_man;
	coordinate.y_0 = y;	coordinate.y_1 = y+heigth_mega_iron_man;
	
	LCD_ClearFaster(&coordinate, background_color);
	drawIronManFlying(x, y, coordinate, &mega_iron_man, image_mega_iron_man);		//draw the iron man when he goes out
	
	//this will draw 'GAME OVER' on the display
	x = MAX_X/2 - strlen(gameOver)*8;
	y = MAX_Y/2;
	GUI_Text(x, y, (uint8_t *) gameOver, Black, background_color, 2);
	
	disable_timer(0);		//stop the timer
	reset_timer(0);			//and reset
	disable_timer(1);		//stop the timer
	reset_timer(1);			//and reset
	return;
}

/******************************************************************************
** Function name:		increaseMealLevel
**
** Descriptions:		Increase the hungry level of Iron Man
**
** parameters:			None
** Returned value:	None
**
******************************************************************************/
void increaseMealLevel() {
	if(hungry < max_hungry) {
		disable_RIT();
		
		hungry += reduction_factor;
		updateBatteryLevelGraphically();
		
		go_to_eat = 1;
	}
	
	return;
}

/******************************************************************************
** Function name:		increaseSnackLevel
**
** Descriptions:		Increase the happiness level of Iron Man
**
** parameters:			None
** Returned value:	None
**
******************************************************************************/
void increaseSnackLevel() {
	if(happiness < max_happiness) {
		disable_RIT();
		
		happiness += reduction_factor;
		updateBatteryLevelGraphically();
		
		go_to_eat = 2;
	}
	
	return;
}

/******************************************************************************
** Function name:		decreaseBatteryLevel
**
** Descriptions:		Decrease the happiness and hungry level of Iron Man
**
** parameters:			None
** Returned value:	None
**
******************************************************************************/
void decreaseBatteryLevel() {
	if(happiness <= 0 || hungry <= 0) {
		ironManRunAway();
		return;
	}
	
	happiness -= reduction_factor;
	hungry -= reduction_factor;
	updateBatteryLevelGraphically();
	
	if(happiness <= 0 || hungry <= 0) {
		ironManRunAway();
	}
	
	return;
}

/******************************************************************************
** Function name:		writeMealAndSnack
**
** Descriptions:		This will write on the bottom of display Meal and Snack
**									under particolar coordinate
**
** parameters:			selection_text: it indicates which text has been selected
** Returned value:	None
**
******************************************************************************/
void writeMealAndSnack(uint16_t selection_text) {
	int16_t distance_from_parent_left = 20;
	int16_t distance_from_parent_top = 5;
	
	char *meal = "Meal";
	char *snack = "Snack";
	
	uint16_t color_meal = text_color;
	uint16_t color_snack = text_color;
	
	switch(selection_text) {
		case(1):
			color_snack = Red;	
			break;
		case(2):
			color_meal = Red;
			break;
	}
	
	GUI_Text(box_meal.x_0 + distance_from_parent_left+5, box_meal.y_0+distance_from_parent_top, (uint8_t *) meal, color_meal, background_color, 2);
	GUI_Text(box_snack.x_0 + distance_from_parent_left, box_snack.y_0+distance_from_parent_top, (uint8_t *) snack, color_snack, background_color, 2);
	
	return;
}
/******************************************************************************
** Function name:		selectionRightJoystick
**
** Descriptions:		It implements the behaviour of right joystick 
**									when it is pressed
**
** parameters:			None
** Returned value:	None
**
******************************************************************************/
void selectionRightJoystick() {
	writeMealAndSnack(1);
	return;
}

/******************************************************************************
** Function name:		selectionLeftJoystick
**
** Descriptions:		It implements the behaviour of right joystick 
**									when it is pressed
**
** parameters:			None
** Returned value:	None
**
******************************************************************************/
void selectionLeftJoystick() {
	writeMealAndSnack(2);
	return;
}

/******************************************************************************
** Function name:		initStruct
**
** Descriptions:		Set all structures needed
**
** parameters:				None
** Returned value:		None
**
******************************************************************************/
void initStruct() {
	extern uint16_t elements_mega_iron_man;
	extern uint16_t width_mega_iron_man;
	extern uint16_t heigth_mega_iron_man;
	
	extern uint16_t elements_iron_man_eating;
	extern uint16_t width_iron_man_eating;
	extern uint16_t heigth_iron_man_eating;
	
	mega_iron_man.elements = elements_mega_iron_man;
	mega_iron_man.width = width_mega_iron_man;
	mega_iron_man.heigth = heigth_mega_iron_man;
	
	iron_man_eating.elements = elements_iron_man_eating;
	iron_man_eating.width = width_iron_man_eating;
	iron_man_eating.heigth = heigth_iron_man_eating;
	
	return;
}

/******************************************************************************
** Function name:		setDisplay
**
** Descriptions:		Set all parameters of display
**
** parameters:				None
** Returned value:		None
**
******************************************************************************/
void setDisplay() {
	LCD_Clear(background_color, 0, 0, MAX_X, MAX_Y);
	
	initStruct();
	
	//parameters for reset
	happiness = max_happiness;			//happiness level
	hungry = max_hungry;						//satiety level
	seconds = 0;
	minutes = 0;
	hours = 0;
	go_to_eat = 0;
	seconds_passed = seconds_passed_last_level;
	enable_update_image_eating = 0;
	
	//top of display
	char *happiness_text = "Happiness";
	char *satiety_text = "Satiety";
	
	updateBackgroud(top_background_color, 0, 0, MAX_X, 80);
	updateAge();
	
	GUI_Text(start_x_happiness, 20, (uint8_t *) happiness_text, text_color, top_background_color, 1);
	GUI_Text(start_x_hungry, 20, (uint8_t *) satiety_text, text_color, top_background_color, 1);
	
	updateBatteryLevelGraphically();
	
	//bottom of display
	box_meal.x_0 = 0;
	box_meal.y_0 = MAX_Y-40;
	box_meal.x_1 = MAX_X/2;
	box_meal.y_1 = MAX_Y;
	
	box_snack.x_0 = MAX_X/2;
	box_snack.y_0 = MAX_Y-40;
	box_snack.x_1 = MAX_X;
	box_snack.y_1 = MAX_Y;
	
	LCD_DrawLine(box_meal.x_0, box_meal.y_0, MAX_X,					box_meal.y_0, 	Black);
	LCD_DrawLine(box_meal.x_1, box_meal.y_0, box_meal.x_1, 	MAX_Y, 					Black);
	
	writeMealAndSnack(text_color);
	
	updateImage(2, 0);
	
	//enable the timer for reset
	enable_timer(0);
	enable_timer(1);
	return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/
