#include "bsp.h"
#include "em_device.h"
#include "em_common.h"
#include "em_cmu.h"
#include "em_emu.h"
#include "ff.h"
#include "microsd.h"
#include "diskio.h"

static FATFS Fatfs;

int initFatFS( void ) 
{
	MICROSD_Init();
	FRESULT res = f_mount(0, &Fatfs);
	if (res != FR_OK)
		return -1;
	return 0;
}

void setup() 
{
	CMU_ClockSelectSet(cmuClock_HF, cmuSelect_HFXO);
	
	BSP_Init(BSP_INIT_DEFAULT);
	BSP_LedsSet(0x0);
	
  if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 100))
	{
			while (1) ;
	}
	
	BSP_PeripheralAccess(BSP_MICROSD, true);

}
static char *fn;
FRESULT scan_files (char* path)
{
    FRESULT res;
    FILINFO fno;
    DIR dir;
    int i;


    res = f_opendir(&dir, path);
    if (res == FR_OK) {
        i = strlen(path);
        for (;;) {
            res = f_readdir(&dir, &fno);
            if (res != FR_OK || fno.fname[0] == 0) break;
            if (fno.fname[0] == '.') continue;

            fn = fno.fname;
            if (fno.fattrib & AM_DIR) {
                sprintf(&path[i], "/%s", fn);
                res = scan_files(path);
                if (res != FR_OK) break;
                path[i] = 0;
            } else {
              char str[50];
              sprintf(str, "%s/%s\n", path, fn);
            }
        }
    }

    return res;
}

int main( void ) {

	int res = initFatFS();
	if (res == FR_OK) {
		res = scan_files(".");
		while(1);
	} else {
		while(1);
	}

}
