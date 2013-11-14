#ifndef _MICROSDCONFIG_H_
#define _MICROSDCONFIG_H_

#define MICROSD_HI_SPI_FREQ     12000000

#define MICROSD_LO_SPI_FREQ     100000
#define MICROSD_USART           USART2
#define MICROSD_LOC             USART_ROUTE_LOCATION_LOC0
#define MICROSD_CMUCLOCK        cmuClock_USART2
#define MICROSD_GPIOPORT        gpioPortC
#define MICROSD_MOSIPIN         2
#define MICROSD_MISOPIN         3
#define MICROSD_CSPIN           5
#define MICROSD_CLKPIN          4


#endif /* _MICROSDCONFIG_H_ */
