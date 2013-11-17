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

	-- The code below uses a very simple state machine, where a
	-- transaction is started on the falling edge of CS.

	type state is (idle, read_state, write_state);
	signal current_state : state := idle;

	signal re_value, we_value : std_logic := '0';
	signal transaction_finished, reset_finished : std_logic := '0';
begin
	int_write_enable <= we_value;
	int_read_enable <= re_value;

	process(clk)
	begin
		if rising_edge(clk) then
			case current_state is
				when idle =>
					ebi_data <= (others => 'Z');
					we_value <= '0';
					re_value <= '0';
					transaction_finished <= '0';

					if ebi_read_enable = '0' and ebi_cs = '0' then
						int_address <= make_internal_address(ebi_address);
						current_state <= read_state;
					elsif ebi_write_enable = '0' and ebi_cs = '0' then
						int_address <= make_internal_address(ebi_address);
						int_data_in <= ebi_data;
						current_state <= write_state;
					end if;
	
				when read_state =>
					if re_value = '1' then
						re_value <= '0';
						ebi_data <= int_data_out;
						transaction_finished <= '1';
					elsif transaction_finished = '0' then
						re_value <= '1';
					end if;

					if ebi_cs = '1' then
						current_state <= idle;
					end if;

				when write_state =>
					if we_value = '1' then
						we_value <= '0';
						transaction_finished <= '1';
					elsif transaction_finished = '0' then
						we_value <= '1';
					end if;

					if ebi_cs = '1' then
						current_state <= idle;
					end if;
			end case;
		end if;
	end process;
end behaviour;

