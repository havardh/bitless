-- 4-bit Carry Lookahead Adder
library ieee;
use ieee.std_logic_1164.all;

entity carry_lookahead_adder_4 is
	port (
		a, b : std_logic_vector(3 downto 0);
		c : in std_logic;
		g, p, c_out : out std_logic;
		result : out std_logic_vector(3 downto 0)
	);
end carry_lookahead_adder_4;

architecture Behavioral of carry_lookahead_adder_4 is
	component carry_lookahead_adder is
		port (
			a, b, c : in std_logic;
			g, p, s : out std_logic
		);
	end component;

	type propagate_array is array(3 downto 0) of std_logic;
	type generate_array is array(3 downto 0) of std_logic;
	type carry_array is array(3 downto 0) of std_logic;

	signal propagate_lines : propagate_array;
	signal generate_lines : generate_array;
	signal carry_lines : carry_array;
begin
	generate_carries:
	for i in 1 to 3 generate
		carry_lines(i) <= generate_lines(i - 1) or (propagate_lines(i - 1) and carry_lines(i - 1));
	end generate;

	carry_lines(0) <= c;

	c_out <= generate_lines(3) or (propagate_lines(3) and carry_lines(3));
	p <= propagate_lines(0) and propagate_lines(1) and propagate_lines(2) and propagate_lines(3);
	g <= generate_lines(3) or (generate_lines(2) and propagate_lines(3))
		or (generate_lines(1) and propagate_lines(3) and propagate_lines(2))
		or (generate_lines(0) and propagate_lines(3) and propagate_lines(2) and propagate_lines(1));

	first_adder: carry_lookahead_adder
		port map (
			a => a(0),
			b => b(0),
			c => c,
			g => generate_lines(0),
			p => propagate_lines(0),
			s => result(0)
		);

	generate_adders:
	for i in 1 to 3 generate
		adder_x: carry_lookahead_adder
			port map (
				a => a(i),
				b => b(i),
				c => carry_lines(i),
				g => generate_lines(i),
				p => propagate_lines(i),
				s => result(i)
			);
	end generate generate_adders;

end Behavioral;

