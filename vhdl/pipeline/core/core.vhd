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
		instruction_data	: in std_logic_vector(15 downto 0);
		
		-- Connections to the constant memory controller:
		constant_addr		: out std_logic_vector(address_width - 1 downto 0);
		constant_data		: in  std_logic_vector(31 downto 0);

		-- Connections to the input buffer:
		input_read_addr		: out std_logic_vector(address_width - 1 downto 0);
		input_read_data		: in  std_logic_vector(31 downto 0);

		-- Connections to the output buffer:
		output_write_addr	: out std_logic_vector(address_width - 1 downto 0);
		output_write_data	: out std_logic_vector(31 downto 0);
		output_we			: out std_logic;
		
		output_read_address	: out std_logic_vector(address_width - 1 downto 0);
		output_read_data	: in  std_logic_vector(31 downto 0)
 	);
end entity;
--NAMING SCHEME FOR SIGNALS AND COMPONENTS
--All signals that function as registers for another stage should be prefixed with
--the stage they will be used in. 
--Components are prefixed with the stage they are in, when no prefix might be ambigous.
--
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
	
	component register_file is
		port(
			clk				: in std_logic;

			reg_1_address	: in std_logic_vector(4 downto 0);
			reg_2_address	: in std_logic_vector(4 downto 0);
			write_address	: in std_logic_vector(4 downto 0);

			data_in			: in std_logic_vector(31 downto 0);

			write_reg_enb	: in register_write_enable;

			reg_1_data		: out std_logic_vector(15 downto 0);
			reg_2_data		: out std_logic_vector(15 downto 0)
		);
	end component register_file;
	--Pipeline registers for stage id
	signal id_reg_data_1	: std_logic_vector(15 downto 0);
	signal id_reg_data_2	: std_logic_vector(15 downto 0);
	
	signal id_spec_addr			: std_logic_vector( 4 downto 0);
	signal id_reg_addr_1		: std_logic_vector( 4 downto 0);
	signal id_reg_addr_2		: std_logic_vector( 4 downto 0);
	signal id_reg_write_addr	: std_logic_vector( 4 downto 0);
	signal id_alu_op			: alu_operation;
	signal id_imm_slct			: std_logic;
	signal id_reg_we			: std_logic;
	signal id_reg_wb			: std_logic;
	signal id_reg_w_src			: std_logic_vector(1 downto 0);
	
		
--Stage 3 - Memory access / MEM
	component forwarding_unit is
		Port (
			wb_reg				: in STD_LOGIC_VECTOR(4 downto 0); 
			reg_addr_1			: in STD_LOGIC_VECTOR(4 downto 0); 
			reg_addr_2			: in STD_LOGIC_VECTOR(4 downto 0); 
			reg_write			: in STD_LOGIC;
			forward_1			: out STD_LOGIC;
			forward_2			: out STD_LOGIC
		);
	end component forwarding_unit;
	--Pipeline registers for stage EX
		--TODO
		
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

	--Pipeline registers for stage WB
	
	signal 
	
--Other

begin
	
--Pipeline stage 1 PC
	pc_incrementer : adder
	port map(
		a		=> pc_reg,
		b		=> '1',
		result	=> pc_inc
	);
	
	pc : process(clk)
	begin
		if rising_edge(clk) then
			if branch_enable = '1' then
				pc_reg <= branch_target;
			else
				pr_reg <= pc_inc;
			end if;
		end if;
	end process;
	
	instruction_address <= pc_reg;
	
