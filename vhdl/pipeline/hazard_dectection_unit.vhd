----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:16:37 11/14/2013 
-- Design Name: 
-- Module Name:    hazard_dectection_unit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hazard_dectection_unit is
    Port (
        clk         : in std_logic;
        mem_branch  : in std_logic;
        ex_branch   : in std_logic;
        mem_load    : in std_logic;
        id_r1_addr  : in std_logic_vector(4 downto 0);
        id_r2_addr  : in std_logic_vector(4 downto 0);
        mem_r1_addr : in std_logic_vector(4 downto 0);
        --mem_r2_addr : in std_logic_vector(4 downto 0);
        id_cmp      : in std_logic;
        mem_cmp     : in std_logic;
        ex_cmp      : in std_logic;
        no_op       : out std_logic;
        stall_op    : out std_logic;
    
    );
end hazard_dectection_unit;

architecture Behavioral of hazard_dectection_unit is

begin
    detect_hazard : process(clk) 
    begin
        if falling_edge(clk) then
            if (mem_branch = '1' or ex_branch = '1') then
                no_op <= '1';
            elsif (mem_load = '1')
            and ((id_r1_addr = mem_r1_addr) or (id_r2_addr = mem_r1_addr)) then
                no_op <= '1';
    end process;

end Behavioral;

