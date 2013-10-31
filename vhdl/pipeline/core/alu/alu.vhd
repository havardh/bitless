-- ALU Toplevel Module

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.core_constants.all;

entity alu is
	port (
		-- CLK
		dsp_clk, cpu_clk 		: in std_logic;
		-- ALU input data:
		cpu_input_register_1 	: in std_logic_vector(15 downto 0);
		cpu_input_register_2 	: in std_logic_vector(15 downto 0);
		cpu_input_const 		: in std_logic_vector(15 downto 0);
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
			clk 	: in std_logic;
			result	: out std_logic_vector(15 downto 0);
			flags	: out alu_flags
		);
	end component;

	component FPU is
		port(
			a, b 		: in std_logic_vector(15 downto 0);
--			c, d 		: in --TODO, I have no idea
--			alu_op 		: in --TODO, I have no idea
			dsp_clk		: in std_logic;
			cpu_clk 	: in std_logic;
			result_1 	: out std_logic_vector(15 downto 0);
			result_2 	: out std_logic_vector(15 downto 0);
			flags 		: alu_flags
		);
	end component;

	--Adder signals
	signal adder_result : std_logic_vector(15 downto 0);
	signal adder_flags 	: alu_flags;
	signal adder_input_a	: std_logic_vector(15 downto 0);

	--Multiplier signals
	signal mul_result 	: std_logic_vector(15 downto 0);
	signal mul_flags  	: alu_flags;

	--FPU signals
	signal cfpu_result_1 	: std_logic_vector(15 downto 0);
	signal cfpu_result_2 	: std_logic_vector(15 downto 0);
	signal cfpu_flags 		: std_logic;
	signal cd_cat			: std_logic_vector(31 downto 0); --TODO, I have no idea
	signal C1,C2 			: std_logic_vector(15 downto 0); --TODO, I have no idea
--	signal cfpu_alu_op		: --TODO, I have no idea

	--Logic signal
	signal logic_result 	: std_logic_vector(15 downto 0);
	signal logic_flags		: alu_flag_select;

	--Result signals
	signal result_1_mux_output : std_logic_vector(15 downto 0);
	signal result_2_mux_output : std_logic_vector(15 downto 0);

	--Control signals
	signal sub_enable			: std_logic;
	signal alu_result_select_1  : alu_result_select;
	signal alu_result_select_2	: std_logic;
	signal alu_flag_select		: alu_flag_select;

begin
	add: adder
		port map (
			a 		=> adder_input_a,
			b 		=> cpu_input_register_2,
			c 		=> sub_enable,
			result 	=> adder_result,
			flags 	=> adder_flags
		);

	mul: multiplier
		port map (
			a 		=> cpu_input_register_1,
			b 		=> cpu_input_register_2,
			clk 	=> cpu_clk,
			result	=> mul_result,
			flags 	=> mul_flags
		);

	fpu_comp: FPU
		port map (
			a 			=> cpu_input_register_1, 
			b 			=> cpu_input_register_2,
			c 			=> C1,
			d 			=> C2,
			alu_op 		=> cfpu_alu_op,	
			dsp_clk		=> dsp_clk,	
			cpu_clk 	=> cpu_clk,
			result_1 	=> cfpu_result_1,
			result_2 	=> cfpu_result_2,
			flags 		=> cfpu_flags
		);


	adder_input_mux_a: process(sub_enable)
	begin
		if sub_enable = '1' then
			adder_input_a <= not cpu_input_register_1;
		else
			adder_input_a <= cpu_input_register_1;
		end if;
	end process adder_input_mux_a;

	result_mux_1: process(alu_result_select_1)
	begin
		case alu_result_select is
			when ALU_ADD_SELECT =>
				result_1_mux_output <= adder_result;
			when ALU_LOG_SELECT =>
				result_1_mux_output <= logic_result;
			when ALU_FPU_SELECT =>
				result_1_mux_output <= cfpu_result_1;
		end case;
	end process result_mux_1;

	result_mux_2: process(alu_result_select_2)
	begin
		if alu_result_select_2 = '1' then
			result_2_mux_output <= cfpu_result_2;
		else
			result_2_mux_output <= mul_result;
		end if;
	end process result_mux_2;

	flags_mux: process (alu_flag_select)
	begin
		case alu_flag_select is
			when ADD_FLAGS_SEL =>
				flags <= adder_flags;
			when MUL_FLAGS_SEL =>
				flags <= mul_flags;
			when FPU_FLAGS_SEL =>
				flags <= cfpu_flags;
			when LOG_FLAGS_SEL =>
				flags <= logic_flags;
		end case;
	end process flags_mux;

	--TODO, some kind of result mux concat thing

	alu_process: process(operation)
	begin
		logic_flags.negative <= '0';
		logic_flags.overflow <= '0';
		logic_flags.carry <= '0';
		logic_flags.zero <= '0';

		case operation is
			when ALU_ADD =>
				alu_result_select_1 <= ALU_ADD_SELECT;
				alu_result_select_2 <= '0';
				alu_flag_select		<= ADD_FLAGS_SEL;
			when ALU_AND =>
				logic_result <= cpu_input_register_1 and cpu_input_register_2;
				if (cpu_input_register_1 and cpu_input_register_2) = x"0000" then
					logic_flags.zero <= '1';
				end if;
				alu_flag_select		<= LOG_FLAGS_SEL;
				alu_result_select_1 <= ALU_LOG_SELECT;
				alu_result_select_2 <= '0';
			when ALU_NAND =>
				logic_result <= cpu_input_register_1 nand cpu_input_register_2;
				if (cpu_input_register_1 nand cpu_input_register_2) = x"0000" then
					logic_flags.zero <= '1';
				end if;
				alu_flag_select		<= LOG_FLAGS_SEL;
				alu_result_select_1 <= ALU_LOG_SELECT;
				alu_result_select_2 <= '0';
			when ALU_OR =>
				logic_result <= cpu_input_register_1 or cpu_input_register_2;
				if (cpu_input_register_1 or cpu_input_register_2) = x"0000" then
					logic_flags.zero <= '1';
				end if;
				alu_flag_select		<= LOG_FLAGS_SEL;
				alu_result_select_1 <= ALU_LOG_SELECT;
				alu_result_select_2 <= '0';
			when ALU_NOR =>
				logic_result <= cpu_input_register_1 nor cpu_input_register_2;
				if (cpu_input_register_1 nor cpu_input_register_2) = x"0000" then
					logic_flags.zero <= '1';
				end if;
				alu_flag_select		<= LOG_FLAGS_SEL;
				alu_result_select_1 <= ALU_LOG_SELECT;
				alu_result_select_2 <= '0';
			when ALU_XOR =>
				logic_result <= cpu_input_register_1 xor cpu_input_register_2;
				if (cpu_input_register_1 xor cpu_input_register_2) = x"0000" then
					logic_flags.zero <= '1';
				end if;
				alu_flag_select		<= LOG_FLAGS_SEL;
				alu_result_select_1 <= ALU_LOG_SELECT;
				alu_result_select_2 <= '0';
	--		when ALU_MOVE =>
	--			result <= cpu_input_register_1;
	--			if cpu_input_register_1 = x"0000" then
	--				flags.zero <= '1';
	--			end if;
	--		when ALU_MOVE_NEGATIVE =>
	--			result <= not cpu_input_register_1;
	--			if (not cpu_input_register_1) = x"0000" then
	--				flags.zero <= '1';
	--			end if;
		end case;
	end process alu_process;
end behaviour;

