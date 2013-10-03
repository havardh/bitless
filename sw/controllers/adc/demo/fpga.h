#ifndef _FPGA_H_
#define _FPGA_H_

#include <stdint.h>
#include <stdbool.h>

#define BUFFER_SIZE     64     /* 64/44100 = appr 1.5 msec delay */

// Start address of SRAM on DK3750 
#define EXT_SRAM_BASE_ADDRESS ((volatile uint16_t*) 0x88000000)


void FPGA_Init( void );

uint16_t* FPGA_GetPrimaryAudioInBuffer( void );
uint16_t* FPGA_GetSecondaryAudioInBuffer( void );
int FPGA_GetAudioInBufferSize( void );

uint32_t* FPGA_GetPrimaryAudioOutBuffer( void );
uint32_t* FPGA_GetSecondaryAudioOutBuffer( void );
int FPGA_GetAudioOutBufferSize( void );

void FPGA_SetBufferPrimary( bool primary );


#endif /* _FPGA_H_ */

