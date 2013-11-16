-- Blink controller
-- Used to create a blinking signal for the LEDs.

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.core_constants.all;

entity blink_controller is
	port(
		system_clk    : in std_logic; -- System clock input (60MHz)
		enable, reset : in std_logic; -- Blink controller enable and reset signals
		led0_blink, led1_blink : out std_logic -- Output signal for the LEDs
	);
end blink_controller;

architecture behvaiour of blink_controller is
	component adder is
		port (
			a, b : in std_logic_vector(15 downto 0);
			c    : in std_logic;
			result : out std_logic_vector(15 downto 0);
			flags  : out alu_flags
		);
	end component;

	signal led0_value, led1_value : std_logic;
	signal counter1, counter1_inc, counter2, counter2_inc : std_logic_vector(15 downto 0);
begin
	led0_blink <= led0_value and enable;
	led1_blink <= led1_value and enable;

	counter: process(system_clk, enable)
	begin
		if rising_edge(system_clk) then
			if reset = '1' then
				counter1 <= x"0000";
				counter2 <= x"0000";
				led0_value <= '0';
				led1_value <= '1';
			else				
				if counter1 = x"0000" then
					counter1 <= counter1_inc;
					counter2 <= counter2_inc;
				elsif counter2 = x"0200" then -- Gives a nice blink, but I was too lazy to calculate the frequency
					led0_value <= led1_value;
					led1_value <= led0_value;
					counter2 <= x"0000";
				else
					counter1 <= counter1_inc;
				end if;
			end if;
		end if;
	end process;

	counter1_adder: adder
		port map(
			a => counter1,
			b => x"0001",
			c => '0',
			result => counter1_inc,
			flags => open
		);

	counter2_adder: adder
		port map(
			a => counter2,
			b => x"0001",
			c => '0',
			result => counter2_inc,
			flags => open
		);

end behvaiour;

