#ifndef _SAMPLE_CONVERSION_H_
#define _SAMPLE_CONVERSION_H_

#include <stdlib.h>
#include <stdint.h>

#define MID_POINT 0x8000
#define BIT_SHIFT_LENGTH 8

void signedToUnsigned(int16_t *samples, size_t n);
void unsignedToSigned(uint16_t *samples, size_t n);

void downScale(uint16_t *samples, size_t n);
void upScale(uint16_t *samples, size_t n);

#endif /* _SAMPLE_CONVERSION_H_ */
