#include "INTDriver.h"

static uint8_t next = -1;         // The next interrupt handler to call
static uint8_t skipped = -1;      // If a interrupt was skipped
static void (*handlers[8])(void); // Interrupt handlers

void noop( void ) {
	// Noop
}

void INTDriver_Init( void )
{
	handlers[0] = &noop;
	handlers[1] = &noop;
	handlers[2] = &noop;
	handlers[3] = &noop;
	handlers[4] = &noop;
	handlers[5] = &noop;
	handlers[6] = &noop;
	handlers[7] = &noop;
}

void INTDriver_SetTriggerInterrupt( uint8_t interrupt ) 
{
	INTDriver_SetNext(interrupt);
	INTDriver_TriggerInterrupt();
}

void INTDriver_SetNext( uint8_t interrupt )
{
	if (interrupt < 8 && interrupt >= 0) {
		
		// Check if a interrupt was already due
		if (next != -1) {
			// Set skipped to indicate skipped interrupt
			skipped = next;
		}
		// Set next interrupt
		next = interrupt;
	}
}

void INTDriver_TriggerInterrupt( void )
{
	SCB->ICSR = SCB_ICSR_PENDSVSET_Msk;
}

void INTDriver_RegisterCallback( uint8_t interrupt, void (*callback)(void) )
{
	if (interrupt < 8 && interrupt >= 0) {
		handlers[interrupt] = callback;
	}
}

void PendSV_Handler( void )
{

	if (next < 8 && next >= 0) {
		// Call handler
		(*handlers[next])();
		// Reset next
		next = -1;
	}
}
