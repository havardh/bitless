/**************************************************************************//**
 * @file
 * @brief FreeRTOS Tickless Demo for Energy Micro EFM32-Gxxx-DK Development Kit
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
#include "bsp_trace.h"
#include "segmentlcd.h"

#include "sleep.h"

#define STACK_SIZE_FOR_TASK    (configMINIMAL_STACK_SIZE + 10)
#define TASK_PRIORITY          (tskIDLE_PRIORITY + 1)
#define DELAY ( 700 / portTICK_RATE_MS )

/* Semaphores used by application to synchronize two tasks */
xSemaphoreHandle sem;
/* Text to display */
char text[8];
/* Counter start value*/
int count = 0;
/**************************************************************************//**
 * @brief LcdPrint task which is showing numbers on the display
 * @param *pParameters pointer to parameters passed to the function
 *****************************************************************************/
static void LcdPrint(void *pParameters)
{
  pParameters = pParameters;   /* to quiet warnings */
  for (;;)
  {
    /* Wait for semaphore, then display next number */
   if (pdTRUE == xSemaphoreTake(sem, portMAX_DELAY)) {	
    SegmentLCD_Write(text);
    }
  }
}
/**************************************************************************//**
 * @brief Count task which is preparing next number to display
 * @param *pParameters pointer to parameters passed to the function
 *****************************************************************************/
static void Count(void *pParameters)
{
  pParameters = pParameters;   /* to quiet warnings */

  for (;;)
  {
    count = (count + 1) & 0xF;
    text[0] = count >= 10 ? '1' : '0';
    text[1] = count % 10 + '0';
    text[2] = '\0';
    xSemaphoreGive(sem);
    vTaskDelay(DELAY);
  }
}

/**************************************************************************//**
 * @brief  Main function
 *****************************************************************************/
int main(void)
{
  /* Chip errata */
  CHIP_Init();

  /* If first word of user data page is non-zero, enable eA Profiler trace */
  BSP_TraceProfilerSetup();

  /* Initialize SLEEP driver, no calbacks are used */
  SLEEP_Init(NULL, NULL);
#if (configSLEEP_MODE < 3)
  /* do not let to sleep deeper than define */
  SLEEP_SleepBlockBegin((SLEEP_EnergyMode_t)(configSLEEP_MODE+1));
#endif

  /* Initialize the LCD driver */
  SegmentLCD_Init(false);

  /* Create standard binary semaphore */
  vSemaphoreCreateBinary(sem);

  /* Create two task to show numbers from 0 to 15 */
  xTaskCreate(Count, (const signed char *) "Count", STACK_SIZE_FOR_TASK, NULL, TASK_PRIORITY, NULL);
  xTaskCreate(LcdPrint, (const signed char *) "LcdPrint", STACK_SIZE_FOR_TASK, NULL, TASK_PRIORITY, NULL);

  /* Start FreeRTOS Scheduler */
  vTaskStartScheduler();

  return 0;
}
