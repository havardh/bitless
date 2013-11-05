#ifndef _WAV_H_
#define _WAV_H_

#include <stdbool.h>
#include <stdint.h>

typedef enum {
	READ, WRITE
} WAVFileMode;

// From wavplayer DK kit demo by Energy Micro.

/** WAV header structure */
typedef struct {
  uint8_t  id[4];                   /** should always contain "RIFF"      */
  uint32_t totallength;             /** total file length minus 8         */
  uint8_t  wavefmt[8];              /** should be "WAVEfmt "              */
  uint32_t format;                  /** Sample format. 16 for PCM format. */
  uint16_t pcm;                     /** 1 for PCM format                  */
  uint16_t channels;                /** Channels                          */
  uint32_t frequency;               /** sampling frequency                */
  uint32_t bytes_per_second;        /** Bytes per second                  */
  uint16_t bytes_per_capture;       /** Bytes per capture                 */
  uint16_t bits_per_sample;         /** Bits per sample                   */
  uint8_t  data[4];                 /** should always contain "data"      */
  uint32_t bytes_in_data;           /** No. bytes in data                 */
} WAV_Header_TypeDef;

typedef struct {
  int fno;
//FIL *file;
	WAV_Header_TypeDef *header;
  WAVFileMode mode;

  bool eof;
	uint16_t position;
} WAVFile;

void WAV_Open(WAVFile *file, char *filename);
void WAV_Read(WAVFile *file, void *buffer, uint16_t bytesToRead);
void WAV_Write(WAVFile *file, void *buffer, uint16_t bytesToWrite);
void WAV_Close(WAVFile *file);

void WAV_CopyHeader(WAVFile *from, WAVFile *to);
bool WAV_EOF(WAVFile *file);

void WAV_ReadHeader(WAVFile *file);
void WAV_WriteHeader(WAVFile *file);

void WAV_PrintHeader(WAVFile *file);

#endif /* _WAV_H_ */
