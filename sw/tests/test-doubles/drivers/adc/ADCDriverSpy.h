#ifndef _ADCDRIVERSPY_H_
#define _ADCDRIVERSPY_H_

#include "spy.h"
#include "ADCController.h"
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

H_SPY1_V(ADCDriverSpy_Init, ADCConfig*, config)

//void ADCDriverSpy_Init(ADCConfig*);
uint8_t ADCDriverSpy_GetChannel();
uint8_t ADCDriverSpy_GetResolution();
uint16_t ADCDriverSpy_GetRate();

#endif /* _ADCDRIVERSPY_H_ */
