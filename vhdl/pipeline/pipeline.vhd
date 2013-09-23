-- Pipeline module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.core_constants.all;
use work.internal_bus.all;

entity pipeline is
	generic (
		num_cores		 : natural := 4
	);

	port (
		clk			: in std_logic; -- Small cycle clock
		sample_clk	: in std_logic; -- Large cucle clock

		-- Address of the pipeline, two bit number:
		pipeline_address : in std_logic_vector(1 downto 0);

		-- Connections to the internal bus interface:
		int_address : in internal_address;
		int_data    : inout internal_data;
		int_re      : in std_logic; -- Read enable
		int_we      : in std_logic  -- Write enable
	);
end entity;

architecture behaviour of pipeline is

begin

	process(clk)
	begin
		if rising_edge(clk) then
			if int_address.pipeline = pipeline_address then
				-- Respond to internal bus request
			end if;
		end if;
	end process;

end behaviour;
