#include <stdio.h>
#include <stdint.h>

#define FILE1 "sweet1.wav"
#define FILE2 "sweet2.wav"

#define N 512

int main(void) 
{

	FILE *f1 = fopen(FILE1, "r");
	FILE *f2 = fopen(FILE2, "r");

	uint32_t b1[N];
	uint32_t b2[N];
	
	int j = 0;
	while(1) {
		
		int bytes1 = fread(&b1, 4, N, f1);
		int bytes2 = fread(&b2, 4, N, f2);

		if (bytes1 != N || bytes2 != N) {
			break;
		}

		for (int i=0; i<N; i++) {
			if (b1[i] != b2[i]) {
				printf("wrong %d, %d\n", j, i);
			}
		}
		j++;
	}

	printf("Done (%d)\n", j);


	fclose(f1);
	fclose(f2);

	return 0;

}
