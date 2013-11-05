#ifndef _BUTTONSCONFIG_H_
#define _BUTTONSCONFIG_H_

#include <stdint.h>

typedef enum {
    GG_STK3700, GG_DK3750, BITLESS
} Board_t;

#define NUM_BUTTONS         5
#define BTN0                15
#define BTN1                6
#define BTN2                7
#define BTN3                8
#define BTN4                9

#define BUTTONS_ARRAY_INIT {\
    {gpioPortB, (BTN0)},    \
    {gpioPortC, (BTN1)},    \
    {gpioPortD, (BTN2)},    \
    {gpioPortD, (BTN3)},    \
    {gpioPortD, (BTN4)},    \
}

#endif /* _BUTTONSCONFIG_H_ */
