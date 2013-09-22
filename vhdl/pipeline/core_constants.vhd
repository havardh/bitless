-- Processor core constants
-- This file contains constants for various aspects of the processor core
-- and related modules.

package core_constants is
	type ringbuffer_mode is (NORMAL_MODE, RING_MODE);
	
	constant NUMBER_OF_PIPELINES : integer := 4;
end core_constants;
