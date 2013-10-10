----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:21:22 09/19/2013 
-- Design Name: 
-- Module Name:    control_unit - Behavioral 
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

entity control_unit is
    Port ( 	group_code : in  STD_LOGIC_VECTOR (1 downto 0);
				funt : in  STD_LOGIC_VECTOR (1 downto 0);
				opt : in  STD_LOGIC_VECTOR (1 downto 0);
				shift_enable : out  STD_LOGIC;
				reg_dst : out  STD_LOGIC;
				reg_source : out  STD_LOGIC;
				output_read_enable : out  STD_LOGIC;
				output_write_enable : out  STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is

begin


end Behavioral;

