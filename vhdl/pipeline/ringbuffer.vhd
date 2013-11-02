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
		b_data_in		: in std_logic_vector(15 downto 0);						-- B data input
		b_data_out		: out std_logic_vector(data_width - 1 downto 0);		-- B data output
		b_off_address	: in std_logic_vector(address_width - 1 downto 0);		-- Address offset for B-buffer
		b_re			: in std_logic;			-- Read enable for B
		b_we			: in std_logic;			-- Write enable for writing data from data_in to address address_in

		-- Data and address I/O for using the buffer as input buffer:
		a_data_out		: out std_logic_vector(data_width - 1 downto 0);		-- A data output
		a_off_address	: in std_logic_vector(address_width - 1 downto 0);		-- Address offset for the A-buffer
		a_re			: in std_logic;			-- Read enable for A
		
		-- Data and address for the int bus:
		int_data_in		: in std_logic_vector(15 downto 0);						-- B data input
		int_data_out	: out std_logic_vector(15 downto 0);		-- B data output
		int_address		: in std_logic_vector(address_width - 1 downto 0);		-- Address offset for B-buffer
		int_re			: in std_logic;			-- Read enable for internal bus
		int_we			: in std_logic;			-- Write enable for writing data from data_in to address address_in
		

		mode			: in ringbuffer_mode	-- Buffer mode
	);
end ringbuffer;

architecture behaviour of ringbuffer is
	component adder is
		port (
			a, b 			: in std_logic_vector(15 downto 0);
			result 			: out std_logic_vector(15 downto 0);
			flags  			: out alu_flags
		);
	end component;
	
	type memory_array is array(buffer_size / 2 downto 0) of std_logic_vector(15 downto 0);
	signal memory			: memory_array;
	
	signal a_address		: std_logic_vector(address_width - 1 downto 0) := (others => '0');	--Actual address as A-buffer.
	signal b_address		: std_logic_vector(address_width - 1 downto 0) := (others => '0');	--Actual address as B-buffer.
	
	signal a_base_address	: std_logic_vector(address_width - 1 downto 0) := (others => '0');	--A-buffer base address
	signal b_base_address	: std_logic_vector(address_width - 1 downto 0) := (others => '0');	--B-buffer base address
	
	signal a_incremented	: std_logic_vector(address_width - 1 downto 0);						--Incremented A-buffer base address.
	signal b_incremented	: std_logic_vector(address_width - 1 downto 0);						--Incremented B-buffer base address.

begin
	
	--Calculating the actual A-buffer read address from base + offset
	a_add : adder
		port map(
			a		=>	a_base_address,
			b		=>	a_off_address,
			result	=>	a_address
		);
		
	--Calculating the actual B-buffer read address from base + offset
	b_add : adder
		port map(
			a		=>	b_base_address,
			b		=>	b_off_address,
			result	=>	b_address
		);
	
	
	--Incrementing base addresses (for ring buffer mode)
	a_base_inc : adder
		port map(
			a => a_base_address,
			b => x"0001",
			result => a_incremented
		);
		
	b_base_inc : adder
		port map(
			a	=>	b_base_address,
			b	=>	x"0001",
			result => b_incremented
		);
	
	-- Switch the buffer pointers according to the buffer mode:
	buffer_switch: process(sample_clk, mode)
	begin
		if rising_edge(sample_clk) then
			case mode is
				when NORMAL_MODE =>
					b_base_address	<= a_base_address;
					a_base_address	<= b_base_address;
				when RING_MODE =>
					b_base_address	<= b_incremented;
					a_base_address	<= a_incremented;
			end case;
		end if;
	end process;

	-- Update the memory, insert stuff here relating to the buffer windows and pointers:
	memory_process: process(memclk, b_we, int_we, a_re, b_re, int_re)
	begin
		if rising_edge(memclk) then
			if int_we = '1' then
				memory(to_integer(unsigned(int_address))) <= int_data_in;
			elsif b_we = '1' then
				memory(to_integer(unsigned(b_address))) <= b_data_in;
			end if;

			if int_re = '1' then
				int_data_out <= memory(to_integer(unsigned(int_address)));
			elsif b_re = '1' then
				b_data_out <= memory(to_integer(unsigned(b_address) + 1)) & memory(to_integer(unsigned(b_address)));
			elsif a_re = '1' then
				a_data_out <= memory(to_integer(unsigned(a_address) + 1)) & memory(to_integer(unsigned(a_address)));
			end if;
		end if;
	end process;

end behaviour;
