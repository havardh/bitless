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

	-- Type to use for arrays of addresses:
	type address_array is array(integer range <>) of std_logic_vector(15 downto 0);

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

	type alu_result_select is (
		ALU_ADD_SELECT,
		ALU_LOG_SELECT,
		ALU_FPU_SELECT
	);

	type alu_flag_select is (
		ADD_FLAGS_SEL,
		MUL_FLAGS_SEL,
		FPU_FLAGS_SEL,
		LOG_FLAGS_SEL
	);

	type register_write_enable is (
		REG_A_WRITE,
		REG_AB_WRITE,
		REG_LDI_WRITE,
		REG_DONT_WRITE
	);
end core_constants;
