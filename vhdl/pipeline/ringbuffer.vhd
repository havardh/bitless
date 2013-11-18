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
		data_width		: natural := 32;   -- Width of a buffer word
		address_width	: natural := 16;   -- Width of the address inputs
		buffer_size		: natural := 1024; -- Size of the buffer, in words
		window_size		: natural := 1     -- Size of the ring buffer window, in words
	);
	port(
		memclk		: in std_logic; -- Memory clock
		sample_clk	: in std_logic; -- Sample clock ("large cycle" clock)

		reset       : in std_logic; -- Resets the addresses

		-- Data and address I/O for using the buffer as output buffer:
		b_data_in     : in  std_logic_vector(data_width - 1 downto 0);    -- B data input
		b_data_out    : out std_logic_vector(data_width - 1 downto 0);    -- B data output
		b_off_address : in  std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0); -- Address offset for B-buffer
		b_we          : in  std_logic; -- Write enable for writing data from data_in to address address_in

		-- Data and address I/O for using the buffer as input buffer:
		a_data_out    : out std_logic_vector(data_width - 1 downto 0);    -- A data output
		a_off_address : in  std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0); -- Address offset for the A-buffer

		mode			: in ringbuffer_mode	-- Buffer mode
	);
end ringbuffer;

architecture behaviour of ringbuffer is

	type memory_array is array(0 to DMEM_SIZE-1) of std_logic_vector(data_width - 1 downto 0);
	signal memory			: memory_array := (others => (others => '0'));

	signal a_address		: std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0);	--Actual address as A-buffer.
	signal b_address		: std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0);	--Actual address as B-buffer.

	signal a_base_address	: std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0);	--A-buffer base address
	signal b_base_address	: std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0);	--B-buffer base address

begin

	a_address <= std_logic_vector(unsigned(a_base_address) + unsigned(a_off_address));
	b_address <= std_logic_vector(unsigned(b_base_address) + unsigned(b_off_address));
	
	-- Switch the buffer pointers according to the buffer mode:
	buffer_switch: process(sample_clk, mode, reset)
	begin
		if rising_edge(sample_clk) then
			if reset = '1' then
				case mode is
					when NORMAL_MODE =>
						a_base_address <= (others => '0');
						b_base_address <= std_logic_vector(to_unsigned(buffer_size / 2, b_base_address'length));
					when RING_MODE =>
						a_base_address <= (others => '0');
						b_base_address <= std_logic_vector(to_unsigned(window_size, b_base_address'length));
				end case;
			else
				case mode is
					when NORMAL_MODE =>
						a_base_address	<= b_base_address;
						b_base_address	<= a_base_address;
					when RING_MODE =>
						a_base_address	<= std_logic_vector(unsigned(a_base_address) + 1);--Incremented A-buffer base address.
						b_base_address	<= std_logic_vector(unsigned(b_base_address) + 1);--Incremented B-buffer base address.
				end case;
			end if;
		end if;
	end process;

	-- Read/write memory:
	memory_process: process(memclk, b_we)
	begin
		if rising_edge(memclk) then
			if b_we = '1' then
				memory(to_integer(unsigned(b_address))) <= b_data_in;
			end if;
			a_data_out <= memory(to_integer(unsigned(a_address)));
			b_data_out <= memory(to_integer(unsigned(b_address)));
		end if;
	end process;

end behaviour;
