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
		ebi_address : in    std_logic_vector(22 downto 0);	-- EBI address lines
		ebi_data		: inout std_logic_vector(15 downto 0); -- EBI data lines
		ebi_re		: in    std_logic;	-- EBI read enable (active low)
		ebi_we		: in    std_logic;	-- EBI write enable (active low)
		ebi_cs		: in    std_logic;	-- EBI chip select (active low)

		-- Miscellaneous lines:
		ctrl_bus		: inout std_logic_vector(2 downto 0);
		gpio_bus		: in std_logic_vector(15 downto 0) -- Perhaps inout? Ask the PCB group.
	);
end entity;

architecture behaviour of toplevel is
	component pipeline is
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
	signal internal_bus_data_out, internal_bus_data_in : internal_data;
	signal internal_bus_write, internal_bus_read : std_logic;

	-- Internal bus output from pipelines:
	type internal_pipeline_data_array is array(0 to NUMBER_OF_PIPELINES) of internal_data;
	signal internal_pipeline_data_output : internal_pipeline_data_array;

	-- Internal FPGA clocks:
	signal system_clk, memory_clk : std_logic;
	signal ebi_ctrl_clk : std_logic;
begin
	-- Set up the clock controller:
	clk_ctrl: clock_controller
		port map (
			clk_in => fpga_clk,
			system_clock => system_clk,
			memory_clock => memory_clk
		);

	-- EBI controller clock gate, disable the EBI controller clock
	-- when the chip select is disabled. This saves power, at least
	-- in theory:
	ebi_ctrl_clk <= system_clk when ebi_cs = '0' else '0';

	-- Instantiate the EBI controller:
	ebi_ctrl: ebi_controller
		port map (
			clk => ebi_ctrl_clk,
			reset => '0',
			ebi_address => ebi_address,
			ebi_data => ebi_data,
			ebi_cs => ebi_cs,
			ebi_write_enable => ebi_we,
			ebi_read_enable => ebi_re,
			int_address => internal_bus_address,
			int_data_out => internal_bus_data_out,
			int_data_in => internal_bus_data_in,
			int_write_enable => internal_bus_write,
			int_read_enable => internal_bus_read
		);

	generate_pipelines:
		for i in 0 to NUMBER_OF_PIPELINES generate
			pipeline_x: pipeline
				port map (
					clk => system_clk,
					sample_clk => sample_clk,
					memory_clk => memory_clk,
					pipeline_address => make_pipeline_address(i),
					int_address => internal_bus_address,
					int_data_in => internal_bus_data_in,
					int_data_out => internal_pipeline_data_output(i),
					int_re => internal_bus_read,
					int_we => internal_bus_write
				);
		end generate;

		internal_bus_data_out <= internal_pipeline_data_output(to_integer(unsigned(internal_bus_address.pipeline)));

end behaviour;
