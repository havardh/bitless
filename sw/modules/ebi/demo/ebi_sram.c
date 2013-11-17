#include <stdint.h>
#include <stdbool.h>
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_dbg.h"
#include "em_emu.h"
#include "em_gpio.h"

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

// #define EXT_SRAM_BASE_ADDRESS ((volatile uint8_t*) BC_PSRAM_BASE)

#define TEST_ADDRESS 0x84000000

#define TEST_ARRAY_SIZE 32

uint8_t test[TEST_ARRAY_SIZE] = {
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
};

uint8_t answer[TEST_ARRAY_SIZE] = {
    0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 
    0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
    0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 
    0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
};

void write(uint8_t * data, int size) {
    for (int i=0; i<size; i++) {
        *(uint8_t*)(TEST_ADDRESS + i) = data[i];
    }
}

void read(uint8_t *data, int size) {
    for (int i=0; i<size; i++) {
        data[i] = *(uint8_t*)(TEST_ADDRESS + i);
    }
}

bool test_result(uint8_t *a, uint8_t *b, int size) {
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

    EBIDriver_Init();
    //Delay(1000);

    write(test, TEST_ARRAY_SIZE);
    read(answer, TEST_ARRAY_SIZE);

    bool result = test_result(test, answer, TEST_ARRAY_SIZE);

    /*BSP_Init(BSP_INIT_DK_SPI);*/

    while(1) {
		/*BSP_LedsSet(0x0);
        Delay(1000);

        if (result) {
            BSP_LedsSet(0xFF);
        } else {
            BSP_LedsSet(0x0001);
        }

        Delay(1000);*/

    }

}
