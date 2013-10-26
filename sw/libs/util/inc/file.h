#ifndef _FILE_H_
#define _FILE_H_

#include <stdint.h>

typedef enum {
	READ, WRITE
} FileMode;

void mount();
void open(int fileindex, char *filename, FileMode mode);
void read(int fileindex, void *buffer, uint16_t bytesToRead, uint16_t *bytesRead);
void write(int fileindex, void *buffer, uint16_t bytesToWrite, uint16_t *bytesWritten);
void close(int fileindex);

#endif /* _FILE_H_ */
