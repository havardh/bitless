#ifndef _CIRCULARBUFFER_H_
#define _CIRCULARBUFFER_H_

#include <stdint.h>
#include <stdlib.h>

typedef struct {
	
	uint16_t *buffer;
	int index;
	size_t size;
	int parts;

} CircularBuffer_t;

typedef CircularBuffer_t* CircularBuffer;

CircularBuffer CircularBuffer_New(uint16_t *buffer, size_t size, int parts );
void CircularBuffer_Destroy( CircularBuffer circularBuffer );
uint16_t *CircularBuffer_GetBuffer( CircularBuffer circularBuffer );
void      CircularBuffer_MoveToNext( CircularBuffer circularBuffer );
uint16_t *CircularBuffer_GetNextBuffer( CircularBuffer circularBuffer );


#endif /* _CIRCULARBUFFER_H_ */
