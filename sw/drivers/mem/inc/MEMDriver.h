#ifndef _MEMDRIVER_H_
#define _MEMDRIVER_H_

#include <stdint.h>
#include <stdbool.h>

void MEM_Init( void );
uint16_t* MEM_GetAudioInBuffer( bool primary );
int MEM_GetAudioInBufferSize( void );

uint16_t* MEM_GetAudioOutBuffer( bool primary );
int MEM_GetAudioOutBufferSize( void );


#endif /* _MEMDRIVER_H_ */
