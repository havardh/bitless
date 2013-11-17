library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.core_constants.all;

entity forwarding_unit_ex is
    Port (
			reg_we		: in register_write_enable;
            
			wb_reg_1_addr,
			reg_1_addr,
			reg_2_addr	: in std_logic_vector(4 downto 0);
			
			data_1_in,
			data_2_in   : in std_logic_vector(15 downto 0);
            
			data_1_out,
			data_2_out	: out std_logic_vector(15 downto 0);
            
			data_wb_in	: in std_logic_vector(15 downto 0)
    );
end forwarding_unit_ex;

architecture Behavioral of forwarding_unit_ex is
    
    
	signal wb_1_in : std_logic_vector(15 downto 0);
    
begin
 
	wb_1_in	<= data_wb_in(15 downto 0);
	
	forward_signals : process(reg_1_addr, reg_2_addr, reg_we, wb_reg_1_addr, wb_1_in, data_1_in, data_2_in)
	begin
		case reg_we is
			when REG_A_WRITE =>
				--WB contains one value
				-- data_1_out
				if reg_1_addr = wb_reg_1_addr then
					data_1_out <= wb_1_in;
				else 
					data_1_out <= data_1_in;
				end if;
				
				if reg_2_addr = wb_reg_1_addr then
					data_2_out <= wb_1_in;
				else
					data_2_out <= data_2_in;
				end if;
				
			when REG_AB_WRITE =>
				--WB contains two values
				if reg_1_addr = wb_reg_1_addr then
					data_1_out <= wb_1_in;
				else 
					data_1_out <= data_1_in;
				end if;
				
				if reg_2_addr = wb_reg_1_addr then
					data_2_out <= wb_1_in;
				else
					data_2_out <= data_2_in;
				end if;
				
			when REG_LDI_WRITE =>
				--WB contains two values
				if reg_1_addr = wb_reg_1_addr then
					data_1_out <= wb_1_in;
				else 
					data_1_out <= data_1_in;
				end if;
				
				if reg_2_addr = wb_reg_1_addr then
					data_2_out <= wb_1_in;
				else
					data_2_out <= data_2_in;
				end if;
			
			when others =>
				--WB is not needed
				data_1_out <= data_1_in;
				data_2_out <= data_2_in;
		end case;
	end process forward_signals;
end Behavioral;
