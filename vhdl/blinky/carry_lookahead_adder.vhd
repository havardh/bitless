-- 1-bit Carry Lookahead Adder Module
library ieee;
use ieee.std_logic_1164.all;

entity carry_lookahead_adder is
	port (
		a, b, c : in std_logic;
		g, p, s : out std_logic
	);
end carry_lookahead_adder;

architecture behaviour of carry_lookahead_adder is

begin
	g <= a and b;
	p <= a or b;
	s <= a xor b xor c;
end behaviour;