--Pipeline stage 2 ID
	branch_target <= instruction_data(9 downto 0);
	
	control : control_unit
	port map(
		clk					=> clk,
		reset				=> reset,
		
		opt_code			=> instruction(15 downto 10),
		spec_reg_addr		=> id_spec_addr,
		imm_select	 		=> id_imm_slct,
		reg_write_e			=> id_reg_we,
		reg_b_wr			=> id_reg_wb,
		reg_write_source 	=> id_reg_src,
		output_write_enable => id_output_we,
		branch_enable		=> branch_enable
	);
	
	regfile : register_file
	port map(
		clk				=> clk,

		reg_1_address	=> instruction_data(9 downto 5),
		reg_2_address	=> instruction_data(4 downto 0),
		write_address	=> wb_reg_write_addr,

		data_in			=> wb_data,

		write_reg_enb	=> wb_reg_we,

		reg_1_data		=> mem_data_1,
		reg_2_data		=> mem_reg_data_2
	);
	
	--Pipeline registerz for signals
	id_mem_pipeline_regz : process(clk)
		if rising_edge(clk) then
			mem_alu_result_mux_control	<= id_alu_result_mux_control;
			
			mem_imm_data	<= instruction_data(13 downto 0);
			
			mem_reg_1_addr	<= instruction_data(9 downto 5);
			mem_reg_2_addr	<= instruction_data(4 downto 0);
			mem_reg_we		<= id_reg_we;
		end if;
	end process;
	
--Pipeline stage 3 MEM
	--TODO:
		--mux reg_1
		--mux reg_2
		--talk to mem
		--mux mem_result
		
	--Forwarding unit
	ex_forwarding_unit : forwarding_unit
	port map(
		wb_reg		=> wb_reg,
		reg_addr_1	=> ex_reg_1_addr,
		reg_addr_2	=> ex_reg_2_addr,
		reg_write	=> wb_reg_we,
		forward_1	=> alu_input_1_mux_control,
		forward_2	=> alu_input_2_mux_control
	);
	--stage 4 pipeline regz
	mem_ex_pipeline_regz : process(clk)
		if rising_edge(clk) then
			ex_register_1_data			<= mem_register_1_data;
			ex_register_2_data			<= mem_register_2_data;
			ex_alu_result_mux_control	<= mem_alu_result_mux_control;
			
			ex_mem_data		<= mem_result_mux_out;
			ex_imm_data		<= mem_imm_data;
			
			ex_reg_1_addr	<= mem_reg_1_addr;
			ex_reg_2_addr	<= mem_reg_2_addr;
			ex_reg_we		<= mem_reg_we;
		end if;
	end process;
		
--Pipeline stage 4 EX
	--ALU
	alu_input_1_mux : process(alu_input_1_mux_control)
		if alu_input_1_mux_control = '0' then
			alu_input_1_mux_out <= ex_register_1_data;
		else
			alu_input_1_mux_out <= wb_data;
		end if;
	end process;
	
	alu_input_2_mux : process(alu_input_2_mux_control)
		if alu_input_2_mux_control = '0' then
			alu_input_2_mux_out <= ex_register_2_data;
		else
			alu_input_2_mux_out <= wb_alu_mem_result;
		end if;
	end process;
	
	alu : alu
	port map(
		-- CLK
		dsp_clk					=> _,
		cpu_clk 				=> clk,
		-- ALU input data:
		cpu_input_register_1	=> alu_input_1_mux_out,
		cpu_input_register_2	=> alu_input_2_mux_out,
		cpu_input_const 		=> ex_mem_data,
		cpu_input_const_w		=> ex_constant_we,
		-- ALU control:
		operation 				=> ex_alu_op,
		-- ALU result data:
		result 					=> alu_result,
		flags  					=> alu_flags
	);
	
	alu_result_mux : process(ex_alu_result_mux_control)
		case ex_alu_result_mux_control
		when alu =>
			alu_result_mux_out <= alu_result;
		when mem =>
			alu_result_mux_out <= ex_mem_data;
		when imm => 
			alu_result_mux_out <= ex_imm_data;
		when others =>
		end case;
	end process;
	--Forwarding unit
	ex_forwarding_unit : forwarding_unit
	port map(
		wb_reg		=> wb_reg,
		reg_addr_1	=> ex_reg_1_addr,
		reg_addr_2	=> ex_reg_2_addr,
		reg_write	=> wb_reg_we,
		forward_1	=> alu_input_1_mux_control,
		forward_2	=> alu_input_2_mux_control
	);
	--stage 4 pipeline regz
	ex_wb_pipeline_regz : process(clk)
		if rising_edge(clk) then
			wb_reg		<= ex_reg_1_addr;
			wb_reg_we	<= ex_reg_we;
			wb_flags	<= alu_flags
			wb_data		<= alu_result_mux_out;
		end if;
	end process;

--TODO:
	--connect the rest (stage 5)

end behaviour;
