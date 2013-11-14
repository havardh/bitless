#include "bl_uart.h"
#include "bl_sdi.h"

int main(void) {

	UART_Init();
	SDI_Init();

	SDI_Start();
}
