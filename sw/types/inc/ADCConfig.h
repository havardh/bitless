#ifndef _ADCCONFIG_H_
#define _ADCCONFIG_H_

#include <stdint.h>

typedef enum {
	ADCMode_SingleConvertion
} ADCModes;

typedef struct {
//	uint8_t channel;
	uint8_t resolution;
	uint16_t rate;
	uint8_t mode;
} ADCConfig;

#endif /* _ADCCONFIG_H_ */
