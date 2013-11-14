-- Blinkytest

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.core_constants.all;

entity toplevel is
	port(
		fpga_clk : in std_logic;
		led0, led1 : out std_logic;
		gpio_bus : out std_logic_vector(11 downto 0)
	);
end toplevel;

architecture behvariour of toplevel is
	component adder is
		port (
			a, b   : in  std_logic_vector(15 downto 0);
			c      : in  std_logic;
			result : out std_logic_vector(15 downto 0);
			flags  : out alu_flags
		);
	end component;

	signal led_value : std_logic := '0';
	signal counter_value, new_counter_value : std_logic_vector(15 downto 0) := (others => '0');
begin
	led0 <= '1';
	led1 <= led_value;

	process(fpga_clk)
	begin
		if rising_edge(fpga_clk) then
			led_value <= not led_value;
		end if;
	end process;

	test_adder: adder
		port map(
			a => counter_value,
			b => x"0001",
			c => '0',	
			result => new_counter_value,
			flags => open
		);

	process(fpga_clk, new_counter_value)
	begin
		if rising_edge(fpga_clk) then
			if counter_value(12) = '1' then
				counter_value <= (others => '0');
			else
				counter_value <= new_counter_value;
			end if;
		end if;
	end process;

	gpio_bus <= counter_value(11 downto 0);

end behvariour;

