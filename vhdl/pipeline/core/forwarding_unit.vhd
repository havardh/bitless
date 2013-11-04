library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.MIPS_CONSTANT_PKG.all;

entity forwarding_unit is
    Port (
			wb_reg					: in STD_LOGIC_VECTOR(4 downto 0); -- Hazard type 1
			reg_addr_1			  	: in STD_LOGIC_VECTOR(4 downto 0); -- Hazard type a
			reg_addr_2			 	: in STD_LOGIC_VECTOR(4 downto 0); -- Hazard type b
			reg_write   			: in STD_LOGIC;
			forward_1         	: out STD_LOGIC;
			forward_2         	: out STD_LOGIC
    );
end forwarding_unit;

architecture Behavioral of forwarding_unit is

begin

forward_signals : process(reg_addr_1, reg_addr_2, reg_write, wb_reg)

begin
    -- EX hazard
    if (reg_write = '1') then
        if (wb_reg = reg_addr_1) then 
            forward_1 <= "1";
            forward_2 <= "0";
        elsif (web_reg = reg_addr_2) then 
            forward_1 <= "0";
            forward_2 <= "1";
        else
            forward_1 <= "0";
            forward_2 <= "0";
        end if;
    else
        forward_a <= "00";
        forward_b <= "00";
    end if;

end process forward_signals;

end Behavioral;
