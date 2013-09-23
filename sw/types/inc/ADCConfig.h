#ifndef _ADCCONFIG_H_
#define _ADCCONFIG_H_

#include <stdint.h>

typedef enum {
	VDDDiv3,
  CH5
} ADCChannel;

typedef enum {
	SingleConvertion
} ADCModes;

typedef struct {
	ADCChannel channel;
	uint8_t resolution;
	uint16_t rate;
	ADCModes mode;
} ADCConfig;

#endif /* _ADCCONFIG_H_ */
