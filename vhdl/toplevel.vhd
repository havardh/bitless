-- Superawesome Project Processor
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.core_constants.all;
use work.internal_bus.all;

entity toplevel is
	-- These ports connect to pins on the FPGA. These are set up using PlanAhead
	-- and stored in a .ucf file. This must be done sometime later.

	port (
		clk 			: in std_logic; -- "Small cycle" clock, i.e. processor core clock
		sample_clk  : in std_logic; -- "Large cycle" clock, i.e. sample clock

		-- EBI interface lines:
		ebi_address : in    std_logic_vector(27 downto 0);	-- EBI address lines
		ebi_data		: inout std_logic_vector(15 downto 0); -- EBI data lines
		ebi_re		: in    std_logic;	-- EBI read enable (active low)
		ebi_we		: in    std_logic;	-- EBI write enable (active low)
		ebi_cs		: in    std_logic		-- EBI chip select (active low)
	);
end entity;

architecture behaviour of toplevel is
	component pipeline is
		generic (
			num_cores		 : natural := 4;
			pipeline_number : unsigned
		);

		port (
			clk			: in std_logic; -- Small cycle clock
			sample_clk	: in std_logic; -- Large cucle clock

			-- Connections to the internal bus interface:
			int_address : in internal_address;
			int_data    : in internal_data;
			int_re      : in std_logic; -- Read enable
			int_we      : in std_logic  -- Write enable
		);
	end component;
	
	-- Internal bus signals:
	signal internal_bus_address : internal_address;
	signal internal_bus_data : internal_data;
	signal internal_bus_write, internal_bus_read : std_logic;

begin

	-- Set up the EBI controller.
	ebi_ctrl: ebi_controller
		port map (
			clk => clk,
			ebi_address => ebi_address,
			ebi_data => ebi_data,
			ebi_cs => ebi_cs,
			ebi_write_enable => ebi_we,
			ebi_read_enable => ebi_re,
			int_address => internal_bus_address,
			int_data => internal_bus_data,
			int_write_enable => internal_bus_write,
			int_read_enable => internal_bus_read
		);

	-- Create a predefined number of pipelines
--	generate_pipelines:
--	for pl in 0 to NUMBER_OF_PIPELINES - 1 generate
--		pipeline_x: pipeline
--			generic map (
--				pipeline_number => to_unsigned(pl, 1)
--			)
--			port map (
--				clk => clk,
--				sample_clk => sample_clk,
--				int_address => internal_bus_address,
--				int_data => internal_bus_data,
--				int_re => internal_bus_read,
--				int_we => internal_bus_write
--			);
--	end generate generate_pipelines;

end behaviour;
