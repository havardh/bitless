#include "sample_conversion.h"

void signedToUnsigned(int16_t *samples, size_t n) {

	for (int i=0; i<n; i++) {
		((uint16_t*)samples)[i] = ((int32_t)samples[i]) + 0x8000;
	}

}

void unsignedToSigned(int16_t *samples, size_t n) {

	for (int i=0; i<n; i++) {
		((int16_t*)samples)[i] = ((int32_t)samples[i]) - 0x8000;
	}

}

void downScale(uint16_t *samples, size_t n) {

	for (int i=0; i<n; i++) {
		samples[i] >>= 4;
	}

}
