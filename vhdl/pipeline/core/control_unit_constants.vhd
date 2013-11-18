--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.CORE_CONSTANTS.ALL;

package control_unit_constants is

  -- *********************** SIGNAL DOCUMENTATION **************************
		-- || The clock.
		--clk							: in STD_LOGIC; 
		
		-- || The reset signal.
		--reset						: in STD_LOGIC; 
		
		-- || Operation code. Divided into three subgroups: group, func and opt. 
		--opt_code					: in STD_LOGIC_VECTOR (5 downto 0); 
		
		-- || Address to one of the special addresses.
		--spec_reg_addr			: out STD_LOGIC_VECTOR (4 downto 0);
		
		-- || Signal that determine what alu operation that should be preformed.
		--alu_op						: out alu_operation;
		
		-- || Decides the second alu operand: 1 if immidiate value, 0 if regiser value.
		--imm_select	 			: out  STD_LOGIC;
		
		
		-- || Write to register
		-- reg_write_e				: out STD_LOGIC
		
		-- || Decides if the data should be written to register B, instead of A. 
		--reg_b_wr					: out  STD_LOGIC;
		
		-- || Decides what data should be written to register.
		-- || ALU: 00.
		-- || Input buffer: 01.
		-- || Output buffer: 10.
		-- || Constant buffer: 11.
		--reg_write_source 		: out  STD_LOGIC_VECTOR (1 downto 0);
		
		-- || Write to output buffer.
		--output_write_enable 	: out  STD_LOGIC;
		
		-- || Request a read from constant memory.
		--read_from_const_mem 	: out STD_LOGIC;
		
		-- || Branch.
		--branch_enable			: out STD_LOGIC;
		
		-- || Fetch next instruction. 
		--pc_write_enable 		: out STD_LOGIC);

  -- ************************** CONSTANTS ***********************************
	
	-- ***  group_code ***
	constant reg_based1 	: STD_LOGIC_VECTOR := "00";
	constant reg_based2		: STD_LOGIC_VECTOR := "01";
	constant load_imm_value		: STD_LOGIC_VECTOR := "10";
	constant branch			: STD_LOGIC_VECTOR := "11";
	
	-- *** func ***
	
			-- register based 1
			constant add 				: STD_LOGIC_VECTOR := "00";
			constant sub_or_cmp			: STD_LOGIC_VECTOR := "01";
			constant multi				: STD_LOGIC_VECTOR := "10";
			constant halt_or_mad		: STD_LOGIC_VECTOR := "11";
			
			-- register based 2
			constant and_logic 			: STD_LOGIC_VECTOR := "00";
			constant or_logic			: STD_LOGIC_VECTOR := "01";
			constant move_or_typecast	: STD_LOGIC_VECTOR := "10";
			constant load_or_store		: STD_LOGIC_VECTOR := "11"; 
			
	-- *** opt ***
	
			-- ** register based 1**
			
				-- add
				constant add_regs				: STD_LOGIC_VECTOR := "00";
				constant add_imm_value		: STD_LOGIC_VECTOR := "01";
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
				constant fp_mad;			: STD_LOGIC_VECTOR := "10";
				constant fp_msd				: STD_LOGIC_VECTOR := "11";
				constant halt				: STD_LOGIC_VECTOR := "00";
			
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
 
end control_unit_constants;
