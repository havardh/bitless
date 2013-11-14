#include "bl_buttons.h"
#include "bl_leds.h"

#include "MainController.h"

//#include "Wavplayer.h"
//#include "FPGAProgrammer.h"
//#include "LiveFilter.h"
//#include "StoredFilter.h"

void programFPGA(uint8_t pin);
void startADCtoDAC(uint8_t pin);
void startSDtoSD(uint8_t pin);
void startWAVPlayer(uint8_t pin);

void callback(uint8_t pin);

void MainController_init(void) 
{
	uint8_t btns[5] = { BTN0, BTN1, BTN2, BTN3, BTN4 };
	GPIOINT_IrqCallbackPtr_t ptrs[5] = { programFPGA, startADCtoDAC, startSDtoSD, startWAVPlayer, callback };
	Buttons_RegisterCallbacks( btns, ptrs, 5 );
}

void MainController_run(void) 
{

	Board_t type = BITLESS;
	Buttons_Init(type);
	Leds_Init();

	while(1) {
		EMU_EnterEM3(true);
	}

}

void programFPGA(uint8_t pin) 
{
	Leds_SetLeds(0x1);
}

void startADCtoDAC(uint8_t pin) 
{
	Leds_SetLeds(0x2);	
}

void startSDtoSD(uint8_t pin)
{
	Leds_SetLeds(0x4);
}

void startWAVPlayer(uint8_t pin)
{
	Leds_SetLeds(0x8);
}

void callback(uint8_t pin)
{
	Leds_SetLeds(0x10);
}
