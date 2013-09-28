#ifndef _FPGA_H_
#define _FPGA_H_

#include <stdint.h>
#include <stdbool.h>

#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */

extern uint16_t preampAudioInBuffer1[BUFFER_SIZE * 2];
extern uint16_t preampAudioInBuffer2[BUFFER_SIZE * 2];
extern uint32_t preampAudioOutBuffer1[BUFFER_SIZE];
extern uint32_t preampAudioOutBuffer2[BUFFER_SIZE];

#endif /* _FPGA_H_ */

