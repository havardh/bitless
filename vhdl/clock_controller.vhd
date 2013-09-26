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
			clkout0 => system_clock,
			clkout1 => memory_clock,
			clkfbout => clkfb,
			clkfbin => clkfb,
			rst => '0'
		);
end behaviour;

