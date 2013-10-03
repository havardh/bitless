#include "circular_buffer.h"

uint16_t index = 0;
uint16_t sample_cache[N] = { 0 };

void insert_sample(uint16_t sample) 
{
  sample_cache[index] = sample;
  index = (index+1) % N;
}

uint16_t get_old_sample(void) {
  return sample_cache[index];
}
