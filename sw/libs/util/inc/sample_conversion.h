#ifndef _SAMPLE_CONVERSION_H_
#define _SAMPLE_CONVERSION_H_

#include <stdlib.h>
#include <stdint.h>

void signedToUnsigned(int16_t *samples, size_t n);
void unsignedToSigned(int16_t *samples, size_t n);

void downScale(uint16_t *samples, size_t n);

#endif /* _SAMPLE_CONVERSION_H_ */
