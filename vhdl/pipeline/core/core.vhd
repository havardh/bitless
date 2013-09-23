library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all; -- Why do we need typecasts?

library work;
use work.core_constants.all;

entity core is
	-- Generics
	generic(
		instruction_bus_width 	: natural := 16;
		inpt_address_width 		: natural := 12;
		outpt_address_width		: natural := 12;
		inpt_data_width 			: natural := 32;
		outpt_data_width 			: natural := 32
	);
	-- Ports
	port(
		clk 				: in std_logic;
		sample_clk 		: in std_logic
 	);
end entity;

architecture behaviour of core is
	-- Components
	
begin
	-- Instantiations
end behaviour;
