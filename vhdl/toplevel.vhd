-- Superawesome Project Processor
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.core_constants.all;
use work.internal_bus.all;

entity toplevel is
	-- These ports connect to pins on the FPGA. These are set up using PlanAhead
	-- and stored in a .ucf file. This must be done sometime later.

	port (
		fpga_clk 	: in std_logic; -- FPGA clock, 60 MHz input clock
		sample_clk  : in std_logic; -- "Large cycle" clock, i.e. sample clock

		-- EBI interface lines:
		ebi_address : in    std_logic_vector(24 downto 0);	-- EBI address lines
		ebi_data		: inout std_logic_vector(15 downto 0); -- EBI data lines
		ebi_re		: in    std_logic;	-- EBI read enable (active low)
		ebi_we		: in    std_logic;	-- EBI write enable (active low)
		ebi_cs		: in    std_logic		-- EBI chip select (active low)
	);
end entity;

architecture behaviour of toplevel is
	component pipeline is
		generic (
			num_cores : natural := 4
		);

		port (
			clk			: in std_logic; -- Small cycle clock
			sample_clk	: in std_logic; -- Large cycle clock
			memory_clk  : in std_logic; -- Memory clock

			-- Address of the pipeline, two bit number:
			pipeline_address : in std_logic_vector(1 downto 0);

			-- Connections to the internal bus interface:
			int_address  : in  internal_address;
			int_data_in  : in  internal_data;
			int_data_out : out internal_data;
			int_re       : in  std_logic; -- Read enable
			int_we       : in  std_logic  -- Write enable
		);
	end component;

	component clock_controller is
		port(
			clk_in       : in std_logic;  -- FPGA main clock input
			system_clock : out std_logic; -- System clock output, used for the processor cores
			memory_clock : out std_logic  -- Memory clock output, used for the memories
		);
	end component;

	-- Internal bus signals:
	signal internal_bus_address : internal_address;
	signal internal_bus_data_in, internal_bus_data_out : internal_data;
	signal internal_bus_write, internal_bus_read : std_logic;

	-- Internal FPGA clocks:
	signal system_clk, memory_clk : std_logic;

begin
	-- Set up the clock controller:
	clk_ctrl: clock_controller
		port map (
			clk_in => fpga_clk,
			system_clock => system_clk,
			memory_clock => memory_clk
		);

	-- Set up the EBI controller.
	ebi_ctrl: ebi_controller
		port map (
			clk => system_clk,
			ebi_address => ebi_address,
			ebi_data => ebi_data,
			ebi_cs => ebi_cs,
			ebi_write_enable => ebi_we,
			ebi_read_enable => ebi_re,
			int_address => internal_bus_address,
			int_data_out => internal_bus_data_in, -- The following two lines are correct
			int_data_in => internal_bus_data_out,
			int_write_enable => internal_bus_write,
			int_read_enable => internal_bus_read
		);

		test_pipeline: pipeline
			port map (
				clk => system_clk,
				sample_clk => sample_clk,
				memory_clk => memory_clk,
				pipeline_address => make_pipeline_address(0),
				int_address => internal_bus_address,
				int_data_in => internal_bus_data_in,
				int_data_out => internal_bus_data_out,
				int_re => internal_bus_read,
				int_we => internal_bus_write
			);

end behaviour;
