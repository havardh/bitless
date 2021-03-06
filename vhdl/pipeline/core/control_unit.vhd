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

library work;
use work.core_constants.all;
use work.control_unit_constants.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_unit is
    port (  
        opt_code            : in    std_logic_vector (5 downto 0);
		  
        stop_core           : out std_logic;
        alu_op              : out alu_operation;
        reg_write_e         : out register_write_enable;
        wb_src              : out wb_source;
        mem_src             : out mem_source;
        output_write_enable : out std_logic;
        add_imm             : out std_logic;
        load_const          : out std_logic;
        branch_enable       : out std_logic
        );
end control_unit;

architecture Behavioral of control_unit is

    -- *************************** SIGNALS ************************************
    signal group_code          : STD_LOGIC_VECTOR (1 downto 0);
    signal func                : STD_LOGIC_VECTOR (1 downto 0);
    signal opt                 : STD_LOGIC_VECTOR (1 downto 0);
    
    
    
    

begin

    group_code  <= opt_code(5 downto 4);
    func        <= opt_code(3 downto 2);
    opt         <= opt_code(1 downto 0); 

    update_control_signals : process (group_code, func, opt)
    begin        
		case group_code is
			when reg_based1 =>
				wb_src <= MUX_ALU;
				output_write_enable <= '0';
				load_const <= '0';
				branch_enable <= '0';
				case func is
					when add =>
						stop_core <= '0';
						case opt is
							when add_regs =>
								alu_op <= ALU_ADD;
								reg_write_e <= REG_A_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
								
							when add_imm_value =>
								alu_op <= ALU_ADD;
								reg_write_e <= REG_A_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '1';
								
							when add_regs_fp =>
								alu_op <= fp_add;
								reg_write_e <= REG_A_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
								
--                                when add_undefined =>
--                                    alu_op <= ALU_ADD;
--                                    reg_write_e <= REG_DONT_WRITE;
--                                    mem_src <= MEM_INPUT;
--                                    add_imm <= '0';
							when others =>
								alu_op <= ALU_ADD;
								reg_write_e <= REG_DONT_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
						end case;
					when sub_or_cmp =>
						stop_core <= '0';
						case opt is
							when sub_regs =>
								alu_op <= ALU_SUB;
								reg_write_e <= REG_A_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
							when sub_regs_fp =>
								alu_op <= fp_sub;
								reg_write_e <= REG_A_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
							when cmp =>
								alu_op <= ALU_SUB;
								reg_write_e <= REG_DONT_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
--                                  when sub_undefined =>
--                                    alu_op <= ALU_ADD;
--                                    reg_write_e <= REG_DONT_WRITE;
--                                    mem_src <= MEM_INPUT;
--                                    add_imm <= '0';
							when others =>
								alu_op <= ALU_ADD;
								reg_write_e <= REG_DONT_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
						end case;	 
					when multi =>
						stop_core <= '0';
						case opt is
							when multi_regs =>
								alu_op <= ALU_MUL;
								reg_write_e <= REG_A_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
							when multi_regs_fp =>
								alu_op <= fp_mul;
								reg_write_e <= REG_A_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
							when multi_acc_fp =>
								alu_op <= fp_mac;
								reg_write_e <= REG_A_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
							when multi_sub_fp =>
								alu_op <= fp_msc;
								reg_write_e <= REG_A_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
							when others =>
								alu_op <= ALU_ADD;
								reg_write_e <= REG_DONT_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
						end case;
					when halt_or_mad =>
						case opt is
							when fp_mad =>
								stop_core <= '0';
								alu_op <= fp_mad;
								reg_write_e <= REG_A_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
							when fp_msd =>
								stop_core <= '0';
								alu_op <= fp_msd;
								reg_write_e <= REG_A_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
							when others =>--halt
								stop_core <= '1';
								alu_op <= ALU_SUB;
								reg_write_e <= REG_DONT_WRITE;
								mem_src <= MEM_INPUT;
								add_imm <= '0';
						end case;
					when others =>
						 alu_op <= ALU_SUB;
						 reg_write_e <= REG_DONT_WRITE;
						 mem_src <= MEM_INPUT;
						 add_imm <= '0';
				end case;
					  
			when reg_based2 =>
				stop_core <= '0';
				branch_enable   <= '0';      
				case func is
					when and_logic =>  

						 output_write_enable <= '0'; 
						 wb_src              <= MUX_ALU;
						 load_const          <= '0';
						 mem_src             <= MEM_INPUT;
						 load_const          <= '0';
						 add_imm             <= '0';
											  
						 case opt is 
							  when and_and =>
									alu_op      <= ALU_AND;
									reg_write_e <= REG_A_WRITE;
							  when and_nand =>
									alu_op      <= ALU_NAND;
									reg_write_e <= REG_A_WRITE;
