#ifndef _FPGADEBUG_H_
#define _FPGADEBUG_H_

#include <stdint.h>
#include <stdlib.h>
#include "FPGAConfig.h"
#include "FPGAController.h"

void FPGADebug_GetCoreInputBuffer(FPGA_Core *core, uint16_t *inputBuffer);
void FPGADebug_SetCoreInputBuffer(FPGA_Core *core, uint16_t *inputBuffer);
void FPGADebug_GetCoreOutputBuffer(FPGA_Core *core, uint16_t *outputBuffer);
void FPGADebug_SetCoreOutputBuffer(FPGA_Core *core, uint16_t *outputBuffer);

#endif /* _FPGADEBUG_H_ */
