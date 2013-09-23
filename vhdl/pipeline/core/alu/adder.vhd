-- Full 16-bit adder module, yay!
library ieee;
use ieee.std_logic_1164.all;

entity adder is
	port (
		a, b : in std_logic_vector(15 downto 0);
		result : out std_logic_vector(15 downto 0);
		carry, overflow, zero : out std_logic
	);
end adder;

architecture behaviour of adder is
	component carry_lookahead_adder_4 is
		port (
			a, b : std_logic_vector(3 downto 0);
			c : in std_logic;
			g, p, c_out : out std_logic;
			result : out std_logic_vector(3 downto 0)
		);
	end component;

	component lookahead_carry_unit is
		port (
			p0, p4, p8, p12  : in  std_logic; -- Propagate inputs
			g0, g4, g8, g12  : in  std_logic; -- Generate inputs
			c0 : in std_logic; -- First carry input
			c4, c8, c12, c16 : out std_logic -- Carry outputs
		);
	end component;

	signal propagates : std_logic_vector(3 downto 0) := (others => '0');
	signal generates : std_logic_vector(3 downto 0) := (others => '0');
	signal carries : std_logic_vector(3 downto 0) := (others => '0');

begin
	carries(0) <= '0';

	lcu: lookahead_carry_unit
		port map(
			p0 => propagates(0),
			p4 => propagates(1),
			p8 => propagates(2),
			p12 => propagates(3),
			g0 => generates(0),
			g4 => generates(1),
			g8 => generates(2),
			g12 => generates(3),
			c0 => '0',
			c4 => carries(1),
			c8 => carries(2),
			c12 => carries(3),
			c16 => carry
		);

	generate_adders:
	for i in 0 to 3 generate
		adder_x: carry_lookahead_adder_4
			port map(
				a => a(((i + 1) * 4) - 1 downto i * 4),
				b => b(((i + 1) * 4) - 1 downto i * 4),
				result => result(((i + 1) * 4) - 1 downto i * 4),
				c => carries(i),
				p => propagates(i),
				g => generates(i)
			);
	end generate;
			

end behaviour;

