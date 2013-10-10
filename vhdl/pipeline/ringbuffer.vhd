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
		buffer_size		: natural := 4096;		-- Size of the buffer, in words
		window_size		: natural := 2048		-- Size of the ring buffer window, in words
	);
	port(
		clk 			: in std_logic; 		-- Main clock ("small cycle" clock)
		memclk			: in std_logic; 		-- Memory clock
		sample_clk		: in std_logic; 		-- Sample clock ("large cycle" clock)

		-- Data and address I/O for using the buffer as output buffer:
		rw_data_in		: in std_logic_vector(15 downto 0);						-- B data input
		rw_data_out		: out std_logic_vector(data_width - 1 downto 0);		-- B data output
		rw_off_address	: in std_logic_vector(address_width - 1 downto 0);		-- Address offset for B-buffer
		write_en		: in std_logic;			-- Write enable for writing data from data_in to address address_in

		-- Data and address I/O for using the buffer as input buffer:
		ro_data_out		: out std_logic_vector(data_width - 1 downto 0);		-- A data output
		ro_off_address	: in std_logic_vector(address_width - 1 downto 0);		-- Address offset for the A-buffer

		mode			: in ringbuffer_mode	-- Buffer mode
	);
end ringbuffer;

architecture behaviour of ringbuffer is
	component adder is
		port (
			a, b 	: in std_logic_vector(15 downto 0);
			result 	: out std_logic_vector(15 downto 0);
			flags  	: out alu_flags
		);
	end component;
	
	type memory_array is array(buffer_size / 2 downto 0) of std_logic_vector(15 downto 0);
	signal memory			: memory_array;
	
	signal ro_address	: std_logic_vector(address_width - 1 downto 0) := (others => '0');		--Actual read address as A-buffer.
	signal rw_address	: std_logic_vector(address_width - 1 downto 0) := (others => '0');		--Actual read address as B-buffer.
	--signal rw_write_address	: std_logic_vector(address_width - 1 downto 0) := (others => '0');		--Actual write address as B-buffer.
	
	signal ro_base_adder	: std_logic_vector(address_width - 1 downto 0);							--Incremented A-buffer base address.
	signal rw_base_adder	: std_logic_vector(address_width - 1 downto 0);							--Incremented B-buffer base address.
	
	signal rw_window_base	: std_logic_vector(address_width - 1 downto 0) := (others => '0');
	signal ro_window_base	: std_logic_vector(address_width - 1 downto 0) := (others => '0');

begin
	
	--Calculating the actual A-buffer read address from base + offset
	a_add : adder
		port map(
			a								=>	ro_window_base,
			b								=>	ro_off_address,
			result (buffer_size/2 downto 0)	=>	ro_address (buffer_size/2 downto 0)
		);
		
	--Calculating the actual B-buffer read address from base + offset
	b_add : adder
		port map(
			a								=>	rw_window_base,
			b								=>	rw_off_address,
			result (buffer_size/2 downto 0)	=>	rw_address (buffer_size/2 downto 0)
		);
	
	
	--Incrementing base addresses (for ring buffer mode)
	a_base_inc : adder
		port map(
			a								=>	ro_window_base,
			b(0)							=>	'1',
			b(address_width - 1 downto 1)	=>	(others => '0'),
			result (buffer_size/2 downto 0)	=>	ro_base_adder (buffer_size/2 downto 0)
		);
		
	b_base_inc : adder
		port map(
			a								=>	rw_window_base,
			b(0)							=>	'1',
			b(address_width - 1 downto 1)	=>	(others => '0'),
			result (buffer_size/2 downto 0)	=>	rw_base_adder (buffer_size/2 downto 0)
		);
	
	-- Switch the buffer pointers according to the buffer mode:
	buffer_switch: process(sample_clk, mode)
	begin
		if rising_edge(sample_clk) then
			case mode is
				when NORMAL_MODE =>
					rw_window_base	<= ro_window_base;
					ro_window_base	<= rw_window_base;
				when RING_MODE =>
					rw_window_base	<= rw_base_adder;
					ro_window_base	<= ro_base_adder;
			end case;
		end if;
	end process;

	-- Update the memory, insert stuff here relating to the buffer windows and pointers:
	memory_process: process(memclk, write_en)
	begin
		if rising_edge(memclk) then
			if write_en = '1' then
				memory(to_integer(unsigned(rw_address))) <= rw_data_in;
			end if;

			rw_data_out <= memory(to_integer(unsigned(rw_address) + 1)) & memory(to_integer(unsigned(rw_address)));
			ro_data_out <= memory(to_integer(unsigned(ro_address) + 1)) & memory(to_integer(unsigned(ro_address)));
		end if;
	end process;

end behaviour;
