#include "file.h"
#include "ff.h"

static FATFS fatfs;

static FIL files[2];

DWORD get_fattime(void)
{
  return (28 << 25) | (2 << 21) | (1 << 16);
}



void mount()
{
	f_mount(0, &fatfs);
}

void open(int fileindex, char *filename, FileMode mode)
{
	BYTE flag;
	switch(mode) {
	case READ: flag = FA_READ;
	case WRITE: flag = FA_WRITE;
	}

	FRESULT res = f_open(&files[fileindex], filename, flag);
}

void read(int fileindex, void *buffer, uint32_t bytesToRead, uint32_t *bytesRead)
{
	f_read(&files[fileindex], buffer, bytesToRead, (UINT*)bytesRead);
}

void write(int fileindex, void *buffer, uint32_t bytesToWrite, uint32_t *bytesWritten)
{
	f_write(&files[fileindex], buffer, bytesToWrite, (UINT*)bytesWritten);
}

void close(int fileindex)
{
	f_close(&files[fileindex]);
}
