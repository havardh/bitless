-- Generic memory component
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.core_constants.all;

library unisim;
use unisim.vcomponents.all;

-- This memory component is designed to be used with the buffers, the constant
-- memory and the instruction memory in the cores. The word size for the memory
-- is 32 bits. Addresses are per 32 bit word.

entity memory is
	generic (
		size          : natural; -- Size of the memory in bytes
		address_width : natural
	);
	port (
		clk : in std_logic;
		address_in   : in  std_logic_vector(address_width - 1 downto 0); -- Write address
		address_out  : in  std_logic_vector(address_width - 1 downto 0); -- Read address
		data_in      : in  std_logic_vector(15 downto 0); -- Lower 16 bits is the first word, upper is the second.
		data_out     : out std_logic_vector(31 downto 0); -- Same as above.
		write_enable : in std_logic
	);
end memory;

architecture behaviour of memory is
	subtype memory_word is std_logic_vector(15 downto 0);
	type memory_array is array (size / 2 downto 0) of memory_word;
	
	signal memory : memory_array;
begin
	write_process: process(clk, write_enable)
	begin
		if rising_edge(clk) then
			if write_enable = '1' then
				memory(to_integer(unsigned(address_in))) <= data_in;
			end if;
			data_out <= memory(to_integer(unsigned(address_out) + 1)) & memory(to_integer(unsigned(address_out)));
		end if;
	end process;

end behaviour;

