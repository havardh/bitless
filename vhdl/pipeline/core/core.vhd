-- Toplevel processor core module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.core_constants.all;
use work.internal_bus.all;

entity core is
	generic(
		buffer_address_width : natural := 12;   -- Buffer address bus width
		const_address_width  : natural := 12;   -- Constant memory address width (minimum log2(constant memory size)).
		instr_memory_size    : natural := 1024; -- Instruction memory size
		instr_address_width   : natural := 10    -- Instruction memory address width (minimum log2(instr_memory_size)).
	);

	port(
		clk        : in std_logic; -- Small cycle clock signal
		memclk     : in std_logic; -- Memory clock signal
		sample_clk : in std_logic; -- Reset signal, "large cycle" clock signal

		reset      : in std_logic; -- Resets the processor core

		-- Internal bus connections, used for reading and writing the instruction memory:
		instr_address      : in std_logic_vector(15 downto 0);
		instr_data_in      : in std_logic_vector(15 downto 0);
		instr_data_out     : out std_logic_vector(15 downto 0);
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

	component memory is
		generic (
			size          : natural; -- Size of the memory in bytes
			address_width : natural
		);
		port (
			clk : in std_logic;
			write_address : in  std_logic_vector(address_width - 1 downto 0); -- Write address
			read_address  : in  std_logic_vector(address_width - 1 downto 0); -- Read address
			write_data    : in  std_logic_vector(15 downto 0); -- Lower 16 bits is the first word, upper is the second.
			read_data     : out std_logic_vector(31 downto 0); -- Same as above.
			write_enable  : in std_logic
		);
	end component;

	component program_counter is
		generic (
			address_width : natural
		);
		port (
			clk 			: in std_logic;
			reset			: in std_logic;
			address_in	: in std_logic_vector(address_width - 1 downto 0);
			address_out	: out std_logic_vector(address_width - 1 downto 0);
			pc_wr_enb	: in std_logic
		);
	end component;

	component adder is
		port (
			a, b : in std_logic_vector(15 downto 0);
			result : out std_logic_vector(15 downto 0);
			flags  : out alu_flags
		);
	end component;

	-- Signal set to high while the processor is running:
	signal running : std_logic := '1';

	-- Instruction memory asignals:
	signal instr_read_address, instr_write_address : std_logic_vector(15 downto 0);
	signal instr_read_data : std_logic_vector(31 downto 0);
	signal instr_write_data : std_logic_vector(15 downto 0);

	-- Program counter value:
	signal pc_value, pc_inc_value, pc_next_value : std_logic_vector(15 downto 0);

	-- Status register:
	signal control_register : core_control_register;
begin

	-- Status register stuff:
	control_register.instruction_memory_size <= std_logic_vector(to_unsigned(log2(instr_memory_size), 5));
	control_register.running <= '1';

	-- "Watchdog" process, updates the deadline missed flag:
	watchdog: process(sample_clk, running, control_register)
	begin
		if rising_edge(sample_clk) then
			if control_register.running = '1' then
				control_register.deadline_missed <= '1';
			end if;
		end if;
	end process;

	-- Instruction memory:
	instruction_memory: memory
		generic map ( size => instr_memory_size, address_width => 16)
		port map(
			clk => memclk,
			write_address => instr_write_address,
			read_address => instr_read_address,
			write_data => instr_write_data,
			write_enable => instr_write_enable,
			read_data => instr_read_data
		);

	-- Instruction memory control signals:
	instr_write_address <= instr_address;
	instr_read_address <= instr_address when sample_clk = '1' else pc_value;
	-- TODO: Replace the others clause above with the address requested by the processor core.
	instr_data_out <= instr_read_data(15 downto 0);
	instr_write_data <= instr_data_in;

	-- Program counter adder
	pc_adder: adder
		port map(
			a => pc_value,
			b => x"0001",
			result => pc_inc_value,
			flags => open
		);

	-- Program counter
	pc: program_counter
		generic map (address_width => 16)
		port map(
			clk => clk, -- may not be neccessary
			reset => control_register.reset,
			address_in => pc_next_value,
			address_out => pc_value,
			pc_wr_enb => '0'
		);

	pc_next_value <= pc_inc_value;

end behaviour;
