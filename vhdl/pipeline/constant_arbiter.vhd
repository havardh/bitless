-- Arbitration unit for access to the constant memory
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.core_constants.all;

entity constant_arbiter is
	generic (
		pipeline_cores      : natural := 4;
		const_address_width : natural := 16
	);
	port (
		clk                   : in std_logic;
		request               : in  std_logic_vector(pipeline_cores - 1 downto 0);
		acknowledge           : out std_logic_vector(pipeline_cores - 1 downto 0);
		constant_address      : in address_array(pipeline_cores - 1 downto 0);
		constant_read_address : out std_logic_vector(15 downto 0)
	);
end constant_arbiter;

architecture behaviour of constant_arbiter is
	type state is (idle, ack);
	signal current_state : state := idle;
	signal current_request : natural := 0;
begin

	process(clk)
	begin
		if rising_edge(clk) then
			case current_state is
				when idle =>
					acknowledge <= (others => '0');
					for i in 0 to pipeline_cores - 1 loop
						if request(i) = '1' then
							current_request <= i;
							current_state <= ack;
							exit;
						end if;
					end loop;
				when ack =>
					acknowledge(current_request) <= '1';
					current_state <= idle;
			end case;
		end if;
	end process;

end architecture;
