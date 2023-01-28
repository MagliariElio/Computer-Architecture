

#include "GLCD/IronManPicture.h"
#include "GLCD/GLCD.h"

extern uint16_t elements_iron_man_eating;
extern uint16_t width_iron_man_eating;
extern uint16_t heigth_iron_man_eating;
extern uint16_t image_iron_man_eating[][2];


extern Image iron_man_eating;


void initStruct() {

	iron_man_eating.elements = elements_iron_man_eating;
	iron_man_eating.width = width_iron_man_eating;
	iron_man_eating.heigth = heigth_iron_man_eating;

	return;
}

