#include "DACDriver.h"

static void init(const DACConfig *config);
static void initChannel(const DACConfig *config);

void DACDriver_Init(const DACConfig *config) 
{
	init(config);

	DAC0->COMBDATA = 0x0;

	initChannel(config);

}

static void init(const DACConfig *config)
{
	DAC_Init_TypeDef dacInit = DAC_INIT_DEFAULT;
	dacInit.reference = dacRefVDD;
	dacInit.prescale = DAC_PrescaleCalc(1000000, 0);
	DAC_Init(DAC0, &dacInit);
}

static void initChannel(const DACConfig *config)
{
	DAC_InitChannel_TypeDef dacChInit = DAC_INITCHANNEL_DEFAULT;
	dacChInit.enable = true;
	dacChInit.prsSel = dacPRSSELCh0;
	dacChInit.prsEnable = true;
	
	DAC_InitChannel(DAC0, &dacChInit, 0);
	DAC_InitChannel(DAC0, &dacChInit, 1);

	DAC_Enable(DAC0, 0, true);
	DAC_Enable(DAC0, 1, true);
}
