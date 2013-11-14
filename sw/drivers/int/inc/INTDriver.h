#ifndef _INTDRIVER_H_
#define _INTDRIVER_H_

#include <stdint.h>
#include "em_device.h"

void INTDriver_Init( void );
void INTDriver_SetNext( uint8_t interrupt );
void INTDriver_SetTriggerInterrupt( uint8_t interrupt );
void INTDriver_TriggerInterrupt( void );
void INTDriver_RegisterCallback( uint8_t interrupt, void (*callback)(void) );

#endif /* _INTDRIVER_H_ */
