library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.PIPELINE_CONSTANTS.ALL;

entity id_mem_reg is
  	Port (
		clk				: in STD_LOGIC;
		id_mem_in		: in id_ex;
		id_mem_out		: out id_ex
		
  	) ;
end entity ; 

architecture Behavioral of id_mem_reg is

begin
	
	UPDATE : process(clk)
	begin
		if rising_edge(clk) then
			id_mem_out <= id_mem_in;	
		end if;
	end process;

end Behavioral;
