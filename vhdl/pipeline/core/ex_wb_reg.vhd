library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity mem_wb_reg is
    Port (
        clk             : in STD_LOGIC;
        mem_wb_in       : in MEM_WB;
        mem_wb_out      : out MEM_WB
    );
end mem_wb_reg;

architecture Behavioral of mem_wb_reg is

begin

    UPDATE : process(clk)
    begin 
        if rising_edge(clk) then
            mem_wb_out <= mem_wb_in;
        end if;
    end process;


end Behavioral;