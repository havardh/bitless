#include "bl_uart.h"
#include "bl_sdi.h"
#include "bl_ebi.h"

int main(void) {

	UART_Init();
	EBIDriver_Init();
	SDI_Init();

	SDI_Start();
}
