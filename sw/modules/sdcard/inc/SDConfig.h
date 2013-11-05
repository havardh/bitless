#ifndef _SDCONFIG_H_
#define _SDCONFIG_H_

typedef enum {
	IN, OUT, INOUT
} SDMode;

typedef struct {

	SDMode mode;
	char *inFile;
	char *outFile;

	int bufferSize;
	void* (*GetInputBuffer)(void);
	void* (*GetOutputBuffer)(void);

} SDConfig;

#endif /* _SDCONFIG_H_ */
