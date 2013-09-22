#include "em_adc_spy.h"

ADC_TypeDef ADC0;
ADC_Init_TypeDef ADC_INIT_DEFAULT;
ADC_InitSingle_TypeDef ADC_INITSINGLE_DEFAULT;

SPY2_V(ADC_Init, ADC_TypeDef, adc, const ADC_Init_TypeDef*, init)
SPY2_V(ADC_InitSingle, ADC_TypeDef, adc, const ADC_InitSingle_TypeDef*, init)

SPY2(uint8_t, ADC_PrescaleCalc, uint32_t, adcFreq, uint32_t, hfperFreq)
SPY1(uint8_t, ADC_TimebaseCalc, uint32_t, hfperFreq)
