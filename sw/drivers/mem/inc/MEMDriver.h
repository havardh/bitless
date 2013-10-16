#ifndef _MEMDRIVER_H_
#define _MEMDRIVER_H_

#include <stdint.h>
#include <stdbool.h>

void MEM_Init( void );
uint16_t* MEM_GetAudioInBuffer( void );
int MEM_GetAudioInBufferSize( void );

uint16_t* MEM_GetAudioOutBuffer( void );
int MEM_GetAudioOutBufferSize( void );


#endif /* _MEMDRIVER_H_ */
