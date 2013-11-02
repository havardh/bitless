#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_dbg.h"
#include "em_emu.h"
#include "em_gpio.h"
#include "bsp.h"
#include "bsp_trace.h"
#include "EBI_test.h"

volatile uint32_t msTicks; /* counts 1ms timeTicks */

void Delay(uint32_t dlyTicks);

void SysTick_Handler(void)
{
  msTicks++;       /* increment counter necessary in Delay()*/
}

void Delay(uint32_t dlyTicks)
{
  uint32_t curTicks;

  curTicks = msTicks;
  while ((msTicks - curTicks) < dlyTicks) ;
}

#define EXT_SRAM_BASE_ADDRESS ((volatile uint16_t*) BC_PSRAM_BASE)

#define TEST_ADDRESS 0x100000

#define TEST_ARRAY_SIZE 32

uint16_t test[TEST_ARRAY_SIZE] = {
    0x7BC1, 0x1EE2, 0x2E40, 0x9F96, 0xE93D, 0x7E11, 0x7393, 0x172A,
    0xAE2D, 0x8A57, 0x1E03, 0xAC9C, 0x9EB7, 0x6FAC, 0x45AF, 0x8E51,
    0x30C8, 0x1C46, 0xA35C, 0xE411, 0xE5FB, 0xC119, 0x1A0A, 0x52EF,
    0xF69F, 0x2445, 0xDF4F, 0x9B17, 0xAD2B, 0x417B, 0xE66C, 0x3710 
};

uint16_t answer[TEST_ARRAY_SIZE] = {
    0x0000, 0x1111, 0x2222, 0x3333, 0x4444, 0x5555, 0x6666, 0x7777, 
    0x8888, 0x9999, 0xAAAA, 0xBBBB, 0xCCCC, 0xDDDD, 0xEEEE, 0xFFFF,
    0x0000, 0x1111, 0x2222, 0x3333, 0x4444, 0x5555, 0x6666, 0x7777, 
    0x8888, 0x9999, 0xAAAA, 0xBBBB, 0xCCCC, 0xDDDD, 0xEEEE, 0xFFFF
};

void write(uint16_t * data, int size) {
    for (int i=0; i<size; i++) {
        *(uint16_t*)(TEST_ADDRESS + i) = data[i];
    }
}

void read(uint16_t *data, int size) {
    for (int i=0; i<size; i++) {
        data[i] = *(uint16_t*)(TEST_ADDRESS + i);
    }
}

bool test_result(uint16_t *a, uint16_t *b, int size) {
    bool result = true;
    for (int i=0; i<size; i++) {
        if (a[i] != b[i]) {
            result = false;
        }
    }
    return result;
}

int main( void ) {

  CHIP_Init();
  if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000)) while (1) ;

    // BSP_Init( BSP_INIT_DEFAULT );

    // while(BSP_RegisterRead (&BC_REGISTER->UIF_AEM) != BC_UIF_AEM_EFM);

    EBITest_Init();
    Delay(1000);

    write(test, TEST_ARRAY_SIZE);
    read(answer, TEST_ARRAY_SIZE);

    bool result = test_result(test, answer, TEST_ARRAY_SIZE);

    while(1) {
        BSP_LedsSet(0x0);
        Delay(1000);

        if (result) {
            BSP_LedsSet(0xFF);
        } else {
            BSP_LedsSet(0xFF00);
        }

        Delay(1000);

    }

}
