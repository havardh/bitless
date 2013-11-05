-- Constant memory component

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.internal_bus.all;

entity instruction_memory is
	generic (
		size : natural -- Number of 16 bit words to store
	);
	port (
		clk           : in  std_logic; -- System clock input, ICE
		memclk        : in  std_logic; -- Clock signal
		read_address  : in  std_logic_vector(15 downto 0); -- Read address
		read_data     : out std_logic_vector(15 downto 0); -- Data read
		write_address : in  std_logic_vector(15 downto 0); -- Write address
		write_data    : in  std_logic_vector(15 downto 0); -- Data to write
		write_enable  : in  std_logic -- Take a guess
	);
end instruction_memory;

architecture behaviour of instruction_memory is
	subtype memory_word is std_logic_vector(15 downto 0);
	type memory_array is array(0 to size) of memory_word;
	signal memory : memory_array;
begin
	write_process: process(memclk)
	begin
		if rising_edge(memclk) then
			if write_enable = '1' then
				memory(to_integer(unsigned(write_address))) <= write_data;
			end if;
			read_data <= memory(to_integer(unsigned(read_address)));
		end if;
	end process;
end behaviour;
