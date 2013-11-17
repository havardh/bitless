#include "wav.h"
#include <stdint.h>

#define N 512

int main() {

	WAVFile in, out;

	in.mode = READ;
	in.fno = 0;
	out.mode = WRITE;
	out.fno = 1;

	WAV_Open(&in, "sweet1.wav");
	WAV_Open(&out, "sweet2.wav");

	WAV_CopyHeader(&in, &out);

	uint8_t buffer[N];
	while (!WAV_EOF(&in)) {

		WAV_Read(&in, &buffer, N);
		WAV_Write(&out, &buffer, N);

	}

	WAV_PrintHeader(&in);
	WAV_PrintHeader(&out);

	WAV_Close(&in);
	WAV_Close(&out);

}
