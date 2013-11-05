#ifndef _LEDSCONFIG_H_
#define _LEDSCONFIG_H_

#define NUM_LEDS        5
#define LED0            7
#define LED1            8
#define LED2            9
#define LED3           10
#define LED4           11

#define LEDS_ARRAY_INIT {\
    {gpioPortA, (LED0)}, \
    {gpioPortA, (LED1)}, \
    {gpioPortA, (LED2)}, \
    {gpioPortA, (LED3)}, \
    {gpioPortA, (LED4)}, \
}

/* Comment in lines below to run on STK_3700 */
// #define NUM_LEDS        2
// #define LEDS_ARRAY_INIT {{gpioPortE,2},{gpioPortE,3}}

#endif // _LEDSCONFIG_H_