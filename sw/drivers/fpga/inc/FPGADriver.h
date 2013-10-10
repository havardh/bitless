#ifndef _FPGADRIVER_H_
#define _FPGADRIVER_H_

#include <stdint.h>
#include <stdlib.h>
#include "FPGAConfig.h"

void FPGADriver_Init( FPGAConfig *config );

uint16_t* FPGADriver_GetInBuffer(int pipeline);
uint16_t* FPGADriver_GetOutBuffer(int pipeline);

// Simulates the fpga
void FPGADriver_CopyData( void );

#endif /* _FPGADRIVER_H_ */
