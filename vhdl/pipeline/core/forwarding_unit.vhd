library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.MIPS_CONSTANT_PKG.all;

entity forwarding_unit is
    Port (
        ex_mem_RegisterRd : in STD_LOGIC_VECTOR(4 downto 0); -- Hazard type 1
        mem_wb_RegisterRd : in STD_LOGIC_VECTOR(4 downto 0); -- Hazard type 2
        id_ex_RegisterRs  : in STD_LOGIC_VECTOR(4 downto 0); -- Hazard type a
        id_ex_RegisterRt  : in STD_LOGIC_VECTOR(4 downto 0); -- Hazard type b
        ex_mem_RegWrite   : in STD_LOGIC;
        mem_wb_RegWrite   : in STD_LOGIC;
        forward_b         : out STD_LOGIC_VECTOR(1 downto 0);
        forward_a         : out STD_LOGIC_VECTOR(1 downto 0)
    );
end forwarding_unit;

architecture Behavioral of forwarding_unit is

begin

forward_signals : process(ex_mem_RegWrite, mem_wb_RegWrite, ex_mem_RegisterRd, mem_wb_RegisterRd, id_ex_RegisterRs, id_ex_RegisterRt)

begin
    -- EX hazard
    if (ex_mem_RegWrite = '1') and not(ex_mem_RegisterRd = "00000") then
        if (ex_mem_RegisterRd = id_ex_RegisterRs) then -- Hazard type 1a
            forward_a <= "10";
            forward_b <= "00";
        elsif (ex_mem_RegisterRd = id_ex_RegisterRt) then -- Hazard type 1b
            forward_a <= "00";
            forward_b <= "10";
        else
            forward_a <= "00";
            forward_b <= "00";
        end if;
    -- MEM Hazard
    elsif (mem_wb_RegWrite = '1') and not(mem_wb_RegisterRd = "00000")
    and not((ex_mem_RegWrite = '1') and not(ex_mem_RegisterRd = "00000")) then
        if (mem_wb_RegisterRd = id_ex_RegisterRs) and not(ex_mem_RegisterRd = id_ex_RegisterRs) then -- Hazard type 2a
            forward_a <= "01";
            forward_b <= "00";
        elsif (mem_wb_RegisterRd = id_ex_RegisterRt) and not(ex_mem_RegisterRd = id_ex_RegisterRt) then -- Hazard type 2b
            forward_a <= "00";
            forward_b <= "01";
        else
            forward_a <= "00";
            forward_b <= "00";
        end if;
    else
        forward_a <= "00";
        forward_b <= "00";
    end if;

end process forward_signals;

end Behavioral;
