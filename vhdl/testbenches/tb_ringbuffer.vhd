-- Ringbuffer testbench
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.core_constants.all;

entity tb_ringbuffer is
end tb_ringbuffer;

architecture behaviour of tb_ringbuffer is
	component ringbuffer
		generic(
			data_width		: natural := 32;   -- Width of a buffer word
			address_width	: natural := 16;   -- Width of the address inputs
			buffer_size		: natural := 1024; -- Size of the buffer, in words
			window_size		: natural := 512   -- Size of the ring buffer window, in words
		);
		port(
			clk 			: in std_logic; -- Main clock ("small cycle" clock)
			memclk		: in std_logic; -- Memory clock
			sample_clk	: in std_logic; -- Sample clock ("large cycle" clock)

			reset       : in std_logic; -- Resets the addresses

			-- Data and address I/O for using the buffer as output buffer:
			b_data_in     : in  std_logic_vector(data_width - 1 downto 0);    -- B data input
			b_data_out    : out std_logic_vector(data_width - 1 downto 0);    -- B data output
			b_off_address : in  std_logic_vector(address_width - 1 downto 0); -- Address offset for B-buffer
			b_we          : in  std_logic; -- Write enable for writing data from data_in to address address_in

			-- Data and address I/O for using the buffer as input buffer:
			a_data_out    : out std_logic_vector(data_width - 1 downto 0);    -- A data output
			a_off_address : in  std_logic_vector(address_width - 1 downto 0); -- Address offset for the A-buffer

			mode			: in ringbuffer_mode	-- Buffer mode
		);
	end component;

	-- Input signals:
	signal clk : std_logic := '0';
	signal memclk : std_logic := '0';
	signal sample_clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal mode : ringbuffer_mode := NORMAL_MODE;
	signal b_data_in : std_logic_vector(31 downto 0) := (others => '0');
	signal a_off_address, b_off_address : std_logic_vector(15 downto 0) := (others => '0');
	signal b_we : std_logic := '0';

	-- Output signals:
	signal a_data_out, b_data_out : std_logic_vector(31 downto 0);

	-- Clock period definitions:
	constant clk_period : time := 16 ns;			-- ~60 MHz
	constant memclk_period : time := 3 ns;			-- ~300 MHz
	--constant sample_clk_period : time := 45 us;	-- ~22050 Hz

	-- Constants:
	constant buffer_size : natural := 1024;
	constant window_size : natural := 256;

begin
	main_clock: process
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process main_clock;

	memory_clock: process
	begin
		memclk <= '0';
		wait for memclk_period / 2;
		memclk <= '1';
		wait for memclk_period / 2;
	end process memory_clock;

	uut: ringbuffer
		generic map(
			data_width => 32, address_width => 16, buffer_size => buffer_size, window_size => window_size
		)
		port map(
			clk => clk,
			memclk => memclk,
			sample_clk => sample_clk,
			reset => reset,
			b_data_in => b_data_in,
			b_data_out => b_data_out,
			b_off_address => b_off_address,
			b_we => b_we,
			a_data_out => a_data_out,
			a_off_address => a_off_address,
			mode => mode
		);

	test_process: process
	begin

		-- Observe the initial state for one cycle:
		wait for clk_period; -- calm before the storm?

		-- Put the ringbuffer into normal mode:
		mode <= NORMAL_MODE;
		reset <= '1';
		wait for clk_period;
		reset <= '0';
		wait for clk_period;

		-- Write data word 1 to the B side of the buffer:
		b_data_in <= x"deadbeef";
		b_off_address <= x"0000";
		wait for clk_period;
		b_we <= '1';
		wait for clk_period;
		b_we <= '0';
		wait for clk_period;

		-- Write data word 2 to the B side of the buffer:
		b_data_in <= x"feedbeef";
		b_off_address <= x"0001";
		wait for clk_period;
		b_we <= '1';
		wait for clk_period;
		b_we <= '0';
		wait for clk_period;

		-- Check that the data has been written:
		b_off_address <= x"0000";
		wait for clk_period;
		assert b_data_out = x"deadbeef";
		b_off_address <= x"0001";
		wait for clk_period;
		assert b_data_out = x"feedbeef";

		-- Make sure these values are not visible in the output buffer:
		a_off_address <= x"0000";
		wait for clk_period;
		assert a_data_out = x"00000000";
		a_off_address <= x"0001";
		wait for clk_period;
		assert a_data_out = x"00000000";

		-- Assert the sample clock and see what happens:
		sample_clk <= '1';
		wait for clk_period;
		sample_clk <= '0';

		-- Read word 1 from the A buffer:
		a_off_address <= x"0000";
		wait for clk_period;
		assert a_data_out = x"deadbeef";
		-- Read word 2 from the A buffer:
		a_off_address <= x"0001";
		wait for clk_period;
		assert a_data_out = x"feedbeef";

		-- Assert the sample clock again:
		sample_clk <= '1';
		wait for clk_period;
		sample_clk <= '0';

		-- See if the values are available in the B buffer:
		b_off_address <= x"0000";
		wait for clk_period;
		assert b_data_out = x"deadbeef";
		b_off_address <= x"0001";
		wait for clk_period;
		assert b_data_out = x"feedbeef";

		wait;
	end process test_process;

end;
