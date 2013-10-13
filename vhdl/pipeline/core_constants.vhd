-- Processor core constants
-- This file contains constants for various aspects of the processor core
-- and related modules.

library ieee;
use ieee.std_logic_1164.all;

package core_constants is
	type ringbuffer_mode is (NORMAL_MODE, RING_MODE);

	-- Total number of pipelines to generate:
	constant NUMBER_OF_PIPELINES : integer := 2;
	-- Total number of cores to generate:
	constant NUMBER_OF_CORES : integer := 8;

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
		ALU_XOR,
		ALU_NAND,
		ALU_NOR,
		ALU_MOVE,
		ALU_MOVE_NEGATIVE
	);
end core_constants;
