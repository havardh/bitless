#include "CircularBuffer.h"

CircularBuffer CircularBuffer_New(uint16_t *buffer, size_t size, int parts ) 
{
	CircularBuffer cb = (CircularBuffer)malloc(sizeof(CircularBuffer_t));
	cb->buffer = buffer;
	cb->index = 0;
	cb->size = size;
	cb->parts = parts;
	return cb;
}

uint16_t *CircularBuffer_GetBuffer( CircularBuffer circularBuffer )
{
	int index = circularBuffer->index;
	int size = (int)circularBuffer->size;
	int parts = circularBuffer->parts;

	return circularBuffer->buffer + index * ( size / parts );
}

void CircularBuffer_MoveToNext( CircularBuffer circularBuffer )
{
	int index = circularBuffer->index;
	int parts = circularBuffer->parts;

	circularBuffer->index = ( index + 1 ) % parts;
}

uint16_t *CircularBuffer_GetNextBuffer( CircularBuffer circularBuffer )
{
	uint16_t *ptr = CircularBuffer_GetBuffer( circularBuffer );
	CircularBuffer_MoveToNext( circularBuffer );
	return ptr;
}
