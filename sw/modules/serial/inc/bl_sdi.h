#ifndef _BL_SDI_H_
#define _BL_SDI_H_

#define CMD_LEN 4
#define MEM_SIZE 16

#include <stdint.h>
#include "bl_uart.h"

void SDI_Init(void);

void SDI_Start(void);

#endif /* _BL_SDI_H_ */
