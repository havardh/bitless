/**************************************************************************//**
 * @file
 * @brief FreeRTOS Blink Demo for Energy Micro EFM32-Gxxx-DK Development Kit
 * @author Energy Micro AS
 * @version 3.20.2
 ******************************************************************************
 * @section License
 * <b>(C) Copyright 2013 Energy Micro AS, http://www.energymicro.com</b>
 *******************************************************************************
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 * 4. The source and compiled code may only be used on Energy Micro "EFM32"
 *    microcontrollers and "EFR4" radios.
 *
 * DISCLAIMER OF WARRANTY/LIMITATION OF REMEDIES: Energy Micro AS has no
 * obligation to support this Software. Energy Micro AS is providing the
 * Software "AS IS", with no express or implied warranties of any kind,
 * including, but not limited to, any implied warranties of merchantability
 * or fitness for any particular purpose or warranties against infringement
 * of any proprietary rights of a third party.
 *
 * Energy Micro AS will not be liable for any consequential, incidental, or
 * special damages, or any other relief, or for any claim by any third party,
 * arising from your use of this Software.
 *
 *****************************************************************************/

#include <stdio.h>
#include <stdlib.h>

#include "FreeRTOSConfig.h"
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "semphr.h"
#include "croutine.h"

#include "em_chip.h"
#include "bsp.h"
#include "bsp_trace.h"

#include "sleep.h"

#define STACK_SIZE_FOR_TASK    (configMINIMAL_STACK_SIZE + 10)
#define TASK_PRIORITY          (tskIDLE_PRIORITY + 1)

/* Structure with parameters for LedBlink */
typedef struct
{
  /* Delay between blink of led */
  portTickType delay;
  /* Number of led */
  int          ledNo;
} TaskParams_t;


/**************************************************************************//**
 * @brief Simple task which is blinking led
 * @param *pParameters pointer to parameters passed to the function
 *****************************************************************************/
static void LedBlink(void *pParameters)
{
  TaskParams_t     * pData = (TaskParams_t*) pParameters;
  const portTickType delay = pData->delay;
  
  for (;;)
  {
    BSP_LedToggle(pData->ledNo);
    vTaskDelay(delay);
  }
}

/**************************************************************************//**
 * @brief  Main function
 *****************************************************************************/
int main(void)
{
  /* Chip errata */
  CHIP_Init();
  
  /* Initialize DK board register access */
  BSP_Init(BSP_INIT_DEFAULT);
  
  /* If first word of user data page is non-zero, enable eA Profiler trace */
  BSP_TraceProfilerSetup();

  /* Initialize SLEEP driver, no calbacks are used */
  SLEEP_Init(NULL, NULL);
#if (configSLEEP_MODE < 3)
  /* do not let to sleep deeper than define */
  SLEEP_SleepBlockBegin((SLEEP_EnergyMode_t)(configSLEEP_MODE+1));
#endif

  /* Initialize LED driver */
  BSP_LedsInit();
  /* Setting state of leds*/
  BSP_LedSet(0);
  BSP_LedSet(1);

  /* Parameters value for taks*/
  static TaskParams_t parametersToTask1 = { 1000 / portTICK_RATE_MS, 0 };
  static TaskParams_t parametersToTask2 = { 500 / portTICK_RATE_MS, 1 };

  /*Create two task for blinking leds*/
  xTaskCreate( LedBlink, (const signed char *) "LedBlink1", STACK_SIZE_FOR_TASK, &parametersToTask1, TASK_PRIORITY, NULL);
  xTaskCreate( LedBlink, (const signed char *) "LedBlink2", STACK_SIZE_FOR_TASK, &parametersToTask2, TASK_PRIORITY, NULL);

  /*Start FreeRTOS Scheduler*/
  vTaskStartScheduler();

  return 0;
}
