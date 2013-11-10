-- Adder testbench
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.core_constants.all;

ENTITY tb_adder IS
END tb_adder;

architecture behaviour of tb_adder is
	component adder is
		port (
			a, b   : in std_logic_vector(15 downto 0);
			c      : in  std_logic;
			result : out std_logic_vector(15 downto 0);
			flags  : out alu_flags
		);
	end component;

	-- Inputs:
	signal a, b : std_logic_vector(15 downto 0) := (others => '0');
	signal c : std_logic := '0';
	-- Outputs:
	signal result : std_logic_vector(15 downto 0);
	signal flags : alu_flags;
begin
	uut: adder
		port map(
			a => a,
			b => b,
			c => c,
			result => result,
			flags => flags
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
		assert flags.carry = '1' report "Result of 0xffff + 1 does not give carry!";

		a <= x"0000";
		b <= x"0200";
		wait for 10 ns;
		assert result = x"0200" report "Result of 0 + 0x200 is not 0x200!";

		wait;
	end process;
end;
