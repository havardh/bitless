-- Lookahead Carry Unit for the Adder Module
library ieee;
use ieee.std_logic_1164.all;

entity lookahead_carry_unit is
	port (
		p0, p4, p8, p12  : in  std_logic; -- Propagate inputs
		g0, g4, g8, g12  : in  std_logic; -- Generate inputs
		c0 : in std_logic; -- First carry input
		c4, c8, c12, c16 : out std_logic -- Carry outputs
	);
end lookahead_carry_unit;

architecture Behavioral of lookahead_carry_unit is
	-- See Wikipedia for implementation details, at
	-- http://en.wikipedia.org/wiki/Lookahead_Carry_Unit
begin
	c4 <= g0 or (p0 and c0);
	c8 <= g4 or (g0 and p4) or (c0 and p0 and p4);
	c12 <= g8 or (g4 and p8) or (g0 and p4 and p8) or (c0 and p0 and p4 and p8);
	c16 <= g12 or (g8 and p12) or (g4 and p8 and p12)
		or (g0 and p4 and p8 and p12) or (c0 and p4 and p8 and p12);
end Behavioral;

