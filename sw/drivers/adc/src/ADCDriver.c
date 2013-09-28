#include "ADCDriver.h"


void init(const ADCConfig *config);
void initSingle(const ADCConfig *config);
void initScan();

void setResolution(ADC_InitSingle_TypeDef *init, uint8_t resolution);
void setInput(ADC_InitSingle_TypeDef *init, ADCChannel channel);

void ADCDriver_Init(const ADCConfig *config) 
{

		init(config);

		if (config->mode == SingleConversion) {
			initSingle(config);
		} else {
			initScan();
		}

}

void init(const ADCConfig *config) 
{
	ADC_Init_TypeDef initADC = ADC_INIT_DEFAULT;
	//if (!config->rate) printf("");

	initADC.warmUpMode = adcWarmupKeepADCWarm;
	initADC.timebase = ADC_TimebaseCalc(0);
	initADC.prescale = ADC_PrescaleCalc(4000000, 0);
	initADC.tailgate = true;

	ADC_Init(ADC0, &initADC);
}

void initSingle(const ADCConfig *config)
{
	ADC_InitSingle_TypeDef singleInit = ADC_INITSINGLE_DEFAULT;

	singleInit.reference = adcRef1V25;
	
	setResolution(&singleInit, config->resolution);
	setInput(&singleInit, config->channel);

	singleInit.acqTime = adcAcqTime32;

	ADC_InitSingle(ADC0, &singleInit);

}

void initScan()
{
	ADC_InitScan_TypeDef scanInit = ADC_INITSCAN_DEFAULT;

	scanInit.prsSel = adcPRSSELCh0;
	scanInit.prsEnable = true;
	scanInit.reference = adcRefVDD;
	scanInit.resolution = adcRes12Bit;
	scanInit.input = ADC_SCANCTRL_INPUTMASK_CH6 | ADC_SCANCTRL_INPUTMASK_CH7;

	ADC_InitScan( ADC0, &scanInit );
}

void setResolution(ADC_InitSingle_TypeDef *init, uint8_t resolution) 
{
	switch (resolution) {
	case 8: 
		init->resolution = adcRes8Bit;
	}
}

void setInput(ADC_InitSingle_TypeDef * init, ADCChannel channel)
{
	switch (channel) {
	case CH5:
		init->input = adcSingleInpCh5;
		break;
	case VDDDiv3:
		break;
	}
}
