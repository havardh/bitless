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
		reset					: in STD_LOGIC;
		opt_code				: in STD_LOGIC_VECTOR (5 downto 0);
		spec_reg_addr			: out STD_LOGIC_VECTOR (4 downto 0);
		alu_op					: out alu_operation;
		imm_select	 			: out  STD_LOGIC;
		reg_b_wr				: out  STD_LOGIC;
		reg_write_source 		: out  STD_LOGIC;
		output_write_enable 	: out  STD_LOGIC;
		read_from_const_mem 	: out STD_LOGIC;
		branch_enable			: out STD_LOGIC;
		pc_write_enable 		: out STD_LOGIC);
end control_unit;

architecture Behavioral of control_unit is

	-- **************************** TYPES *************************************
	type control_unit_state is (fetch, execute, stall);
	
	-- *************************** SIGNALS ************************************
	signal group_code 			: STD_LOGIC_VECTOR (1 downto 0);
	signal func 					: STD_LOGIC_VECTOR (1 downto 0);
	signal opt 						: STD_LOGIC_VECTOR (1 downto 0);
	signal state, next_state 	: control_unit_state;
	
	
	-- ************************** CONSTANTS ***********************************
	
	-- ***  group_code ***
	constant reg_based1 	: STD_LOGIC_VECTOR := "00";
	constant reg_based2		: STD_LOGIC_VECTOR := "01";
	constant load_imm		: STD_LOGIC_VECTOR := "10";
	constant branch			: STD_LOGIC_VECTOR := "11";
	
	-- *** func ***
	
			-- register based 1
			constant add 				: STD_LOGIC_VECTOR := "00";
			constant sub_or_cmp			: STD_LOGIC_VECTOR := "01";
			constant multi				: STD_LOGIC_VECTOR := "10";
			constant shift				: STD_LOGIC_VECTOR := "11";
			
			-- register based 2
			constant and_logic 			: STD_LOGIC_VECTOR := "00";
			constant or_logic			: STD_LOGIC_VECTOR := "01";
			constant move_or_typecast	: STD_LOGIC_VECTOR := "10";
			constant load_or_store		: STD_LOGIC_VECTOR := "11"; 
			
	-- *** opt ***
	
			-- ** register based 1**
			
				-- add
				constant add_regs				: STD_LOGIC_VECTOR := "00";
				constant add_imm				: STD_LOGIC_VECTOR := "01";
				constant add_regs_fp			: STD_LOGIC_VECTOR := "10";
				constant add_undefined			: STD_LOGIC_VECTOR := "11";
				
				-- sub_or_cmp
				constant sub_regs				: STD_LOGIC_VECTOR := "00";
				constant sub_regs_fp			: STD_LOGIC_VECTOR := "01";
				constant cmp					: STD_LOGIC_VECTOR := "10";
				constant sub_undefined			: STD_LOGIC_VECTOR := "11";	
				
				-- multi
				constant multi_regs			: STD_LOGIC_VECTOR := "00";
				constant multi_regs_fp		: STD_LOGIC_VECTOR := "01";
				constant multi_acc_fp		: STD_LOGIC_VECTOR := "10";
				constant multi_sub_fp		: STD_LOGIC_VECTOR := "11";
				
				-- shift
				constant shift_lft			: STD_LOGIC_VECTOR := "00";
				constant shift_rht			: STD_LOGIC_VECTOR := "01";
				constant shift_undefined	: STD_LOGIC_VECTOR := "10";
				constant shift_undefined2	: STD_LOGIC_VECTOR := "11";
			
			-- ** register based 2 **
				
				-- and_logic
				constant and_and			: STD_LOGIC_VECTOR := "00";
				constant and_nand			: STD_LOGIC_VECTOR := "01";
				constant and_undefined		: STD_LOGIC_VECTOR := "10";
				constant and_undefined2		: STD_LOGIC_VECTOR := "11";
				
				-- or_logic
				constant or_or				: STD_LOGIC_VECTOR := "00";
				constant or_nor				: STD_LOGIC_VECTOR := "01";
				constant or_xor				: STD_LOGIC_VECTOR := "10";
				constant or_undefined		: STD_LOGIC_VECTOR := "11";
				
				-- move_or_typecast
				constant move_move			: STD_LOGIC_VECTOR := "00";
				constant move_move_neg		: STD_LOGIC_VECTOR := "01";
				constant typecast_to_fp		: STD_LOGIC_VECTOR := "10";
				constant typecast_to_int	: STD_LOGIC_VECTOR := "11";
				
				-- load_or_store
				constant load_input			: STD_LOGIC_VECTOR := "00";
				constant load_output		: STD_LOGIC_VECTOR := "01";
				constant load_const_buf		: STD_LOGIC_VECTOR := "10";
				constant store_output		: STD_LOGIC_VECTOR := "11";
			
	-- special registers
	constant default_reg		: STD_LOGIC_VECTOR := "0000"; -- TODO, check this
	constant r0					: STD_LOGIC_VECTOR := "0000";
	constant r1					: STD_LOGIC_VECTOR := "0001";
	constant r2					: STD_LOGIC_VECTOR := "0010";
	

begin

	update_state : process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				-- TODO: RESET ALL
			else 
				state <= next_state;
			end if;
		end if;
	end process;

	update_control_signals : process (state)
	begin
		case state is 
			-- TODO: Check all of this
			when fetch =>
				spec_reg_addr <= default_reg; 
				alu_op <= ALU_ADD; 
			when execute | stall =>
				case group_code is
				
					when reg_based1 =>
						case func is
							
							when add =>
								case opt is
									when add_regs =>
									when add_imm =>
									when add_regs_fp =>
									when add_undefined =>
								end case;
							
							when sub_or_cmp =>
								case opt is
									when sub_regs =>
									when sub_regs_fp =>
									when cmp =>
									when sub_undefined =>
								end case;
								
							when multi =>
								case opt is
									when multi_regs =>
									when multi_regs_fp =>
									when multi_acc_fp =>
									when multi_sub_fp =>
								end case;
							
							when shift =>
								case opt is
									when shift_lft =>
									when shift_rht =>
									when shift_undefined =>
									when shift_undefined2 =>
								end case;
							
						end case;
						
					when reg_based2 =>
						case func is
							when and_logic =>	
								case opt is 
									when and_and =>
									when and_nand =>
									when and_undefined =>
									when and_undefined2 =>
								end case;
								
							when or_logic =>
								case opt is
									when or_or =>
									when or_nor =>
									when or_xor =>
									when or_undefined =>
								end case;
								
							when move_or_typecast =>
								case opt is
									when move_move =>
									when move_move_neg =>
									when typecast_to_fp =>
									when typecast_to_int =>
								end case;
							
							when load_or_store =>
								case opt is
									when load_input =>
									when load_output =>
									when load_const_buf =>
									when store_output =>
								end case;
						end case;
					
					when load_imm =>
					
					when branch =>
				end case;
		end case; 
			
	end process;


end Behavioral;

