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
        clk                 : in    std_logic;
        reset               : in    std_logic;
        opt_code            : in    std_logic_vector (5 downto 0);

        alu_op              : out alu_op;
        reg_write_e         : out register_write_enable;
        wb_src              : out wb_source;
        mem_src             : out mem_source;
        load_imm            : out std_logic;
        output_write_enable : out std_logic;
        add_imm             : out std_logic;
        load_const          : out std_logic;
        branch_enable       : out std_logic;
        );
end control_unit;

architecture Behavioral of control_unit is

    -- **************************** TYPES *************************************
    type control_unit_state is (execute, bubble);
    
    -- *************************** SIGNALS ************************************
    signal group_code          : STD_LOGIC_VECTOR (1 downto 0);
    signal func                : STD_LOGIC_VECTOR (1 downto 0);
    signal opt                 : STD_LOGIC_VECTOR (1 downto 0);
    signal state               : control_unit_state;
    
    
    
    

begin

    group_code  <= opt_code(5 downto 4);
    func        <= opt_code(3 downto 2);
    opt         <= opt_code(1 downto 0); 

    update_control_signals : process (opt_code)
    begin
        if (state = execute) then        
            case group_code is
                when reg_based1 =>
                    branch_enable <= '0';
                    output_write_enable <= '0';
                    output_write_enable <= '0';
                    
                    case func is
                        when add =>
                            reg_b_wr <= '0';
                            reg_write_source <= "00";
                            case opt is
                                when add_regs =>
                                    alu_op <= ALU_ADD;
                                    imm_select <= '0';
                                    reg_write_e <= '1';
                                when add_imm =>
                                    alu_op <= ALU_ADD;
                                    imm_select <= '1';
                                    reg_write_e <= '1';
                                when add_regs_fp =>
                                    alu_op <= ALU_ADD; -- ADD_FP?
                                    imm_select <= '0';
                                    reg_write_e <= '1';
                                when add_undefined =>
                                    imm_select <= '0';
                                    reg_write_e <= '0';
                            end case;
                            
                        when sub_or_cmp =>
                            
                            reg_b_wr <= '0';
                            reg_write_source <= "00";
                            
                            case opt is
                                when sub_regs =>
                                    alu_op <= ALU_SUB;
                                    imm_select <= '0';
                                    reg_write_e <= '1';
                                when sub_regs_fp =>
                                    alu_op <= ALU_SUB; -- SUB_FP?
                                    imm_select <= '0';
                                    reg_write_e <= '1';
                                when cmp =>
                                    alu_op <= ALU_SUB;
                                    imm_select <= '0';
                                    reg_write_e <= '0';
                                when sub_undefined =>
                                    alu_op <= ALU_SUB;
                                    imm_select <= '0';
                                    reg_write_e <= '0';
                            end case;
                            
                        when multi =>
                        
                            reg_b_wr <= '0';
                            reg_write_source <= "00"; 
                            case opt is
                                when multi_regs =>
                                    alu_op <= ALU_MULTI; -- TODO, add to constants package.
                                    imm_select <= '0';
                                    reg_write_e <= '1';
                                when multi_regs_fp =>
                                    alu_op <= ALU_MULTI_FP; -- TODO, add to constants package.
                                    imm_select <= '0';
                                    reg_write_e <= '1';
                                when multi_acc_fp =>
                                    alu_op <= ALU_MULTI_ACC_FP; -- TODO, add to constants package.
                                    imm_select <= '0';
                                    reg_write_e <= '1';
                                when multi_sub_fp =>
                                    alu_op <= ALU_MULTI_SUB_FP; -- TODO, add to constants package.
                                    imm_select <= '0';
                                    reg_write_e <= '1';
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
                
                    branch <= '0';
                    
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
                    state               <= execute;
                    alu_op              <= ALU_ADD,
                    reg_write_e         <= REG_LDI_WRITE,
                    wb_src              <= MUX_IMM,
                    mem_src             <= MEM_INPUT,
                    load_imm            <= '1',
                    output_write_enable <= '0',
                    add_imm             <= '0';
                    load_const          <= '0';
                    branch_enable       <= '0';                    
                
                when branch =>
                    state               <= bubble;
                    alu_op              <= ALU_ADD,
                    reg_write_e         <= REG_DONT_WRITE,
                    wb_src              <= MUX_IMM,
                    mem_src             <= MEM_INPUT,
                    load_imm            <= '0',
                    output_write_enable <= '0',
                    add_imm             <= '0';
                    load_const          <= '0';
                    branch_enable       <= '1';
            end case;
        else
            state               <= execute;
            alu_op              <= ALU_ADD,
            reg_write_e         <= REG_DONT_WRITE,
            wb_src              <= MUX_ALU,
            mem_src             <= MEM_INPUT,
            load_imm            <= '0',
            output_write_enable <= '0',
            add_imm             <= '0';
            load_const          <= '0';
            branch_enable       <= '0'


                
        end if;    
    end process;
    
    
        


end Behavioral;

