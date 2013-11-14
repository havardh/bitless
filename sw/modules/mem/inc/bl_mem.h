#ifndef _MEMDRIVER_H_
#define _MEMDRIVER_H_

#include <stdint.h>
#include <stdbool.h>
#include "bl_mem.h"

typedef struct {

	int bufferSize;

} MEMConfig;

#define MEM_DEFAULT { 512 }

void MEM_Init( MEMConfig *config );
uint16_t* MEM_GetAudioInBuffer( bool primary );
int MEM_GetAudioInBufferSize( void );

uint16_t* MEM_GetAudioOutBuffer( bool primary );
int MEM_GetAudioOutBufferSize( void );
uint16_t* MEM_GetCurrentOutBuffer( void );

#endif /* _MEMDRIVER_H_ */
