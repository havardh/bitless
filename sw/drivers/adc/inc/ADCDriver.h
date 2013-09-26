#ifndef _ADCDRIVER_H_
#define _ADCDRIVER_H_

#ifdef DEVICE
#include "em_device.h"
#include "em_adc.h"
#endif // DEVICE
#include "ADCConfig.h"
#include "ADCController.h"

void ADCDriver_Init(ADCConfig *config);

#endif /* _ADCDRIVER_H_ */
