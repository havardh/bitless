#include "wav.h"
#include <stdio.h>
#include <stdlib.h>

#include <string.h>

void setupDefaultHeader(WAV_Header_TypeDef* header)
{
	header->id[0] = 'R';
	header->id[1] = 'I';
	header->id[2] = 'F';
	header->id[3] = 'F';
	header->totallength = 94174;
	header->wavefmt[0] = 'W';
	header->wavefmt[1] = 'A';
	header->wavefmt[2] = 'V';
	header->wavefmt[3] = 'E';
	header->wavefmt[4] = 'f';
	header->wavefmt[5] = 'm';
	header->wavefmt[6] = 't';
	header->wavefmt[7] = ' ';
	header->format = 16;
	header->pcm = 1;
	header->channels = 2;
	header->frequency = 8000;
	header->bytes_per_second  = 32000;
	header->bytes_per_capture = 4;
	header->bits_per_sample = 16;
	header->data[0] = 'd';
	header->data[1] = 'a';
	header->data[2] = 't';
	header->data[3] = 'a';
	header->bytes_in_data = 93972;
}

void WAV_Open(WAVFile *file, char *filename)
{
	
file->header = (WAV_Header_TypeDef*)malloc(sizeof(WAV_Header_TypeDef));
	open(file->fno, filename, file->mode);
	file->position = 0;
	file->eof = 0;
        
	if (file->mode == READ) {
		WAV_ReadHeader(file);
	} else {
		//setupDefaultHeader(file->header);
		
		WAV_WriteHeader(file);
	}
	
}

void WAV_ReadHeader(WAVFile *file)
{
	seek(file->fno, 0);
	WAV_Read(file, file->header, sizeof(WAV_Header_TypeDef));
}

void WAV_WriteHeader(WAVFile *file)
{
	seek(file->fno, 0);
	WAV_Write(file, file->header, sizeof(WAV_Header_TypeDef));
}


void WAV_Read(WAVFile *file, void *buffer, uint16_t bytesToRead)
{
	uint16_t bytesRead;
	
	read(file->fno, buffer, bytesToRead, &bytesRead);
	
	file->position += bytesRead;
	
	if (bytesRead < bytesToRead) {
		file->eof = true;
	}
	
}

void WAV_Write(WAVFile *file, void *buffer, uint16_t bytesToWrite)
{
	uint16_t bytesWritten;
	
	write(file->fno, buffer, bytesToWrite, &bytesWritten);

	file->position += bytesWritten;
}

void WAV_CopyHeader(WAVFile *from, WAVFile *to) 
{
	memcpy(to->header, from->header, sizeof(WAV_Header_TypeDef));
}

bool WAV_EOF(WAVFile *file)
{
	return file->eof;
}

void WAV_Close(WAVFile *file)
{
	if (file->mode == WRITE) {
		WAV_WriteHeader(file);
	}

	close(file->fno);
}

void WAV_PrintHeader(WAVFile *file) 
{
	printf("id: "); for (int i=0; i<4; i++) printf("%c", file->header->id[i]); printf("\n");
	printf("totallength: %d\n", (int)(file->header->totallength));
	printf("wavefmt: '"); for (int i=0; i<8; i++) printf("%c", file->header->wavefmt[i]); printf("'\n");
	printf("format: %d\n", (int)(file->header->format));
	printf("pcm: %d\n", (int)(file->header->pcm));
	printf("channels: %d\n", (int)(file->header->channels));
	printf("frequency: %d\n", (int)(file->header->frequency));
	printf("bytes_per_second: %d\n", (int)(file->header->bytes_per_second));
	printf("bytes_per_capture: %d\n", (int)(file->header->bytes_per_capture));
	printf("bits_per_sample: %d\n", (int)(file->header->bits_per_sample));
	printf("data: "); for (int i=0; i<4; i++) printf("%c", file->header->wavefmt[i]); printf("\n");
	printf("bytes_in_data: %d\n", (int)(file->header->bytes_in_data));
}
