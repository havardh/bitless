#ifndef _SDDRIVER_H_
#define _SDDRIVER_H_

#include "bsp.h"
#include "wav.h"
#include "microsd.h"
#include "SDConfig.h"
#include <stdlib.h>

void SDDriver_Init( SDConfig *config );

bool SDDriver_Read();
void SDDriver_Write();
void SDDriver_Finalize();

void SDDriver_PrintWAVS(void);

#endif /* _SDDRIVER_H_ */
