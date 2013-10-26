-- Generic memory component
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.core_constants.all;

entity program_counter is
	generic (
		address_width	: natural := 10
	);
	port (
		clk 		: in std_logic;
		reset		: in std_logic;
		address_in	: in std_logic_vector(address_width - 1 downto 0);
		address_out	: out std_logic_vector(address_width - 1 downto 0);
		pc_wr_enb	: in std_logic

	);
end program_counter;

architecture behaviour of program_counter is

	signal program_address : std_logic_vector(address_width -1 downto 0);

begin

	update_pc : process (clk, pc_wr_enb)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				program_address <= (others => '0');
			elsif pc_wr_enb = '1' then
				program_address <= address_in;
			end if;
		end if;
	end process;

	address_out <= program_address;

end behaviour;