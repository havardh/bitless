#ifndef _DACDRIVER_H_
#define _DACDRIVER_H_

#include "em_device.h"
#include "em_dac.h"

#include "DACConfig.h"

void DACDriver_Init(const DACConfig *config);

#endif /* _DACDRIVER_H_ */
