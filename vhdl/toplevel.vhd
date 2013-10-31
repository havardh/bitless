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

		-- EBI interface lines:
		ebi_address : in    std_logic_vector(22 downto 0);	-- EBI address lines
		ebi_data		: inout std_logic_vector(15 downto 0); -- EBI data lines
		ebi_re		: in    std_logic;	-- EBI read enable (active low)
		ebi_we		: in    std_logic;	-- EBI write enable (active low)
		ebi_cs		: in    std_logic;	-- EBI chip select (active low)

		-- Miscellaneous lines:
		ctrl_bus				: inout std_logic_vector(2 downto 0); -- Control bus connected to the MCU
		led0, led1			: out std_logic; -- LEDs
		button0, button1	: in std_logic;  -- Buttons
		gpio_bus				: inout std_logic_vector(12 downto 0) -- GPIO bus, connected to a header
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
			memory_clock : out std_logic; -- Memory clock output, used for the memories
			dsp_clock    : out std_logic  -- DSP clock output, used for DSPs
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
	signal system_clk, memory_clk, sample_clk : std_logic;
	signal gated_system_clk : std_logic;
	signal ebi_ctrl_clk : std_logic;

	-- Inverted EBI CS signal:
	signal ebi_cs_inv : std_logic;

	-- Toplevel control register:
	signal control_register : toplevel_control_register;
begin
	-- Set up the clock controller:
	clk_ctrl: clock_controller
		port map (
			clk_in => fpga_clk,
			system_clock => gated_system_clk,
			memory_clock => memory_clk,
			dsp_clock => open
		);
	sample_clk <= ctrl_bus(0);

	-- FPGA clock gate:
	fpga_clock_gate: BUFGCE
		port map (
			I => gated_system_clk,
			O => system_clk,
			CE => control_register.master_enable
		);

	-- TODO: Switch gated_system_clk and system_clk, so the meaning is right

	-- Instantiate the EBI controller:
	ebi_ctrl: ebi_controller
		port map (
			clk => gated_system_clk,
			reset => control_register.ebi_controller_reset,
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

	-- Set up the control register:
	led0 <= control_register.led0;
	led1 <= control_register.led1;
	control_register.button0 <= button0;
	control_register.button1 <= button1;

	-- Read or write the master control register at address 0:
	control_reg_access: process(internal_bus_address, internal_bus_data_out, internal_bus_data_in,
		internal_bus_read, internal_bus_write, control_register)
	begin
		if rising_edge(internal_bus_write) then
			if internal_bus_address.toplevel = '1' then
				control_register.master_reset <= internal_bus_data_in(15);
				control_register.ebi_controller_reset <= internal_bus_data_in(14);
				control_register.led0 <= internal_bus_data_in(13);
				control_register.led1 <= internal_bus_data_in(12);
				control_register.master_enable <= internal_bus_data_in(0);
			end if;
		end if;

		if rising_edge(internal_bus_read) then
			if internal_bus_address.toplevel = '1' then
				internal_bus_data_out <= (
					13 => control_register.led0,
					12 => control_register.led1,
					11 => control_register.button0,
					10 => control_register.button1,
					3 => control_register.number_of_pipelines(2),
					2 => control_register.number_of_pipelines(1),
					1 => control_register.number_of_pipelines(0),
					0 => control_register.master_enable,
					others => '0'
				);
			else
				internal_bus_data_out <= internal_pipeline_data_output(to_integer(unsigned(internal_bus_address.pipeline)));
			end if;
		end if;
	end process;

	generate_pipelines:
		for i in 0 to NUMBER_OF_PIPELINES - 1 generate
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

end behaviour;
