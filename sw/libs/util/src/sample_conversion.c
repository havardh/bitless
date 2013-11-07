#include "sample_conversion.h"

void signedToUnsigned(int16_t *samples, size_t n) {

	for (size_t i=0; i<n; i++) {
		((uint16_t*)samples)[i] = (uint16_t) ((int32_t)samples[i] + MID_POINT);
	}

}

void unsignedToSigned(uint16_t *samples, size_t n) {

	for (size_t i=0; i<n; i++) {
		((int16_t*)samples)[i] = (int16_t)((int32_t)samples[i] - MID_POINT);
	}

}

void downScale(uint16_t *samples, size_t n) {

	for (size_t i=0; i<n; i++) {
		samples[i] >>= BIT_SHIFT_LENGTH;
	}

}

void upScale(uint16_t *samples, size_t n) {

	for (size_t i=0; i<n; i++) {
		samples[i] <<= BIT_SHIFT_LENGTH;
	}

}
