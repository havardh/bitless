#include "SDDriver.h"
#include "ff.h"

static WAVFile *srcFile = 0;
static WAVFile *dstFile = 0;

static int bufferSize;
void* (*GetInputBuffer)(void);
void* (*GetOutputBuffer)(void);

static void initFiles( SDConfig *config );

void SDDriver_Init( SDConfig *config )
{
	bufferSize = config->bufferSize;
	GetInputBuffer = config->GetInputBuffer;
	GetOutputBuffer = config->GetOutputBuffer;

  //BSP_PeripheralAccess(BSP_MICROSD, true);
	MICROSD_Init();
	mount();
	//printf("Mounted\n");
	initFiles(config);
}

bool SDDriver_Read() 
{
	WAV_Read(srcFile, (*GetInputBuffer)(), 4*bufferSize);

	return WAV_EOF(srcFile);
}

void SDDriver_Write()
{
	WAV_Write(dstFile, GetOutputBuffer(), bufferSize);
}

void SDDriver_Finalize()
{
	WAV_Close(srcFile);
	WAV_Close(dstFile);
}

static void initFiles( SDConfig *config )
{

	FRESULT res = f_mkdir("test");

	if (config->mode == IN || config->mode == INOUT) {
		srcFile = (WAVFile*)malloc(sizeof(WAVFile));
		srcFile->fno = 0;
		srcFile->mode = READ;
		WAV_Open(srcFile, config->inFile);
	}

	if (config->mode == OUT || config->mode == INOUT) {
		dstFile = (WAVFile*)malloc(sizeof(WAVFile));
		dstFile->fno = 1;
		dstFile->mode = WRITE;
		WAV_Open(dstFile, config->outFile);
	}

	if (config->mode == INOUT) {
		WAV_CopyHeader(srcFile, dstFile);
	}

}

void SDDriver_PrintWAVS( void )
{
	WAV_PrintHeader(srcFile);
	WAV_PrintHeader(dstFile);
}
