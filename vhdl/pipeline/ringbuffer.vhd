-- Ring buffer / input buffer / output buffer module
-- The ring buffer is a configurable buffer that can operate in both ring buffer
-- and normal memory mode.
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all; -- for typecasts

library work;
use work.core_constants.all;

entity ringbuffer is
	generic(
		data_width		: natural := 32;		-- Width of a buffer word
		address_width	: natural := 16;		-- Width of the address inputs
		buffer_size		: natural := 4096;	-- Size of the buffer, in words
		window_size		: natural := 2048		-- Size of the ring buffer window, in words
	);
	port(
		clk 			: in std_logic; -- Main clock ("small cycle" clock)
		memclk		: in std_logic; -- Memory clock
		sample_clk	: in std_logic; -- Sample clock ("large cycle" clock)

		-- Data and address I/O for using the buffer as output buffer:
		data_in		: in std_logic_vector(15 downto 0);			-- Data input
		data_out		: out std_logic_vector(data_width - 1 downto 0);		-- Data output
		address_out : in std_logic_vector(address_width - 1 downto 0);		-- Address for output data
		address_in	: in std_logic_vector(address_width - 1 downto 0);		-- Address for input data
		write_en		: in std_logic;			-- Write enable for writing data from data_in to address address_in

		-- Data and address I/O for using the buffer as input buffer:
		rodata_out	: out std_logic_vector(data_width - 1 downto 0);		-- Read-only data output
		roaddress	: in std_logic_vector(address_width - 1 downto 0);		-- Address for the read-only data output

		mode			: in ringbuffer_mode	-- Buffer mode
	);
end ringbuffer;

architecture behaviour of ringbuffer is
	type memory_array is array(buffer_size / 2 downto 0) of std_logic_vector(15 downto 0);
	signal memory : memory_array;

	signal rw_window_base : std_logic_vector(address_width - 1 downto 0) := (others => '0');
	signal ro_window_base : std_logic_vector(address_width - 1 downto 0) := (others => '0');
begin
	-- Switch the buffer pointers according to the buffer mode:
	buffer_switch: process(sample_clk, mode)
	begin
		if rising_edge(sample_clk) then
			case mode is
				when NORMAL_MODE =>
				when RING_MODE =>
			end case;
		end if;
	end process;

	-- Update the memory, insert stuff here relating to the buffer windows and pointers:
	memory_process: process(memclk, write_en)
	begin
		if rising_edge(memclk) then
			if write_en = '1' then
				memory(to_integer(unsigned(address_in))) <= data_in;
			end if;

			data_out <= memory(to_integer(unsigned(address_out) + 1)) & memory(to_integer(unsigned(address_out)));
			rodata_out <= memory(to_integer(unsigned(roaddress) + 1)) & memory(to_integer(unsigned(roaddress)));
		end if;
	end process;

end behaviour;
