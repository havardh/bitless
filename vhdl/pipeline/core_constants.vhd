-- Processor core constants
-- This file contains constants for various aspects of the processor core
-- and related modules.

library ieee;
use ieee.std_logic_1164.all;

package core_constants is
	type ringbuffer_mode is (NORMAL_MODE, RING_MODE);
	
	constant NUMBER_OF_PIPELINES : integer := 4;

	type alu_flags is
		record
			zero : std_logic;
			carry : std_logic;
			overflow : std_logic;
			negative : std_logic;
		end record;

	-- ALU operation list
	type alu_operation is (
		ALU_ADD,
		ALU_AND,
		ALU_OR,
		ALU_XOR
	);
end core_constants;
