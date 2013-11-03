-- Toplevel processor core module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.core_constants.all;
use work.internal_bus.all;

entity core is
	generic(
		address_width : natural := 16
	);

	port(
		clk					: in std_logic; -- Small cycle clock signal
		memclk				: in std_logic; -- Memory clock signal
		sample_clk			: in std_logic; -- Reset signal, "large cycle" clock signal

		reset				: in std_logic; -- Resets the processor core

		-- Connections to the constant memory controller:
		constant_addr		: out std_logic_vector(address_width - 1 downto 0);
		constant_data		: in  std_logic_vector(31 downto 0);

		-- Connections to the input buffer:
		input_read_addr		: out std_logic_vector(address_width - 1 downto 0);
		input_read_data		: in  std_logic_vector(31 downto 0);
		input_re			: out std_logic;

		-- Connections to the output buffer:
		output_write_addr	: out std_logic_vector(address_width - 1 downto 0);
		output_write_data	: out std_logic_vector(31 downto 0);
		output_we			: out std_logic;
		
		output_read_address	: out std_logic_vector(address_width - 1 downto 0);
		output_read_data	: in  std_logic_vector(31 downto 0);
		output_re			: out std_logic
 	);
end entity;

architecture behaviour of core is

	--Stage 1 - PC
	component adder is
		port (
			a, b	: in	std_logic_vector(15 downto 0);
			result	: out	std_logic_vector(15 downto 0);
			flags	: out	alu_flags
		);
	end component;
	
	--Stage 2 - Control unit and register file
	component control_unit is
		port ( 	
			clk					: in	std_logic;
			reset				: in	std_logic;
			opt_code			: in	std_logic_vector (5 downto 0);
			spec_reg_addr		: out	std_logic_vector (4 downto 0);
			alu_op				: out	alu_operation;
			imm_select	 		: out	std_logic;
			reg_write_e			: out	std_logic;
			reg_b_wr			: out	std_logic;
			reg_write_source 	: out	std_logic_vector (1 downto 0);
			output_write_enable : out	std_logic;
			read_from_const_mem : out	std_logic;
			branch_enable		: out	std_logic;
			pc_write_enable 	: out	std_logic
		);
	end component;
	
	component register_file
	end component register_file;
	--Stage 3 - Memory access
	
	--Stage 4 - ALU
	component alu is
		port (
			-- CLK
			dsp_clk, cpu_clk 		: in	std_logic;
			-- ALU input data:
			cpu_input_register_1 	: in	std_logic_vector(15 downto 0);
			cpu_input_register_2 	: in	std_logic_vector(15 downto 0);
			cpu_input_const 		: in	std_logic_vector(15 downto 0);
			cpu_input_const_w		: in	std_logic;
			-- ALU control:
			operation 				: in	alu_operation;
			-- ALU result data:
			result 					: out	std_logic_vector(31 downto 0);
			flags  					: out	alu_flags
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
