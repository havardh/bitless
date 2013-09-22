-- Pipeline module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.core_constants.all;
use work.internal_bus.all;

entity pipeline is
	generic (
		num_cores		 : natural := 4;
		pipeline_number : unsigned
	);

	port (
		clk			: in std_logic; -- Small cycle clock
		sample_clk	: in std_logic; -- Large cucle clock

		-- Connections to the internal bus interface:
		int_address : in internal_address;
		int_data    : in internal_data;
		int_re      : in std_logic; -- Read enable
		int_we      : in std_logic  -- Write enable
	);
end entity;

architecture behaviour of pipeline is
	
	component ringbuffer is
		generic(
			data_width		: natural := 16;		-- Width of a buffer word
			address_width	: natural := 12;		-- Width of the address inputs
			buffer_size		: natural := 4096;	-- Size of the buffer, in words
			window_size		: natural := 2048		-- Size of the ring buffer window, in words
		);
		port(
			clk 			: in std_logic; -- Main clock ("small cycle" clock)
			sample_clk	: in std_logic; -- Sample clock ("large cycle" clock)
			data_in		: in std_logic_vector(data_width - 1 downto 0);			-- Data input
			data_out		: out std_logic_vector(data_width - 1 downto 0);		-- Data output
			address_out : in std_logic_vector(address_width - 1 downto 0);		-- Address for output data
			address_in	: in std_logic_vector(address_width - 1 downto 0);		-- Address for input data
			write_en		: in std_logic;			-- Write enable for writing data from data_in to address address_in
			rodata_out	: out std_logic_vector(data_width - 1 downto 0);		-- Read-only data output
			roaddress	: in std_logic_vector(address_width - 1 downto 0);		-- Address for the read-only data output
			mode			: in ringbuffer_mode	-- Buffer mode
		);
	end component;

begin

end behaviour;
