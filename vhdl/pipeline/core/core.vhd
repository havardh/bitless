-- Toplevel processor core module

library ieee;
use ieee.std_logic_1164.ALL;

library work;
use work.core_constants.all;

entity core is
	generic(
		buffer_address_width : natural := 12;   -- Buffer address bus width
		const_address_width  : natural := 12;   -- Constant memory address width (minimum log2(constant memory size)).
		instr_memory_size    : natural := 1024; -- Instruction memory size
		instr_address_size   : natural := 12    -- Instruction memory address width (minimum log2(instr_memory_size)).
	);

	port(
		clk   : in std_logic; -- Small cycle clock signal
		reset : in std_logic; -- Reset signal, "large cycle" clock signal

		-- Internal bus connections, used for reading and writing the instruction memory:
		instr_address      : in std_logic_vector(instr_address_width - 1 downto 0);
		instr_data         : in std_logic_vector(15 downto 0);
		instr_write_enable : in std_logic;

		-- Connections to the constant memory controller:
		constant_addr    : out std_logic_vector(const_address_width - 1 downto 0);
		constant_data    : in  std_logic_vector(31 downto 0);
		constant_request : out std_logic;
		constant_read    : in  std_logic;

		-- Connections to the input buffer:
		input_address     : out std_logic_vector(buffer_address_width - 1 downto 0);
		input_data        : in  std_logic_vector(31 downto 0);
		input_read_enable : out std_logic;

		-- Connections to the output buffer:
		output_address      : out std_logic_vector(buffer_address_width - 1 downto 0);
		output_data         : out std_logic_vector(31 downto 0);
		output_write_enable : out std_logic;
		output_read_address : out std_logic_vector(buffer_address_width - 1 downto 0);
		output_read_data    : in  std_logic_vector(31 downto 0);
		output_read_enable  : out std_logic
 	);
end entity;

architecture behaviour of core is
	component alu is
		port (
			a, b, c : in std_logic_vector(15 downto 0);
			result : out std_logic_vector(15 downto 0);
			flags  : out alu_flags;
			operation : in alu_operation
		);
	end component;
begin

end behaviour;
