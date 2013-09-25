-- Pipeline module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.core_constants.all;
use work.internal_bus.all;

entity pipeline is
	generic (
		num_cores		 : natural := 4
	);

	port (
		clk			: in std_logic; -- Small cycle clock
		sample_clk	: in std_logic; -- Large cucle clock

		-- Address of the pipeline, two bit number:
		pipeline_address : in std_logic_vector(1 downto 0);

		-- Connections to the internal bus interface:
		int_address  : in  internal_address;
		int_data_in  : in  internal_data;
		int_data_out : out internal_data;
		int_re       : in  std_logic; -- Read enable
		int_we       : in  std_logic  -- Write enable
	);
end entity;

architecture behaviour of pipeline is
	component core is
		generic(
			buffer_address_width : natural := 12;   -- Buffer address bus width
			const_address_width  : natural := 12;   -- Constant memory address width (minimum log2(constant memory size)).
			instr_memory_size    : natural := 1024; -- Instruction memory size
			instr_address_width  : natural := 10    -- Instruction memory address width (minimum log2(instr_memory_size)).
		);
		port(
			clk   : in std_logic; -- Small cycle clock signal
			reset : in std_logic; -- Reset signal, "large cycle" clock signal

			deadline_missed : out std_logic; -- Signal asserted if the processor is not idle on reset

			-- Internal bus connections, used for reading and writing the instruction memory:
			instr_address      : in std_logic_vector(instr_address_width - 1 downto 0);
			instr_data         : in std_logic_vector(15 downto 0);
			instr_write_enable : in std_logic;

			-- Connections to the constant memory controller:
			constant_addr        : out std_logic_vector(const_address_width - 1 downto 0);
			constant_data        : in  std_logic_vector(31 downto 0);
			constant_request     : out std_logic;
			constant_acknowledge : in  std_logic;

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
	end component;

	component memory is
		generic (
			size          : natural; -- Size of the memory in bytes
			address_width : natural
		);
		port (
			clk : in std_logic;
			address_in   : in  std_logic_vector(address_width - 1 downto 0); -- Write address
			address_out  : in  std_logic_vector(address_width - 1 downto 0); -- Read address
			data_in      : in  std_logic_vector(31 downto 0); -- Lower 16 bits is the first word, upper is the second.
			data_out     : out std_logic_vector(31 downto 0); -- Same as above.
			write_enable : in std_logic
		);
	end component;

	type core_status_register is record
			deadline_missed : std_logic;
			enabled : std_logic;
			instruction_we : std_logic;
		end record;
	type core_control_block is array(0 to num_cores - 1) of core_status_register;

	signal core_control : core_control_block;

	-- Write enable signal for the constant memory:
	signal constant_write_enable : std_logic;
	signal constant_data_in, constant_data_out : std_logic_vector(31 downto 0);
begin
	
	read_process: process(int_re)
	begin
		if rising_edge(int_re) then
			int_data_out <= constant_data_out(15 downto 0);
		end if;
	end process;

	write_process: process(int_we)
	begin
		if rising_edge(int_we) then
			constant_data_in <= x"0000" & int_data_in;
		end if;
	end process;

	constant_write_enable <= int_we;

	constant_memory: memory
		generic map(size => 1024, address_width => 16)
		port map(
			clk => clk,
			address_in => int_address.address(15 downto 0),
			address_out => int_address.address(15 downto 0),
			data_in => constant_data_in,
			data_out => constant_data_out,
			write_enable => constant_write_enable
		);

--	generate_cores:
--	for i in 0 to NUM_CORES - 1 generate
--		core_x: core port map (
--			clk => clk,
--			reset => sample_clk,
--			deadline_missed => core_control(i).deadline_missed,
--			instr_address => int_address.address(9 downto 0),
--			instr_data => int_data,
--			instr_write_enable => core_control(i).instruction_we,
--		);
--	end generate;

end behaviour;
