#include "ADCDriver.h"

void init(ADCConfig *config);
void initSingle(ADCConfig *config);

void setResolution(ADC_InitSingle_TypeDef *init, uint8_t resolution);
void setInput(ADC_InitSingle_TypeDef *init, ADCChannel channel);

void ADCDriver_Init(ADCConfig *config) 
{
	init(config);
	initSingle(config);	
}

void init(ADCConfig *config) 
{
	ADC_Init_TypeDef initADC = ADC_INIT_DEFAULT;

	initADC.timebase = ADC_TimebaseCalc(0);
	initADC.prescale = ADC_PrescaleCalc(config->rate, 0);

	ADC_Init(ADC0, &initADC);
}

void initSingle(ADCConfig *config)
{
	ADC_InitSingle_TypeDef singleInit = ADC_INITSINGLE_DEFAULT;

	singleInit.reference = adcRef1V25;
	
	setResolution(&singleInit, config->resolution);
	setInput(&singleInit, config->channel);

	singleInit.acqTime = adcAcqTime32;

	ADC_InitSingle(ADC0, &singleInit);

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
