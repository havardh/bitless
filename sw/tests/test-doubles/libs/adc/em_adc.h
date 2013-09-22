#ifndef _EM_ADC_H_
#define _EM_ADC_H_

#include "em_adc.h"

void ADCSpy_Init(ADC_TypeDef *adc, const ADC_Init_TypeDef *init);
void ADCSpy_InitSingle(ADC_TypeDef, const ADC_InitSingle_TypeDef *init);

#endif /* _EM_ADC_H_ */
