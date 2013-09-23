-- Adder testbench
library ieee;
use ieee.std_logic_1164.all;

ENTITY tb_adder IS
END tb_adder;

architecture behaviour of tb_adder is
	component adder is
		port (
			a, b : in std_logic_vector(15 downto 0);
			result : out std_logic_vector(15 downto 0);
			carry, overflow, zero : out std_logic
		);
	end component;

	-- Inputs:
	signal a, b : std_logic_vector(15 downto 0) := (others => '0');
	-- Outputs:
	signal result : std_logic_vector(15 downto 0);
	signal carry, overflow, zero : std_logic;
begin
	uut: adder
		port map(
			a => a,
			b => b,
			result => result,
			carry => carry,
			overflow => overflow,
			zero => zero
		);

	stimulus_process: process
	begin
		wait for 100 ns;

		a <= x"0001";
		b <= x"0001";
		wait for 10 ns;
		assert result = x"0002" report "Result of 1 + 1 is not 2!";

		a <= x"ffff";
		b <= x"0001";
		wait for 10 ns;
		assert result = x"0000" report "Result of 0xffff + 1 is not 0!";
		assert carry = '1' report "Result of 0xffff + 1 does not give carry!";

		wait;
	end process;
end;
