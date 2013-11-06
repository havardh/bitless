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

	-- Types to use for various arrays:
	type address_array is array(integer range <>) of std_logic_vector(15 downto 0);
	type data_array_16 is array(integer range <>) of std_logic_vector(15 downto 0);
	type data_array_32 is array(integer range <>) of std_logic_vector(31 downto 0);

	-- ALU operation list
	type alu_operation is (
		ALU_ADD,
		ALU_MUL,
		ALU_SUB,
		ALU_AND,
		ALU_OR,
		ALU_XOR,
		ALU_NAND,
		ALU_NOR,
		ALU_MOVE,
		ALU_MOVE_NEGATIVE,
		fp_mul,
		fp_add,
		fp_sub,
		fp_mac,
		fp_mas,
		ALU_FIXED_TO_FLOAT,
		ALU_FLOAT_TO_FIXED
	);

	type alu_result_select is (
		ALU_ADD_SELECT,
		ALU_LOG_SELECT,
		ALU_FPU_SELECT,
		ALU_MUL_SELECT,
		ALU_FIX_SELECT,
		ALU_FLT_SELECT
	);

	type register_write_enable is (
		REG_A_WRITE,
		REG_AB_WRITE,
		REG_LDI_WRITE,
		REG_DONT_WRITE
	);
	
	type mem_source is (
		MEM_INPUT,
		MEM_OUTPUT,
		MEM_CONST
	);
	
	type wb_source is (
		MUX_ALU,
		MUX_MEM,
		MUX_IMM
	);
end core_constants;
