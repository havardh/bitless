#include "em_chip.h"
#include "bl_buttons.h"
#include "bl_leds.h"
#include <stdint.h>

#include "MainController.h"

#include "Wavplayer.h"
#include "FPGAProgrammer.h"
#include "LiveFilter.h"
#include "StoredFilter.h"

static bool pressed = false;

void programFPGA(void);
void startADCtoDAC(void);
void startSDtoSD(void);
void startWAVPlayer(void);

void callback(void);


void MainController_init(void) 
{
	CHIP_Init();

	Buttons_Init();
	Leds_Init();

	
	Buttons_SetCallback(BTN0, &programFPGA);
	Buttons_SetCallback(BTN1, &startADCtoDAC);
	Buttons_SetCallback(BTN2, &startSDtoSD);
	Buttons_SetCallback(BTN3, &startWAVPlayer);
	Buttons_SetCallback(BTN4, &callback );



}

void MainController_run(void) 
{

	while(1) {

		Buttons_Dispatch();

		EMU_EnterEM3(true);
	}

}

void programFPGA(void) 
{
	FPGAProgrammer_Start();
}

void startADCtoDAC(void) 
{
	LiveFilter_Start();
}

void startSDtoSD(void)
{
	StoredFilter_Start();
}

void startWAVPlayer(void)
{
	Wavplayer_Start();
}

void callback(void)
{
	Leds_SetLeds(0x10);
}
