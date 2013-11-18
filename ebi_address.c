#include <stdio.h>

int main(int argc, char * argv[])
{
	int toplevel, pipeline, device, subdevice, address;

	if(argc != 6)
	{
		printf("ebi_address <toplevel> <pipeline> <device> <subdevice> <address>\n");
		return 1;
	}

	sscanf(argv[1], "%d", &toplevel);
	sscanf(argv[2], "%d", &pipeline);
	sscanf(argv[3], "%d", &device);
	sscanf(argv[4], "%d", &subdevice);
	sscanf(argv[5], "%d", &address);
	printf("0x%x\n", toplevel << 22 | pipeline << 20 | device << 16 | subdevice << 14 | address);

	return 0;
}

