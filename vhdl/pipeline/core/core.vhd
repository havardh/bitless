-- Toplevel processor core module

library ieee;
use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

library work;
use work.core_constants.all;
use work.internal_bus.all;

entity core is
	generic(
		address_width		: natural := 16
	);

	port(
		clk					: in std_logic; -- Small cycle clock signal
		memclk				: in std_logic; -- Memory clock signal
		sample_clk			: in std_logic; -- Reset signal, "large cycle" clock signal

		reset				: in std_logic; -- Resets the processor core
		
		-- Connection to instruction memory:
		instruction_address	: out std_logic_vector(address_width - 1 downto 0);
		instruction_data	: in std_logic_vector(31 downto 0);
		
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
	--Pipeline registers for stage 1
	signal pc_reg			: std_logic_vector(15 downto 0);
	signal pc_inc			: std_logic_vector(15 downto 0);
	signal pc_we			: std_logic;
	
	signal branch_enable	: std_logic;
	signal branch_val		: std_logic_vector(15 downto 0);
	
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
		port(
			clk				: in std_logic;

			reg_1_address	: in std_logic_vector(4 downto 0);
			reg_2_address	: in std_logic_vector(4 downto 0);
			write_address	: in std_logic_vector(4 downto 0);

			data_in			: in std_logic_vector(31 downto 0);

			write_reg_enb	: in register_write_enable;

			reg_1_data		: out std_logic_vector(15 downto 0);
			reg_2_data		: out std_logic_vector(15 downto 0);
		);
	end component register_file;
	--Pipeline registers for stage 2
	signal reg_out_data_1	: std_logic_vector(15 downto 0);
	signal reg_out_data_2	: std_logic_vector(15 downto 0);
	
	signal spec_addr		: std_logic_vector( 4 downto 0);
	signal reg_addr_1		: std_logic_vector( 4 downto 0);
	signal reg_addr_2		: std_logic_vector( 4 downto 0);
	signal alu_op			: alu_operation;
	signal imm_slct			: std_logic;
	signal reg_we			: std_logic;
	signal reg_wb			: std_logic;
	signal reg_w_src		: std_logic_vector(1 downto 0);
	
		
--Stage 3 - Memory access
	component forwarding_unit is
	end component;
	--Pipeline registers for stage 3
		
		
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
	--Pipeline registers for stage 4
	
	
--Other

begin
	
	--Pipeline stage 1
	pc_incrementer : adder
	port map(
		a		=> pc_reg,
		b		=> '1',
		result	=> pc_inc
	);
	
	pc : process(clk)
	begin
		if rising_edge(pc_we) then
			if branch_enable = '1' then
				pc_reg <= branch_val;
			else
				pr_reg <= pc_inc;
			end if;
		end if;
	end process;
	
	instruction_address <= pc_reg;
	--Pipeline stage 2
	control : control_unit
	port map(
		
	--Pipeline stage 3
	
	--Pipeline stage 4
	

end behaviour;
