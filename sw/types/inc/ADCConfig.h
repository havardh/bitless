#ifndef _ADCCONFIG_H_
#define _ADCCONFIG_H_

#include <stdint.h>

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

#endif /* _ADCCONFIG_H_ */
