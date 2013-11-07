----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:59:59 10/15/2013 
-- Design Name: 
-- Module Name:    alu_cfpu - Behavioural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;

library work;
use work.core_constants.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--input values are two complex numbers (a+ib), (c+id).
entity fpu is
	port (
		a, b, c, d			: in	std_logic_vector(15 downto 0);
		result, result_2	: out	std_logic_vector(15 downto 0);
		aluop_in			: in	alu_operation;
		flags				: out	alu_flags;
		cpu_clk, alu_clk 	: in	std_logic
	);
end fpu;

architecture behaviour of fpu is
	component multiply
		port(
			a				: in std_logic_vector(15 downto 0);
			b				: in std_logic_vector(15 downto 0);
			clk				: in std_logic;
			result			: out std_logic_vector(15 downto 0);
			underflow		: out std_logic;
			overflow		: out std_logic
		);
	end component;
	
	component fp_addsub
		port (
			a				: in	std_logic_vector(15 downto 0);
			b				: in	std_logic_vector(15 downto 0);
			operation	: in	std_logic_vector(5 downto 0);
			result		: out	std_logic_vector(15 downto 0);
			underflow	: out	std_logic;
			overflow		: out	std_logic
		);
	end component;
	
	signal mul_in_a, mul_in_b, mul_result, addsub_in_a, addsub_in_b, addsub_result : std_logic_vector(15 downto 0);
	signal addsub_op : std_logic_vector(5 downto 0);
begin
	fp_multiply: multiply
		port map(
			a					=> mul_in_a,
			b					=> mul_in_b,
			result			=> mul_result,
			underflow		=> open,
			overflow			=> flags.overflow,
			clk				=> cpu_clk
		);
	addsub: fp_addsub
		port map(
			a			=> addsub_in_a,
			b			=> addsub_in_b,
			operation	=> addsub_op,
			result		=> addsub_result,
			underflow	=> open,
			overflow	=> flags.overflow
		);
	
	work: process(aluop_in)
	begin
		case aluop_in is
			when fp_mul =>
				mul_in_a	<=	a;
				mul_in_b	<=	b;
				result		<=	mul_result;
				
			when fp_add =>
				addsub_in_a	<=	a;
				addsub_in_b	<=	b;
				result		<=	addsub_result;
				addsub_op	<= "000000";
				
			when fp_sub =>
				addsub_in_a	<=	a;
				addsub_in_b	<=	b;
				result		<=	addsub_result;
				addsub_op	<= "000001";
				
			when fp_mac =>
				mul_in_a	<=	a;
				mul_in_b	<=	c;
				
				addsub_in_a	<=	mul_result;
				addsub_in_b	<=	b;
				
				addsub_op	<= "000000";
				result		<=	addsub_result;
				
			when fp_mas =>
				mul_in_a	<=	a;
				mul_in_b	<=	c;
				
				addsub_in_a	<=	b;
				addsub_in_b	<=	mul_result;
				
				addsub_op	<= "000001";
				result		<=	addsub_result;
			when others =>	
				
		end case;
	end process;
end behaviour;