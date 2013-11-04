-- ALU Toplevel Module

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

library work;
use work.core_constants.all;


entity alu is
	port (
		-- CLK
		dsp_clk, cpu_clk 		: in std_logic;
		-- ALU input data:
		cpu_input_register_1 	: in std_logic_vector(15 downto 0);
		cpu_input_register_2 	: in std_logic_vector(15 downto 0);
		cpu_input_const 			: in std_logic_vector(31 downto 0);
		cpu_input_const_w			: in std_logic;
		-- ALU control:
		operation 				: in alu_operation;
		-- ALU result data:
		result 					: out std_logic_vector(31 downto 0);
		flags  					: out alu_flags
	);
end alu;

architecture behaviour of alu is

	component adder is
		port (
			a, b	: in std_logic_vector(15 downto 0);
			c 		: in std_logic;
			result 	: out std_logic_vector(15 downto 0);
			flags  	: out alu_flags
		);
	end component;

	component multiplier is
		port (
			a, b 	: in std_logic_vector(15 downto 0);
			p	: out std_logic_vector(31 downto 0)
		);
	end component;

	component FPU is
		port (
		a, b, c, d			: in	std_logic_vector(15 downto 0);
		result, result_2	: out	std_logic_vector(15 downto 0);
		aluop_in			: in	alu_operation;
		flags				: out	alu_flags;
		cpu_clk, alu_clk 	: in	std_logic
	);
	end component;
	

	--Adder signals
	signal adder_result : std_logic_vector(15 downto 0);
	signal adder_flags 	: alu_flags;
	signal adder_input_b	: std_logic_vector(15 downto 0);

	--Multiplier signals
	signal mul_result 	: std_logic_vector(31 downto 0);

	--FPU signals
	signal cfpu_result_1 	: std_logic_vector(15 downto 0);
	signal cfpu_result_2 	: std_logic_vector(15 downto 0);
	signal cfpu_flags 		: alu_flags;

	--Logic signal
	signal logic_result 	: std_logic_vector(15 downto 0);
	signal logic_flags		: alu_flags;
	
	--Constant registers
	signal C1,C2 				: std_logic_vector(15 downto 0); 
	
	--Control signals
	signal sub_enable					: std_logic;
	signal alu_result_select  		: alu_result_select;

begin
	add: adder
		port map (
			a 		=> cpu_input_register_1,
			b 		=> adder_input_b,
			c 		=> sub_enable,
			result 	=> adder_result,
			flags 	=> adder_flags
		);

	mul: multiplier
		port map (
			a 		=> cpu_input_register_1,
			b 		=> cpu_input_register_2,
			p	   =>  mul_result
		);

	fpu_comp: FPU
		port map (
			a 			=> cpu_input_register_1, 
			b 			=> cpu_input_register_2,
			c 			=> C1,
			d 			=> C2,
			aluop_in 		=> operation,	
			alu_clk		=> dsp_clk,	
			cpu_clk 		=> cpu_clk,
			result 	=> cfpu_result_1,
			result_2 	=> cfpu_result_2,
			flags 		=> cfpu_flags
		);

	constant_register_update: process(cpu_input_const_w)
	begin
		if rising_edge(cpu_clk) then
			if cpu_input_const_w = '1' then
				C1 <=	cpu_input_const(15 downto 0);
				C2 <=	cpu_input_const(31 downto 16);
			end if;
		end if;
	end process constant_register_update;

	adder_input_mux_b: process(sub_enable, cpu_input_register_2)
	begin
		if sub_enable = '1' then
			adder_input_b <= not cpu_input_register_2;
		else
			adder_input_b <= cpu_input_register_2;
		end if;
	end process adder_input_mux_b;

	
	result_mux: process(alu_result_select, adder_result, adder_flags, logic_result, logic_flags, mul_result, cfpu_result_1, cfpu_result_2, cfpu_flags)
	begin
		case alu_result_select is
			when ALU_ADD_SELECT =>
				result <= sxt(adder_result, 32);
				flags <= adder_flags;
			when ALU_LOG_SELECT =>
				result <= sxt(logic_result, 32);
				flags <= logic_flags;
			when ALU_MUL_SELECT =>
				result <= mul_result;
			when ALU_FPU_SELECT =>
				result<= cfpu_result_1&cfpu_result_2;
				flags <= cfpu_flags;
		end case;
	end process result_mux;
	
	logic_flags.negative <= logic_result(15);
	logic_flags.carry 	<= '0';
	logic_flags.overflow <= '0';
	logic_flags.zero 		<= '1' when logic_result = x"0000" else '0';
	
	--if logic_result(15) = '1' then
	--				logic_flags.negative <= '1';
	--			end if;

	--if (cpu_input_register_1 or cpu_input_register_2) = x"0000" then
	--				logic_flags.zero <= '1';
	--			end if;

	alu_process: process(operation,cpu_input_register_1, cpu_input_register_2)
	begin
	
		case operation is
			when ALU_ADD =>
				alu_result_select <= ALU_ADD_SELECT;
				sub_enable	<= '0';
			
			when ALU_SUB =>
				alu_result_select <= ALU_ADD_SELECT;
				sub_enable	<= '1';
				
			when ALU_MUL =>
				alu_result_select <= ALU_MUL_SELECT;
				
			when ALU_OR =>
				logic_result <= cpu_input_register_1 or cpu_input_register_2;
				alu_result_select <= ALU_LOG_SELECT;
			
			when ALU_AND =>
				logic_result <= cpu_input_register_1 and cpu_input_register_2;
				alu_result_select <= ALU_LOG_SELECT;
			
			when ALU_NAND =>
				logic_result <= cpu_input_register_1 nand cpu_input_register_2;
				alu_result_select <= ALU_LOG_SELECT;
			
			when ALU_NOR =>
				logic_result <= cpu_input_register_1 nor cpu_input_register_2;
				alu_result_select <= ALU_LOG_SELECT;
			
			when ALU_XOR =>
				logic_result <= cpu_input_register_1 xor cpu_input_register_2;
				alu_result_select <= ALU_LOG_SELECT;
			
			when ALU_MOVE =>
				logic_result <= cpu_input_register_1;
				alu_result_select <= ALU_LOG_SELECT;
			
			when ALU_MOVE_NEGATIVE =>
				logic_result <= not cpu_input_register_1;
				alu_result_select <= ALU_LOG_SELECT;
			
			when others =>
		end case;
	end process alu_process;
end behaviour;

