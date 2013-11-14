library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.core_constants.all;

entity fpu is
	port (
		a, b, c, d			: in	std_logic_vector(15 downto 0);
		aluop_in			: in	alu_operation;
		result, result_2	: out	std_logic_vector(15 downto 0);
		flags				: out	alu_flags
	);
end fpu;

architecture behaviour of fpu is

	component fp_multiply
		port(
			a			: in std_logic_vector(15 downto 0);
			b			: in std_logic_vector(15 downto 0);
			result		: out std_logic_vector(15 downto 0);
			underflow	: out std_logic;
			overflow	: out std_logic
		);
	end component;
	signal fp_mul_data_in_1, fp_mul_data_in_2, fp_mul_result_out : std_logic_vector(15 downto 0);
	signal fp_mul_flag_underflow, fp_mul_flag_overflow : std_logic;
	
	component fp_addsub
		port (
			a			: in	std_logic_vector(15 downto 0);
			b			: in	std_logic_vector(15 downto 0);
			operation	: in	std_logic_vector(5 downto 0);
			result		: out	std_logic_vector(15 downto 0);
			underflow	: out	std_logic;
			overflow	: out	std_logic
		);
	end component;
	signal fp_addsub_data_in_1, fp_addsub_data_in_2, fp_addsub_result_out : std_logic_vector(15 downto 0);
	signal fp_addsub_operation : std_logic_vector(5 downto 0);
	signal fp_addsub_flag_underflow, fp_addsub_flag_overflow : std_logic;
	
	--control signals
--	signal mul_select : std_logic_vector(1 downto 0);
--	signal add_select : std_logic_vector(1 downto 0);
	
begin
	floating_point_multiplier : fp_multiply
		port map(
			a			=> fp_mul_data_in_1,
			b			=> fp_mul_data_in_2,
			result		=> fp_mul_result_out,
			underflow	=> fp_mul_flag_underflow,
			overflow	=> fp_mul_flag_overflow
		);
	
	floating_point_addsub : fp_addsub
		port map(
			a			=> fp_addsub_data_in_1,
			b			=> fp_addsub_data_in_2,
			operation	=> fp_addsub_operation,
			result		=> fp_addsub_result_out,
			underflow	=> fp_addsub_flag_underflow,
			overflow	=> fp_addsub_flag_overflow
		);
	
	result_2 <= (others => '0');
	
	fpu_ctrl : process(aluop_in, a, b, c, d, fp_mul_flag_overflow, fp_addsub_flag_overflow, fp_mul_result_out, fp_addsub_result_out)
	begin
		case aluop_in is
			when fp_mul =>--FLOATING POINT MULTIPLICATION
				fp_mul_data_in_1 <= a;
				fp_mul_data_in_2 <= b;
				fp_addsub_operation <= "000000";
				
				flags <= ('0', '0', fp_mul_flag_overflow, '0');
				result <= fp_mul_result_out;
				--
				fp_addsub_data_in_1 <= (others => '0');
				fp_addsub_data_in_2 <= (others => '0');
				
			when fp_add =>--FLOATING POINT ADDITION
				fp_addsub_data_in_1 <= a;
				fp_addsub_data_in_2 <= b;
				fp_addsub_operation <= "000000";
				
				flags <= ('0', '0', fp_addsub_flag_overflow, '0');
				result <= fp_addsub_result_out;
				--
				fp_mul_data_in_1 <= (others => '0');
				fp_mul_data_in_2 <= (others => '0');
				
			when fp_sub =>--FLOATING POINT SUBTRACTION
				fp_addsub_data_in_1 <= a;
				fp_addsub_data_in_2 <= b;
				fp_addsub_operation <= "000001";
				
				flags <= ('0', '0', fp_addsub_flag_overflow, '0');
				result <= fp_addsub_result_out;
				--
				fp_mul_data_in_1 <= (others => '0');
				fp_mul_data_in_2 <= (others => '0');
				
			when fp_mac =>--FLOATING POINT MULTIPLY AND ACCUMULATE B += A*C
				fp_mul_data_in_1 <= a;
				fp_mul_data_in_2 <= c;
				
				fp_addsub_data_in_1 <= b;
				fp_addsub_data_in_2 <= fp_mul_result_out;
				fp_addsub_operation <= "000000";
				
				flags <= ('0', '0', fp_mul_flag_overflow or fp_addsub_flag_overflow, '0');
				result <= fp_addsub_result_out;
				
			when fp_mad =>--FLOATING POINT MULTIPLY AND ACCUMULATE A += B*D
				fp_mul_data_in_1 <= d;
				fp_mul_data_in_2 <= b;
				
				fp_addsub_data_in_1 <= a;
				fp_addsub_data_in_2 <= fp_mul_result_out;
				fp_addsub_operation <= "000000";
				
				flags <= ('0', '0', fp_mul_flag_overflow or fp_addsub_flag_overflow, '0');
				result <= fp_addsub_result_out;
				
			when fp_msc =>--FLOATING POINT MULTIPLY AND SUBTRACT B -= A*C
				fp_mul_data_in_1 <= a;
				fp_mul_data_in_2 <= c;
				
				fp_addsub_data_in_1 <= b;
				fp_addsub_data_in_2 <= fp_mul_result_out;
				fp_addsub_operation <= "000001";
				
				flags <= ('0', '0', fp_mul_flag_overflow or fp_addsub_flag_overflow, '0');
				result <= fp_addsub_result_out;
				
			when fp_msd =>--FLOATING POINT MULTIPLY AND SUBTRACT A -= B*D
				fp_mul_data_in_1 <= d;
				fp_mul_data_in_2 <= b;
				
				fp_addsub_data_in_1 <= a;
				fp_addsub_data_in_2 <= fp_mul_result_out;
				fp_addsub_operation <= "000001";
				
				flags <= ('0', '0', fp_mul_flag_overflow or fp_addsub_flag_overflow, '0');
				result <= fp_addsub_result_out;
				
			when others =>--NOT FLOATING POINT OPERATION. BORING...
				--
				fp_mul_data_in_1 <= a;--(others => '0');
				fp_mul_data_in_2 <= b;--(others => '0');
				fp_addsub_data_in_1 <= a;--(others => '0');
				fp_addsub_data_in_2 <= b;--(others => '0');
				fp_addsub_operation <= "000000";
				
				flags <= ('0', '0', '0', '0');
				result <= a;--(others => '0');
		end case;
	end process;
	
--	mux_mul_select : process(mul_select)
--	begin
--		if mul_select(0) = '0' then
--			fp_mul_data_in_1	<= a;
--		else
--			fp_mul_data_in_1	<= d;
--		end if;
--		
--		if mul_select(1) = '0' then
--			fp_mul_data_in_2	<= b;
--		else
--			fp_mul_data_in_2	<= c;
--		end if;
--	end process;
--	
--	mux_add_select : process(add_select)
--	begin
--		if add_select(0) = '0' then
--			fp_addsub_data_in_1	<= a;
--		else
--			fp_addsub_data_in_1	<= fp_mul_result_out;
--		end if;
--		
--		if add_select(1) = '0' then
--			fp_addsub_data_in_2	<= b;
--		else
--			fp_addsub_data_in_2	<= fp_mul_result_out;
--		end if;
--	end process;
end behaviour;