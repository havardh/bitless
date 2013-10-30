#ifndef _BUTTONSCONFIG_H_
#define _BUTTONSCONFIG_H_

#include <stdint.h>

typedef enum {
    GG_STK3700, GG_DK3750, BITLESS
} Board_t;

typedef struct {
    uint32_t numButtons;
    Board_t board;
    uint8_t *pins;
} ButtonsConfig;

#endif /* _BUTTONSCONFIG_H_ */
