#ifndef _MEMDRIVER_H_
#define _MEMDRIVER_H_

#include <stdint.h>
#include <stdbool.h>

void MEM_Init( void );
uint16_t* MEM_GetAudioInBuffer( bool primary );
uint16_t* MEM_GetPrimaryAudioInBuffer( void );
uint16_t* MEM_GetSecondaryAudioInBuffer( void );
int MEM_GetAudioInBufferSize( void );

uint16_t* MEM_GetAudioOutBuffer( bool primary );
uint16_t* MEM_GetPrimaryAudioOutBuffer( void );
uint16_t* MEM_GetSecondaryAudioOutBuffer( void );
int MEM_GetAudioOutBufferSize( void );

void MEM_SetBufferPrimary( bool primary );

#endif /* _MEMDRIVER_H_ */
