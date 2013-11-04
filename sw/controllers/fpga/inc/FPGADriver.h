#ifndef _FPGADRIVER_H_
#define _FPGADRIVER_H_

#include <stdint.h>
#include <stdlib.h>
#include "FPGAConfig.h"
#include "CircularBuffer.h"

void FPGADriver_Init( FPGAConfig *config );

uint16_t* FPGADriver_GetInBuffer(int pipeline);
uint16_t* FPGADriver_GetOutBuffer(int pipeline);

// This makes the circular buffers jump forward
void FPGADriver_NotifyDMACycleComplete( void );

// Simulates the fpga
void FPGADriver_CopyData( void );

#endif /* _FPGADRIVER_H_ */
