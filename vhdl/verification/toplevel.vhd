-- TDT4295 Verification Design (Project Puffman)

library ieee;
use ieee.std_logic_1164.all;

-- Button 0 is the reset signal for the EBI controller.
-- This module has the following memory mapping for reading:
--    * Address 0  =>  control for LED 0
--    * Address 1  =>  control for LED 1
--    * Alternating ones and zeroes, with 1 in the highest and lowest bit  =>  0xdead
--    * Alternating ones and zeroes, with 0 in the highest and lowest bit  =>  0xbeef
--    * Address 7fffff (all ones) =>  current value of the GPIO bus ((MSB) 000, 12 GPIO bits, button1 (LSB))
--    * All other even addresses =>  value of even register
--    * All other odd addresses  =>  value of odd register
-- And for writing:
--    * Address 0  =>  control for LED 0, write 1 to turn on
--    * Address 1  =>  control for LED 1, write 1 to turn on
--    * Even addresses  =>  set even register
--    * Odd addresses  =>  set odd register

entity toplevel is
	port (
		clk    : in std_logic; -- FPGA clock, 60 MHz input clock

		-- EBI interface lines:
		ebi_address : in std_logic_vector(22 downto 0);  -- EBI address lines
		ebi_data    : inout std_logic_vector(15 downto 0); -- EBI data lines
		ebi_re      : in std_logic;  -- EBI read enable (active low)
		ebi_we      : in std_logic;  -- EBI write enable (active low)
		ebi_cs      : in std_logic;  -- EBI chip select (active low)

		-- Miscellaneous lines:
		ctrl_bus         : inout std_logic_vector(2 downto 0); -- Control bus connected to the MCU
		led0, led1       : out std_logic; -- LEDs
		button0, button1 : in std_logic; -- Buttons
		gpio_bus         : in std_logic_vector(11 downto 0) -- GPIO bus, connected to a header
    );
end toplevel;

architecture behaviour of toplevel is
	component ebi_controller is
		port (
			clk : in std_logic;
			reset : in std_logic;

			-- EBI inputs:
			ebi_address      : in std_logic_vector(22 downto 0);
			ebi_data         : inout std_logic_vector(15 downto 0);
			ebi_cs           : in std_logic;
			ebi_read_enable  : in std_logic;
			ebi_write_enable : in std_logic;

			-- Internal bus master outputs:
			int_address      : out std_logic_vector(22 downto 0);
			int_data_out     : in  std_logic_vector(15 downto 0); -- Data OUT of FPGA
			int_data_in      : out std_logic_vector(15 downto 0); -- Data IN to FPGA
			int_write_enable : out std_logic;
			int_read_enable  : out std_logic
		);
	end component;

	signal address : std_logic_vector(22 downto 0);
	signal data_in, data_out : std_logic_vector(15 downto 0);
	signal write_enable, read_enable : std_logic;

	-- Signal for storing the address of the previous write:
	signal write_address : std_logic_vector(22 downto 0);

	-- Signal storing the current state of the LEDs:
	signal led0_value, led1_value : std_logic := '0';

	-- "General purpose" registers:
	signal even_register, odd_register : std_logic_vector(15 downto 0);
begin
	led0 <= led0_value;
	led1 <= led1_value;

	ebi_ctrl: ebi_controller
		port map(
			clk => clk,
			reset => button0,
			ebi_address => ebi_address,
			ebi_data => ebi_data,
			ebi_read_enable => ebi_re,
			ebi_write_enable => ebi_we,
			ebi_cs => ebi_cs,
			int_address => address,
			int_data_out => data_out,
			int_data_in => data_in,
			int_write_enable => write_enable,
			int_read_enable => read_enable
		);

	process(write_enable, read_enable, address)
	begin
		-- Write transfer:
		if rising_edge(write_enable) then
			if address = (address'range => '0') then
				led0_value <= data_in(0);
			elsif address = (0 => '1', 22 downto 1 => '0') then
				led1_value <= data_in(0);
			elsif address = b"10101010101010101010101" then
				odd_register <= data_in;
			elsif address = b"01010101010101010101010" then
				even_register <= data_in;
			end if;
		end if;

		-- Read transfer:
		if rising_edge(read_enable) then
			if address = (22 downto 0 => '0') then
				data_out <= (0 => led0_value, 15 downto 1 => '0');
			elsif address = (0 => '1', 22 downto 1 => '0') then
				data_out <= (0 => led1_value, 15 downto 1 => '0');
			elsif address = (22 downto 0 => '1') then
				data_out <= b"000" & gpio_bus & button1;
			elsif address = b"10101010101010101010101" then
				data_out <= x"dead";
			elsif address = b"01010101010101010101010" then
				data_out <= x"beef";
			elsif address(0) = '1' then
				data_out <= odd_register;
			elsif address(0) = '0' then
				data_out <= even_register;
			end if;
		end if;
	end process;

end behaviour;

