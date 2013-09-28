#ifndef SDFT_H
#define SDFT_H

#include "complex.h"
#include "circular_buffer.h"
#include <stdint.h>

void sdft(uint16_t new_sample, complex *freq, complex *coeffs);
uint16_t isdft(complex *freq, complex *coeffs);

#endif // SDFT_H
