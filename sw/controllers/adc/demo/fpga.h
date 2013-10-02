#ifndef _FPGA_H_
#define _FPGA_H_

#include <stdint.h>
#include <stdbool.h>

#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */
#define EXT_SRAM_BASE_ADDRESS ((volatile uint16_t*) 0x88000000)

extern uint16_t *preampAudioInBuffer1;
extern uint16_t *preampAudioInBuffer2;
extern uint32_t *preampAudioOutBuffer1;
extern uint32_t *preampAudioOutBuffer2;

void FPGA_Init( void );

#endif /* _FPGA_H_ */

