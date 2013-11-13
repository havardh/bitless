#include "bl_dac.h"

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
}