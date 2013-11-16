-- Constant memory component


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.internal_bus.all;
use work.core_constants.all;

entity constant_memory is
	generic (
		size : natural := DMEM_SIZE-- Number of 32 bit words to store
	);
	port (
		memclk         : in  std_logic; -- Clock signal
		read_address_a : in  std_logic_vector(DMEM_ADDR_SIZE-1 downto 0); -- Read address A
		read_data_a    : out std_logic_vector(31 downto 0); -- Data read A
		read_address_b : in  std_logic_vector(DMEM_ADDR_SIZE-1 downto 0); -- Read address B
		read_data_b    : out std_logic_vector(31 downto 0); -- Read data B
		write_address  : in  std_logic_vector(DMEM_ADDR_SIZE-1 downto 0); -- Write address
		write_data     : in  std_logic_vector(15 downto 0); -- Data to write
		write_enable   : in  std_logic -- Take a guess
	);
end constant_memory;

architecture behaviour of constant_memory is
	type memory_array is array(0 to DMEM_SIZE-1) of std_logic_vector(31 downto 0);
	signal memory : memory_array := (others => (others => '0'));
	
	signal read_address_a_int, read_address_b_int : std_logic_vector(DMEM_ADDR_SIZE-1 downto 0);
	
begin
	read_data_a <= memory(to_integer(unsigned(read_address_a_int)));
	read_data_b <= memory(to_integer(unsigned(read_address_b_int)));	
	
	write_process: process(memclk, write_enable, write_address)
	begin
		if rising_edge(memclk) then
			if write_enable = '1' then
				if write_address(0) = '1' then
					memory(to_integer(unsigned(write_address(DMEM_ADDR_SIZE-1 downto 0))))(31 downto 16) <= write_data;
				elsif write_address(0) = '0' then
					memory(to_integer(unsigned(write_address(DMEM_ADDR_SIZE-1 downto 0))))(15 downto 0) <= write_data;
				end if;
			end if;
			read_address_a_int <= read_address_a(DMEM_ADDR_SIZE-1 downto 0);
			read_address_b_int <= read_address_b(DMEM_ADDR_SIZE-1 downto 0);
		end if;
		
	end process;
end behaviour;

