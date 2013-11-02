library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ex_mem_reg is
  	port (
		clk 		: in STD_LOGIC;
		ex_mem_in 	: in EX_MEM;
		ex_mem_out 	: out EX_MEM
  	);
end entity ; -- ex_mem_reg

architecture Behavioral of ex_mem_reg is
begin

	UPDATE : process (clk)
	begin
		if rising_edge(clk) then
			ex_mem_out <= ex_mem_in;
		end if;
	end process;
end Behavioral;