library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.PIPELINE_CONSTANTS.ALL;

entity mem_ex_reg is
  	port (
		clk 		: in STD_LOGIC;
		mem_ex_in 	: in MEM_EX;
		mem_ex_out 	: out MEM_EX
  	);
end entity ; -- ex_mem_reg

architecture Behavioral of mem_ex_reg is
begin

	UPDATE : process (clk)
	begin
		if rising_edge(clk) then
			mem_ex_out <= mem_ex_in;
		end if;
	end process;
end Behavioral;