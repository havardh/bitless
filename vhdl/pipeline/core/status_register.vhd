----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:09:21 10/10/2013 
-- Design Name: 
-- Module Name:    status_register - Behavioral 
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

library work;
use work.core_constants.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity status_register is
	port(
		clk		: in std_logic;
		reset	: in std_logic;
		wr_en	: in std_logic;
		input	: in alu_flags;
		output	: out alu_flags
	);
end status_register;

architecture Behavioral of status_register is

constant flags_reset	: alu_flags := (others => '0');

begin
	process(reset, wr_en) --We're only interested in reacting to these two signals, clock notwithstanding
	begin
		if(reset = '0' and wr_en = '1') then
			output <= input;
		elsif(reset = '1') then
			output <= flags_reset;
		else
		end if;
	end process;

end Behavioral;

