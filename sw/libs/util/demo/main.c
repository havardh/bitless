#include "../inc/file.h";
#include <stdio.h>

#define N 64

int main (void) {

	open(0, "test", READ);
	open(1, "out", WRITE);
	
	char buffer[N+1];
	uint32_t bytesRead;
	uint32_t bytesWritten;

	while (1) {
		read(0, buffer, N, &bytesRead);
		write(1, buffer, bytesRead, &bytesWritten);
		printf("%d\n", bytesWritten);
		buffer[bytesRead] = '\0';

		printf("%s\n", buffer);

		if (bytesRead < N ) {
			printf("EOF\n");
			break;
		}
	}

	close(0);

	return 0;
}
