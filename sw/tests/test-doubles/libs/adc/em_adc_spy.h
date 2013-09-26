#ifndef _EM_ADC_H_
#define _EM_ADC_H_

#include <stdint.h>
#include "spy.h"

typedef struct {
  uint32_t CTRL;
} ADC_TypeDef;

extern ADC_TypeDef ADC0;

typedef enum {
	adcWarmupKeepADCWarm
} ADC_Warmup_TypeDef;

typedef struct {
  ADC_Warmup_TypeDef warmUpMode;
  uint8_t timebase;
  uint8_t prescale;
  bool tailgate;
} ADC_Init_TypeDef;

#define ADC_INIT_DEFAULT { adcWarmupKeepADCWarm, 1, 1, false }

typedef enum
{
  adcRes8Bit,
	adcRes12Bit
} ADC_Res_TypeDef;

typedef enum
{
  adcRef1V25,
	adcRefVDD
} ADC_Ref_TypeDef;

typedef enum
{
  adcAcqTime32
} ADC_AcqTime_TypeDef;

typedef enum
{
	adcSingleInpCh5,
  adcSingleInpVDDDiv3
} ADC_SingleInput_TypeDef;

typedef struct {
  ADC_AcqTime_TypeDef acqTime;
  ADC_Ref_TypeDef reference;
  ADC_Res_TypeDef resolution;
  ADC_SingleInput_TypeDef input;
} ADC_InitSingle_TypeDef;

typedef enum {
	adcPRSSELCh0
} ADC_PRSSEL_TypeDef;

typedef struct {
	ADC_PRSSEL_TypeDef prsSel;
	bool prsEnable;
	ADC_Ref_TypeDef reference;
	ADC_Res_TypeDef resolution;
	uint32_t input;
} ADC_InitScan_TypeDef;

#define ADC_INITSINGLE_DEFAULT { adcAcqTime32, adcRef1V25, adcRes8Bit, adcSingleInpVDDDiv3 }

#define ADC_INITSCAN_DEFAULT { adcPRSSELCh0, true, adcRefVDD, adcRes8Bit, 0 } 

H_SPY2_V(ADC_Init, ADC_TypeDef, adc, const ADC_Init_TypeDef*, init)
H_SPY2_V(ADC_InitSingle, ADC_TypeDef, adc, const ADC_InitSingle_TypeDef*, init)
H_SPY2_V(ADC_InitScan, ADC_TypeDef, adc, const ADC_InitScan_TypeDef*, init)

H_SPY2(uint8_t, ADC_PrescaleCalc, uint32_t, adcFreq, uint32_t, hfperFreq)
H_SPY1(uint8_t, ADC_TimebaseCalc, uint32_t, hfperFreq)

#endif /* _EM_ADC_H_ */
