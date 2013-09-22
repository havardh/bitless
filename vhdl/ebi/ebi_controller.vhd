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

		-- EBI inputs:
		ebi_address      : in std_logic_vector(27 downto 0);
		ebi_data         : inout std_logic_vector(15 downto 0);
		ebi_cs           : in std_logic;
		ebi_read_enable  : in std_logic;
		ebi_write_enable : in std_logic;

		-- Internal bus master outputs:
		int_address      : out internal_address;
		int_data         : inout std_logic_vector(15 downto 0);
		int_write_enable : inout std_logic; -- inout allows reading back the value of the signal
		int_read_enable  : inout std_logic
	);
end ebi_controller;

architecture Behavioral of ebi_controller is
	-- For details of the signals used and their timing, look at
	-- page 180 of the EFM32GG reference manual.

	-- The code below uses a very simple state machine.

	type state is (idle, read_state, write_state);
	signal current_state : state := idle;
begin
	process(clk)
		-- Some notes:
		-- * One clock cycle should be enough to read or write data on the
		-- internal bus. The internal bus slaves should probably latch the
		-- data on the bus on the falling edge of the read or write enable
		-- signals to be sure that the data has been set up correctly.
		-- * The read and write enable signals are active low. 
	begin
		if rising_edge(clk) then
			case current_state is
				when idle =>
					-- Only latch the addresses when they have been properly set up by the MCU:
					if ebi_read_enable = '0' or ebi_write_enable = '0' then
						int_address.pipeline <= ebi_address(27 downto 26);
						int_address.device <= ebi_address(25 downto 21);
						int_address.address <= ebi_address(20 downto 0);
					end if;

					if ebi_read_enable = '0' and ebi_cs = '0' then
						int_read_enable <= '1';
						current_state <= read_state;
					elsif ebi_write_enable = '0' and ebi_cs = '0' then
						int_data <= ebi_data;
						int_write_enable <= '1';
						current_state <= write_state;
					end if;
				when read_state =>
					if int_read_enable = '1' then
						ebi_data <= int_data; -- Set the EBI data to the data read from the internal bus.
						int_read_enable <= '0';
					end if;
					if ebi_read_enable = '1' then -- Switch to idle when the transaction is finished.
						current_state <= idle;
					end if;
				when write_state =>
					if int_write_enable = '1' then
						int_write_enable <= '0';
					end if;
					if ebi_write_enable = '1' then -- Switch to idle when the transaction is finished.
						current_state <= idle;
					end if;
			end case;
		end if;
	end process;
end Behavioral;

