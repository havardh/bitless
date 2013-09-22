#include "ADCDriver.h"
#include "ADCController.h"

void init(ADCConfig *config);
void initSingle(ADCConfig *config);
void setResolution(ADC_InitSingle_TypeDef *init, uint8_t resolution);

static ADC_Init_TypeDef initADC;
static ADC_InitSingle_TypeDef singleInit;

void ADCDriver_Init(ADCConfig *config) 
{

	init(config);
	initSingle(config);	
}

void init(ADCConfig *config) 
{
	initADC = ADC_INIT_DEFAULT;

	initADC.timebase = ADC_TimebaseCalc(0);
	initADC.prescale = ADC_PrescaleCalc(config->rate, 0);

	ADC_Init(ADC0, &initADC);
}

void initSingle(ADCConfig *config)
{
	singleInit = ADC_INITSINGLE_DEFAULT;

	singleInit.reference = adcRef1V25;
	singleInit.input = adcSingleInpVDDDiv3;
	
	setResolution(&singleInit, config->resolution);

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
