-- Testbench for the 4-bit carry lookahead adder
library ieee;
use ieee.std_logic_1164.all;

entity tb_carry_lookahead_adder_4 is
end tb_carry_lookahead_adder_4;

architecture behaviour of tb_carry_lookahead_adder_4 is
	component carry_lookahead_adder_4 is
		port (
			a, b : std_logic_vector(3 downto 0);
			c : in std_logic;
			g, p, c_out : out std_logic;
			result : out std_logic_vector(3 downto 0)
		);
	end component;

	-- Inputs:
	signal a, b : std_logic_vector(3 downto 0) := (others => '0');
	signal c : std_logic := '0';

	-- Outputs:
	signal g, p, c_out : std_logic;
	signal result : std_logic_vector(3 downto 0);
begin
	uut: carry_lookahead_adder_4
		port map(
			a => a,
			b => b,
			c => c,
			g => g,
			p => p,
			c_out => c_out,
			result => result
		);

	stimulus_process: process
	begin
		wait for 100 ns;
	
		a <= b"0001";
		b <= b"0010";
		wait for 10 ns;
		assert result = b"0011" report "Incorrect result for 0b0001 + 0b0010";

		a <= b"1111";
		b <= b"0001";
		wait for 10 ns;

		wait;
	end process;
end architecture;
