#include <string.h>
#include <stdio.h>
#include "FPGAController.h"
#include "FPGAConfig.h"
#include "bl_uart.h"
#include "bl_leds.h"

#define READ_TOPLEVEL       "Reading toplevel...\n\r"
#define WRITE_TOPLEVEL      "Writing toplevel...\n\r"
#define READ_PIPELINE       "Reading pipeline...\n\r"
#define WRITE_PIPELINE      "Writing pipeline...\n\r"
#define READ_CORE           "Reading core...\n\r"
#define WRITE_CORE          "Writing core...\n\r"

#define STR_BUFFER          200

void read_toplevel(void);
void write_toplevel(void);
void read_pipeline(void);
void write_pipeline(void);
void read_core(void);
void write_core(void);

void parse_cmd() {
    char cmd = (char) UART_GetChar();

    switch (cmd) {
        case 'a':
            UART_PutData((uint8_t*)READ_TOPLEVEL, strlen(READ_TOPLEVEL));
            read_toplevel();
            break;
        case 'b':
            UART_PutData((uint8_t*)WRITE_TOPLEVEL, strlen(WRITE_TOPLEVEL));
            write_toplevel();
            break;
        case 'c':
            UART_PutData((uint8_t*)READ_PIPELINE, strlen(READ_PIPELINE));
            read_pipeline();
            break;
        case 'd':
            UART_PutData((uint8_t*)WRITE_PIPELINE, strlen(WRITE_PIPELINE));
            write_pipeline();
            break;
        case 'e':
            UART_PutData((uint8_t*)READ_CORE, strlen(READ_CORE));
            read_core();
            break;
        case 'f':
            UART_PutData((uint8_t*)WRITE_CORE, strlen(WRITE_CORE));
            write_core();
            break;
    }
}

int main() {
    Leds_Init();
    UART_Init();

    UART_PutData((uint8_t*)"Test\n\r", 6);

    FPGAConfig conf = FPGA_CONFIG_DEFAULT((uint16_t*) 0x80000000);
    FPGA_Init(&conf);


    while (1) {
        parse_cmd();
    }
        
    FPGA_Destroy();
    return 0;
}

void read_toplevel(void) {
    FPGA_ControlRegister reg = FPGA_GetControlRegister();

    char toplevel[STR_BUFFER];
    sprintf(toplevel, " ");
}

void write_toplevel(void) {
    
}

void read_pipeline(void) {
}

void write_pipeline(void) {

}

void read_core(void) {
}

void write_core(void) {
}

