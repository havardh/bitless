/**************************************************************************//**
 * @file
 * @brief Joystick interrupt example for EFM32-Gxxx-DK
 * @author Energy Micro AS
 * @version 3.20.2
 ******************************************************************************
 * @section License
 * <b>(C) Copyright 2012 Energy Micro AS, http://www.energymicro.com</b>
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
#include "em_device.h"
#include "em_chip.h"
#include "em_cmu.h"
#include "em_gpio.h"
#include "bsp.h"
#include "bsp_trace.h"

/** Interrupt pin used to detect joystick activity */
#define GPIO_INT_PIN 14

volatile uint32_t msTicks; /* counts 1ms timeTicks */

/* Local prototypes */
void Delay(uint32_t dlyTicks);
void DkIrqInit(void);
void GpioIrqInit(void);

/**************************************************************************//**
 * @brief SysTick_Handler
 * Interrupt Service Routine for system tick counter
 *****************************************************************************/
void SysTick_Handler(void)
{
  msTicks++;       /* increment counter necessary in Delay()*/
}

/**************************************************************************//**
 * @brief Delays number of msTick Systicks (typically 1 ms)
 * @param dlyTicks Number of ticks to delay
 *****************************************************************************/
void Delay(uint32_t dlyTicks)
{
  uint32_t curTicks;

  curTicks = msTicks;
  while ((msTicks - curTicks) < dlyTicks) ;
}

/**************************************************************************//**
 * @brief Initialize GPIO interrupt on PC14
 *****************************************************************************/
void GPIO_EVEN_IRQHandler(void)
{
  uint16_t data, joystick;

  /* Clear intedvkrrupt */
  data = BSP_InterruptFlagsGet();
  BSP_InterruptFlagsClear(data);

  /* Clear GPIO interrupt */
  GPIO_IntClear(1 << GPIO_INT_PIN);

  /* Read joystick status */
  joystick = BSP_JoystickGet();

  /* Light up LEDs according to joystick status */
  BSP_LedsSet(joystick);
}

/**************************************************************************//**
 * @brief Initialize GPIO interrupt on PC14
 *****************************************************************************/
void GpioIrqInit(void)
{
  /* Configure interrupt pin as input with pull-up */
  GPIO_PinModeSet(gpioPortC, GPIO_INT_PIN, gpioModeInputPull, 1);

  /* Set falling edge interrupt and clear/enable it */
  GPIO_IntConfig(gpioPortC, GPIO_INT_PIN, false, true, true);

  NVIC_ClearPendingIRQ(GPIO_EVEN_IRQn);
  NVIC_EnableIRQ(GPIO_EVEN_IRQn);
}

/**************************************************************************//**
 * @brief Enable DK FPGA to generate GPIO PC14 trigger on control updates
 *****************************************************************************/
void DkIrqInit(void)
{
  /* Enable interrupts on joystick events only */
  BSP_InterruptDisable(0xffff);
  BSP_InterruptFlagsClear(0xffff);
  BSP_InterruptEnable(BC_INTEN_JOYSTICK);
}

/**************************************************************************//**
 * @brief  Main function
 *****************************************************************************/
int main(void)
{
  /* Chip revision alignment and errata fixes */
  CHIP_Init();

  /* Initialize DK board register access */
  BSP_Init(BSP_INIT_DEFAULT);

  /* If first word of user data page is non-zero, enable eA Profiler trace */
  BSP_TraceProfilerSetup();

  /* Setup SysTick Timer for 1 msec interrupts  */
  if (SysTick_Config(CMU_ClockFreqGet(cmuClock_CORE) / 1000))
  {
    while (1) ;
  }

  /* Initialize DK interrupt enable */
  DkIrqInit();

  /* Initialize GPIO interrupt */
  GpioIrqInit();

  /* Turn off LEDs */
  BSP_LedsSet(0x0000);

  while (1)
  {
    /* Wait 5 seconds */
    Delay(5000);
    /* Quick flash to show we're alive */
    BSP_LedsSet(0xffff);
    Delay(20);
    BSP_LedsSet(0x0000);
  }
}