--                                when and_undefined =>
--                                    alu_op      <= ALU_AND;
--                                    reg_write_e <= REG_DONT_WRITE;
--                                when and_undefined2 =>
--                                    alu_op      <= ALU_AND;
--                                    reg_write_e <= REG_DONT_WRITE;
							  when others =>
									alu_op      <= ALU_AND;
									reg_write_e <= REG_DONT_WRITE;
						 end case;
						 
					when or_logic =>

						 output_write_enable <= '0';
						 wb_src              <= MUX_ALU;
						 load_const          <= '0';
						 mem_src             <= MEM_INPUT;
						 add_imm             <= '0';

						 case opt is
							when or_or =>
								alu_op      <= ALU_OR;
								reg_write_e <= REG_A_WRITE;
							when or_nor =>
								alu_op      <= ALU_NOR;
								reg_write_e <= REG_A_WRITE;
							when or_xor =>
								alu_op      <= ALU_XOR;
								reg_write_e <= REG_A_WRITE;
--                                when or_undefined =>
--                                    alu_op      <= ALU_OR;
--                                    reg_write_e <= REG_DONT_WRITE;
							when others =>
								alu_op      <= ALU_OR;
								reg_write_e <= REG_DONT_WRITE;
						 end case;
						 
					when move_or_typecast =>
						output_write_enable <= '0';
						wb_src              <= MUX_ALU;
						load_const          <= '0';
						mem_src             <= MEM_INPUT;
						add_imm             <= '0';
						case opt is
							when move_move =>
								alu_op      <= ALU_MOVE;
								reg_write_e <= REG_A_WRITE;
							when move_move_neg =>
								alu_op <= ALU_MOVE_NEGATIVE;
								reg_write_e <= REG_A_WRITE;
							when typecast_to_fp =>
								alu_op <= ALU_FIXED_TO_FLOAT;
								reg_write_e <= REG_A_WRITE;
							when typecast_to_int =>
								alu_op <= ALU_FLOAT_TO_FIXED;
								reg_write_e <= REG_A_WRITE;
							when others =>
								alu_op <= ALU_FLOAT_TO_FIXED;
								reg_write_e <= REG_A_WRITE;
						end case;
					
					when load_or_store =>
						alu_op  <= ALU_ADD;
						wb_src  <= MUX_MEM;
						add_imm <= '0';

						case opt is
							when load_input =>
								reg_write_e <= REG_AB_WRITE;
								mem_src     <= MEM_INPUT;
								load_const  <= '0';
								output_write_enable <= '0';
							when load_output =>
								reg_write_e <= REG_AB_WRITE;
								mem_src     <= MEM_OUTPUT;
								load_const  <= '0';
								output_write_enable <= '0';
							when load_const_buf =>
								reg_write_e <= REG_DONT_WRITE;
								mem_src     <= MEM_CONST;
								load_const  <= '1';
								output_write_enable <= '0';
							when store_output =>
								reg_write_e <= REG_DONT_WRITE;
								mem_src     <= MEM_CONST;
								load_const  <= '0';
								output_write_enable <= '1';
							when others =>
								reg_write_e <= REG_DONT_WRITE;
								mem_src     <= MEM_CONST;
								load_const  <= '0';
								output_write_enable <= '1';
						end case;
					when others =>
						alu_op  <= ALU_ADD;
						wb_src  <= MUX_MEM;
						add_imm <= '0';
						reg_write_e <= REG_DONT_WRITE;
						mem_src     <= MEM_CONST;
						load_const  <= '0';
						output_write_enable <= '0';
				end case;
			 
			when load_imm_value =>
				stop_core           <= '0';
				alu_op              <= ALU_ADD;
				reg_write_e         <= REG_LDI_WRITE;
				wb_src              <= MUX_IMM;
				mem_src             <= MEM_INPUT;
				output_write_enable <= '0';
				add_imm             <= '0';
				load_const          <= '0';
				branch_enable       <= '0';                    
			 
			when branch =>
				stop_core           <= '0';
				alu_op              <= ALU_ADD;
				reg_write_e         <= REG_DONT_WRITE;
				wb_src              <= MUX_IMM;
				mem_src             <= MEM_INPUT;
				output_write_enable <= '0';
				add_imm             <= '0';
				load_const          <= '0';
				branch_enable       <= '1';
				  
			when others =>
				stop_core           <= '0';
				alu_op              <= ALU_ADD;
				reg_write_e         <= REG_DONT_WRITE;
				wb_src              <= MUX_IMM;
				mem_src             <= MEM_INPUT;
				output_write_enable <= '0';
				add_imm             <= '0';
				load_const          <= '0';
				branch_enable       <= '0';
		end case;
    end process;
    
    
        


end Behavioral;

