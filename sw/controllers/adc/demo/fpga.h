#ifndef _FPGA_H_
#define _FPGA_H_

#include <stdint.h>
#include <stdbool.h>
#include "FPGAConfig.h"

void FPGA_Init( FPGAConfig *config );
uint16_t* FPGA_GetAudioInBuffer( bool primary );
uint16_t* FPGA_GetPrimaryAudioInBuffer( void );
uint16_t* FPGA_GetSecondaryAudioInBuffer( void );
int FPGA_GetAudioInBufferSize( void );

uint16_t* FPGA_GetAudioOutBuffer( bool primary );
uint32_t* FPGA_GetPrimaryAudioOutBuffer( void );
uint32_t* FPGA_GetSecondaryAudioOutBuffer( void );
int FPGA_GetAudioOutBufferSize( void );

void FPGA_SetBufferPrimary( bool primary );


#endif /* _FPGA_H_ */

