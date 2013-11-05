library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.PIPELINE_CONSTANTS.ALL;

entity ex_wb_reg is
    Port (
        clk             : in STD_LOGIC;
        ex_wb_in       	: in EX_WB;
        ex_wb_out     	: out EX_WB
    );
end mem_wb_reg;

architecture Behavioral of mem_wb_reg is

begin

    UPDATE : process(clk)
    begin 
        if rising_edge(clk) then
            ex_wb_out <= ex_wb_in;
        end if;
    end process;


end Behavioral;