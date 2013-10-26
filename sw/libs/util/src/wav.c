#include "wav.h"
#include <stdio.h>
#include <stdlib.h>

void WAV_Open(WAVFile *file, char *filename)
{
	file->header = (WAV_Header_TypeDef*)malloc(sizeof(WAV_Header_TypeDef));
 	printf("Opening file: %s\n", filename);
	open(file->fno, filename, file->mode);
	file->position = 0;
	file->eof = 0;
	
	//if (res == FR_OK) {
	if (file->mode == READ) {
		printf("Reading fileheader\n");
		WAV_ReadHeader(file);
	} else {
		WAV_WriteHeader(file);
	}
	//}
	
}

void WAV_ReadHeader(WAVFile *file)
{
	WAV_Read(file, file->header, sizeof(WAV_Header_TypeDef));
}

void WAV_WriteHeader(WAVFile *file)
{
	WAV_Write(file, file->header, sizeof(WAV_Header_TypeDef));
}


void WAV_Read(WAVFile *file, void *buffer, uint16_t bytesToRead)
{
	uint16_t bytesRead;
	
	read(file->fno, buffer, bytesToRead, &bytesRead);

	//printf("Read: %d\n", bytesRead); 
	
	file->position += bytesRead;
	
	if (bytesRead < bytesToRead) {
		file->eof = true;
	}
	
}

void WAV_Write(WAVFile *file, void *buffer, uint16_t bytesToWrite)
{
	uint16_t bytesWritten;
	
	write(file->fno, buffer, bytesToWrite, &bytesWritten);

	//printf("Wrote: %d\n", bytesWritten); 

	file->position += bytesWritten;

	
}

bool WAV_EOF(WAVFile *file)
{
	return file->eof;
}

void WAV_Close(WAVFile *file)
{
	//if ()


	//printf("Length: %d\n", file->header->totallength);
	close(file->fno);
}

void WAV_PrintHeader(WAVFile *file) 
{
	printf("id[4]: %d\n", (int)(file->header->id));
	printf("totallength: %d\n", (int)(file->header->totallength));
	printf("wavefmt[8]: %d\n", (int)(file->header->wavefmt));
	printf("format: %d\n", (int)(file->header->format));
	printf("pcm: %d\n", (int)(file->header->pcm));
	printf("channels: %d\n", (int)(file->header->channels));
	printf("frequency: %d\n", (int)(file->header->frequency));
	printf("bytes_per_second: %d\n", (int)(file->header->bytes_per_second));
	printf("bytes_per_capture: %d\n", (int)(file->header->bytes_per_capture));
	printf("bits_per_sample: %d\n", (int)(file->header->bits_per_sample));
	printf("data[4]: %d\n", (int)(file->header->data));
	printf("bytes_in_data: %d\n", (int)(file->header->bytes_in_data));

}
