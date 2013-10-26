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
	FRESULT res = f_mount(0, &fatfs);
}

void open(int fileindex, char *filename, FileMode mode)
{
	BYTE flag;
	switch(mode) {
	case READ: flag = FA_READ; break;
	case WRITE: flag = FA_WRITE; break;
	}

	FRESULT res = f_open(&files[fileindex], filename, flag);
}

void read(int fileindex, void *buffer, uint16_t bytesToRead, uint16_t *bytesRead)
{
	FRESULT res = f_read(&files[fileindex], buffer, bytesToRead, (UINT*)bytesRead);
}

void write(int fileindex, void *buffer, uint16_t bytesToWrite, uint16_t *bytesWritten)
{
	FRESULT res = f_write(&files[fileindex], buffer, bytesToWrite, (UINT*)bytesWritten);
}

void close(int fileindex)
{
	FRESULT res = f_close(&files[fileindex]);
}
