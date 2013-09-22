#ifndef _EM_ADC_H_
#define _EM_ADC_H_

#include <stdint.h>
#include "spy.h"

typedef struct {
  uint32_t CTRL;
} ADC_TypeDef;

extern ADC_TypeDef ADC0;

typedef struct {
  uint8_t timebase;
  uint8_t prescale;
} ADC_Init_TypeDef;

extern ADC_Init_TypeDef ADC_INIT_DEFAULT;

typedef enum
{
  adcRes8Bit
} ADC_Res_TypeDef;

typedef enum
{
  adcRef1V25
} ADC_Ref_TypeDef;

typedef enum
{
  adcAcqTime32
} ADC_AcqTime_TypeDef;

typedef enum
{
  adcSingleInpVDDDiv3
} ADC_SingleInput_TypeDef;

typedef struct {
  ADC_AcqTime_TypeDef acqTime;
  ADC_Ref_TypeDef reference;
  ADC_Res_TypeDef resolution;
  ADC_SingleInput_TypeDef input;
} ADC_InitSingle_TypeDef;

extern ADC_InitSingle_TypeDef ADC_INITSINGLE_DEFAULT;

H_SPY2_V(ADC_Init, ADC_TypeDef, adc, const ADC_Init_TypeDef*, init)
H_SPY2_V(ADC_InitSingle, ADC_TypeDef, adc, const ADC_InitSingle_TypeDef*, init)

H_SPY2(uint8_t, ADC_PrescaleCalc, uint32_t, adcFreq, uint32_t, hfperFreq)
H_SPY1(uint8_t, ADC_TimebaseCalc, uint32_t, hfperFreq)

#endif /* _EM_ADC_H_ */
