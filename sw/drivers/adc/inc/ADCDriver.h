#ifndef _ADCDRIVER_H_
#define _ADCDRIVER_H_

//#ifdef DEVICE
#include "em_device.h"
#include "em_adc.h"
//-#endif // DEVICE
#include "ADCConfig.h"

void ADCDriver_Init(const ADCConfig *config);

#endif /* _ADCDRIVER_H_ */
