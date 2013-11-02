library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity id_ex_reg is
  	Port (
		clk				: in STD_LOGIC;
		id_ex_in		: in id_ex;
		id_ex_out		: out id_ex
		
  	) ;
end entity ; 

architecture Behavioral of id_ex_reg is

begin
	
	UPDATE : process(clk)
	begin
		if rising_edge(clk) then
			id_ex_out <= id_ex_in;	
		end if;
	end process;

end Behavioral;
