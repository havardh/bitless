#include "file.h"
#include <stdio.h>

static FILE *files[2];

void mount()
{
	// Noop
}

void open(int fileindex, char *filename, FileMode mode)
{
	if (mode == READ) {
		files[fileindex] = fopen(filename, "r");
	} else {
		files[fileindex] = fopen(filename, "w");
	}


}

void read(int fileindex, void *buffer, uint16_t bytesToRead, uint16_t *bytesRead)
{
	*bytesRead = fread(buffer, 1, bytesToRead, files[fileindex]);
}

void write(int fileindex, void *buffer, uint16_t bytesToWrite, uint16_t *bytesWritten)
{
	*bytesWritten = fwrite(buffer, 1, bytesToWrite, files[fileindex]);
}

void seek(int fileindex, int position) 
{
	fseek(files[fileindex], position, SEEK_SET);
}

void close(int fileindex)
{
	fclose(files[fileindex]);
}
