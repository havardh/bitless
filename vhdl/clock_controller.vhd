-- Clock controller
-- Generates the neccessary clock frequencies to use throughout the FPGA.
library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity clock_controller is
	port(
		clk_in       : in std_logic;  -- FPGA main clock input, 60 MHz
		system_clock : out std_logic; -- System clock output, used for the processor cores
		memory_clock : out std_logic  -- Memory clock output, used for the memories
	);
end clock_controller;

architecture behaviour of clock_controller is
	signal clkfb : std_logic;
	signal clock_signal_0, clock_signal_1 : std_logic;
begin
	clock_pll: PLL_BASE
		generic map (
			clkout0_divide => 5,	-- System clock = 120 MHz
			clkout1_divide => 3, -- Memory clock = 200 MHz
			clkfbout_mult => 10, -- Multiply input clock to 600 MHz, required for the PLL to work
			clkin_period => 16.6
		)
		port map (
			clkin => clk_in,
			clkout0 => clock_signal_0,
			clkout1 => clock_signal_1,
			clkfbout => clkfb,
			clkfbin => clkfb,
			rst => '0'
		);

	clock_buffer_0: BUFG
		port map(
			I => clock_signal_0,
			O => system_clock
		);
	clock_buffer_1: BUFG
		port map(
			I => clock_signal_1,
			O => memory_clock
		);

end behaviour;

