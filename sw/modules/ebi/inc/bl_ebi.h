#ifndef _EBIDRIVER_H_
#define _EBIDRIVER_H_

#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "em_ebi.h"
#include "em_gpio.h"

#define BL_FPGA_BASE_ADDRESS        (uint16_t*)(0x80000000)
#define BL_SRAM_BASE_ADDRESS        (uint16_t*)(0x84000000)

void EBIDriver_Init(void); 
void EBIDriver_Disable(void);

#endif // _EBIDRIVER_H_
