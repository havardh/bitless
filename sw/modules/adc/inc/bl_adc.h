#ifndef _ADC_H_
#define _ADC_H_

#include <stdint.h>
//#ifdef DEVICE
#include "em_device.h"
#include "em_adc.h"
//-#endif // DEVICE

// ADC_SCANCTRL_INPUTMASK_CH7
typedef enum {
  /*CH0 = 1,
  CH1 = 2,
  CH2 = 4,
  CH3 = 8,
  CH4 = 16,*/
  CH5 = 32,/*
  CH6 = 64,
  CH7 = 128,*/
	VDDDiv3 = 256

} ADCChannel;

typedef enum {
	SingleConversion,
	ScanConversion

} ADCModes;

typedef struct {
	ADCChannel channel;
	uint8_t resolution;
	uint16_t rate;
	ADCModes mode;
} ADCConfig;

void ADCDriver_Init(const ADCConfig *config);

#endif /* _ADCDRIVER_H_ */
