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
	-- and stored in a .ucf file.

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

	-- Blink controller for testmode:
	component blink_controller is
		port(
			system_clk : in std_logic; -- System clock input (60MHz)
			enable, reset : in std_logic; -- Blink controller enable and reset signals
			led0_blink, led1_blink : out std_logic -- Output signal for the LEDs
		);
	end component;

	-- Main pipeline component:
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

	-- Clock controller generating clocks of various frequencies:
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
	signal ebi_ctrl_clk : std_logic;

	-- Inverted EBI CS signal:
	signal ebi_cs_inv : std_logic;

	-- Blinking LEDS:
	signal blinking_led0, blinking_led1 : std_logic;

	-- Toplevel control register:
	signal control_register : toplevel_control_register := (reset => '0', led0 => '0', led1 => '0', blinkmode => '1',
		number_of_pipelines => std_logic_vector(to_unsigned(NUMBER_OF_PIPELINES, 3)), button0 => '0', button1 => '0');
begin
	-- Set up the clock controller:
	clk_ctrl: clock_controller
		port map (
			clk_in => fpga_clk,
			system_clock => system_clk,
			memory_clock => memory_clk,
			dsp_clock => open
		);
	sample_clk <= ctrl_bus(0);

	-- Instantiate the EBI controller:
	ebi_ctrl: ebi_controller
		port map (
			clk => system_clk,
			reset => control_register.reset,
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

	-- Instatiate the blink controller:
	blink_ctrl: blink_controller
		port map(
			system_clk => system_clk,
			enable => control_register.blinkmode,
			reset => control_register.reset,
			led0_blink => blinking_led0,
			led1_blink => blinking_led1
		);

	-- Set up the control register:
	control_register.button0 <= button0;
	control_register.button1 <= button1;
	led0 <= blinking_led0 when control_register.blinkmode = '1' else control_register.led0;
	led1 <= blinking_led1 when control_register.blinkmode = '1' else control_register.led1;

	-- Toplevel internal bus process:
	control_reg_access: process(system_clk, internal_bus_address, internal_bus_data_out, internal_bus_data_in,
		internal_bus_read, internal_bus_write, control_register)
	begin
		if rising_edge(system_clk) then
			if internal_bus_write = '1' then
				if internal_bus_address.toplevel = '1' then
					-- Write the writeable control register fields:
					control_register.reset <= internal_bus_data_in(15);
					control_register.blinkmode <= internal_bus_data_in(13);
					if control_register.blinkmode = '0' then -- LEDs only writeable if not in blink mode
						control_register.led0 <= internal_bus_data_in(12);
						control_register.led1 <= internal_bus_data_in(11);
					end if;
				end if;
			end if;

--			if internal_bus_read = '1' and internal_bus_address.toplevel = '1' then
--				-- Read the control register:
--				internal_bus_data_out <= b"00" &
--					control_register.blinkmode &	-- Bit 13
--					control_register.led0 &			-- Bit 12
--					control_register.led1 &			-- Bit 11
--					control_register.button1 &		-- Bit 10
--					control_register.button0 &		-- Bit  9
--					b"000000" &
--					control_register.number_of_pipelines; -- LSB
--			elsif internal_bus_read = '1' then
--				internal_bus_data_out <= internal_pipeline_data_output(to_integer(unsigned(internal_bus_address.pipeline)));
--			end if;
		end if;
	end process;

	internal_bus_data_out <= internal_pipeline_data_output(to_integer(unsigned(internal_bus_address.pipeline)))
		when internal_bus_address.toplevel = '0' else b"00" &
					control_register.blinkmode &	-- Bit 13
					control_register.led0 &			-- Bit 12
					control_register.led1 &			-- Bit 11
					control_register.button1 &		-- Bit 10
					control_register.button0 &		-- Bit  9
					b"000000" &
					control_register.number_of_pipelines; -- LSB

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
