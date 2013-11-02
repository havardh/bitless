-- EBI Controller
-- The EBI controller communicates with the MCU over the external interface bus.
-- The EBI controller is the bus master for the internal bus.

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.internal_bus.all;

entity ebi_controller is
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
		int_address      : out internal_address;
		int_data_out     : in  internal_data; -- Data OUT of FPGA
		int_data_in      : out internal_data; -- Data IN to FPGA
		int_write_enable : out std_logic;
		int_read_enable  : out std_logic
	);
end ebi_controller;

architecture behaviour of ebi_controller is
	-- For details of the signals used and their timing, look at
	-- page 180 of the EFM32GG reference manual.

	-- The code below uses a very simple state machine.

	type state is (idle, read_state, write_state);
	signal current_state : state := idle;

	signal re_value, we_value : std_logic := '0';
begin
	int_write_enable <= we_value;
	int_read_enable <= re_value;

	process(clk, ebi_read_enable, ebi_write_enable, ebi_cs, reset)
		-- Some notes:
		-- * One clock cycle should be enough to read or write data on the
		-- internal bus. The internal bus slaves should probably latch the
		-- data on the bus on the falling edge of the read or write enable
		-- signals to be sure that the data has been set up correctly.
		-- * The read and write enable signals are active low. 
	begin
		if rising_edge(clk) then
			if reset = '1' then
				ebi_data <= (others => 'Z');
				we_value <= '0';
				re_value <= '0';
				current_state <= idle;
			else
				case current_state is
					when idle =>
						ebi_data <= (others => 'Z');
						if ebi_cs = '0' then
							if ebi_read_enable = '0' then
								int_address <= make_internal_address(ebi_address);
								re_value <= '1';
								current_state <= read_state;
							elsif ebi_write_enable = '0' then
								int_address <= make_internal_address(ebi_address);
								int_data_in <= ebi_data;
								we_value <= '1';
								current_state <= write_state;
							end if;
						end if;
					when read_state =>
						if re_value = '1' then
							ebi_data <= int_data_out; -- Set the EBI data to the data read from the internal bus.
							re_value <= '0';
						end if;
						if ebi_read_enable = '1' then -- Switch to idle when the transaction is finished.
							current_state <= idle;
						end if;
					when write_state =>
						if we_value = '1' then
							we_value <= '0';
						end if;
						if ebi_write_enable = '1' then -- Switch to idle when the transaction is finished.
							current_state <= idle;
						end if;
				end case;
			end if;
		end if;
	end process;
end behaviour;

