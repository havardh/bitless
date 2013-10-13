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
use core_constants.vhd;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
	Port ( 	
		clk						: in STD_LOGIC;
		reset						: in STD_LOGIC;
		opt_code					: in STD_LOGIC_VECTOR (5 downto 0);
		spec_reg_addr			: out STD_LOGIC_VECTOR (4 downto 0);
		alu_op					: out alu_operation;
		imm_select	 			: out  STD_LOGIC;
		reg_b_wr					: out  STD_LOGIC;
		reg_write_source 		: out  STD_LOGIC;
		output_write_enable 	: out  STD_LOGIC;
		read_from_const_mem 	: out STD_LOGIC;
		pc_write_enable 		: out STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is

	-- **************************** TYPES *************************************
	type control_unit_state is (fetch, execute, stall);
	
	-- *************************** SIGNALS ************************************
	signal group_code 	: STD_LOGIC_VECTOR (1 downto 0);
	signal func 			: STD_LOGIC_VECTOR (1 downto 0);
	signal opt 				: STD_LOGIC_VECTOR (1 downto 0);
	signal state, next_state : control_unit_state;
	
	
	-- ************************** CONSTANTS ***********************************
	
	-- ***  group_code ***
	constant store_load 	: STD_LOGIC_VECTOR := "00";
	constant arith1		: STD_LOGIC_VECTOR := "01";
	constant arith2		: STD_LOGIC_VECTOR := "10";
	constant misc			: STD_LOGIC_VECTOR := "11";
	
	-- *** func ***
	
	-- store/load
	constant load_imm 		: STD_LOGIC_VECTOR := "00";
	constant load_input		: STD_LOGIC_VECTOR := "01";
	constant load_output		: STD_LOGIC_VECTOR := "10";
	constant store_output	: STD_LOGIC_VECTOR := "11";
	
	-- arith1
	constant add 		: STD_LOGIC_VECTOR := "00";
	constant sub_cmp	: STD_LOGIC_VECTOR := "01";
	constant mul		: STD_LOGIC_VECTOR := "10";
	constant moved		: STD_LOGIC_VECTOR := "11"; 
	-- arith2
	constant logic_and 	: STD_LOGIC_VECTOR := "00";
	constant logic_or		: STD_LOGIC_VECTOR := "01";
	constant logic_xor	: STD_LOGIC_VECTOR := "10";
	constant logic_not	: STD_LOGIC_VECTOR := "11";
	
	
	-- misc
	constant branch 	: STD_LOGIC := '0';
	constant shl_shr 	: STD_LOGIC := '1';
	
	-- opt
	
	-- special registers
	constant default_reg		: STD_LOGIC_VECTOR := "0000"; -- TODO, check this

begin

	update_control_signals : process (state)
	begin
		case state is 
			-- TODO: Check all of this
			when fetch =>
				spec_reg_addr <= default_reg; 
				alu_op <= ALU_ADD; 
			when execute | stall =>
				case group_code is
					when store_load =>
					when arith1 =>
					when arith2 =>
					when misc =>
				end case;
		end case; 
			
	end process;


end Behavioral;

