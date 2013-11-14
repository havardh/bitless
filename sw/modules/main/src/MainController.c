#include "bl_buttons.h"
#include "bl_leds.h"

#include "MainController.h"

#include "Wavplayer.h"
#include "FPGAProgrammer.h"
#include "LiveFilter.h"
#include "StoredFilter.h"

void programFPGA(uint8_t pin);
void startADCtoDAC(uint8_t pin);
void startSDtoSD(uint8_t pin);
void startWAVPlayer(uint8_t pin);

void callback(uint8_t pin);

void MainController_init(void) 
{
	Board_t type = BITLESS;
	Buttons_Init(type);
	Leds_Init();

	uint8_t btns[5] = { BTN0, BTN1, BTN2, BTN3, BTN4 };
	GPIOINT_IrqCallbackPtr_t ptrs[5] = { 
		programFPGA, 
		startADCtoDAC, 
		startSDtoSD, 
		startWAVPlayer, 
		callback 
	};
	Buttons_RegisterCallbacks( btns, ptrs, 5 );
}

void MainController_run(void) 
{


	while(1) {
		EMU_EnterEM3(true);
	}

}

void programFPGA(uint8_t pin) 
{
	FPGAProgrammer_Start();
}

void startADCtoDAC(uint8_t pin) 
{
	LiveFilter_Start();
}

void startSDtoSD(uint8_t pin)
{
	StoredFilter_Start();
}

void startWAVPlayer(uint8_t pin)
{
	Wavplayer_Start();
}

void callback(uint8_t pin)
{
	Leds_SetLeds(0x10);
}
