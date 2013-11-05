library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity forwarding_unit is
    Port (
			wb_reg_1_addr,
			wb_reg_2_addr,
			reg_1_addr,
			reg_1b_addr,
			reg_2_addr	: std_logic_vector(4 downto 0);
			
			reg_we		: register_write_enable;
			
			data_1_in,
			data_1b_in,
			data_2_in,
			data_1_out,
			data_1b_out,
			data_2_out	: std_logic_vector(15 downto 0);
			data_wb_in	: std_logic_vector(31 downto 0)
    );
end forwarding_unit;

architecture Behavioral of forwarding_unit is
	signal wb_1_in, wb_2_in : std_logic_vector(15 downto 0);
	
begin
	wb_1_in	<= data_wb_in(15 downto 0);
	wb_2_in	<= data_wb_in(31 downto 16);
	
	forward_signals : process(reg_1_addr, reg_addr_2, reg_write, wb_reg)
	begin
		case reg_we is
			when REG_A_WRITE =>
				--WB contains one value
				if wb_reg_1_addr = reg_1_addr then
					--Single WB value is needed for data 1
					data_1_out <= wb_1_in;
					data_2_out <= data_2_in;
				elsif wb_reg_1_addr = reg_1b_addr then
					--Single WB value is needed for data 1b
					data_1b_out <= wb_1_in;
					data_2_out <= data_2_in;	
				elsif wb_reg_1_addr = reg_2_addr then
					--Single WB value is needed for data 2
					data_1_out <= data_1_in;
					data_2_out <= wb_1_in;
				else
					--WB is not needed
					data_1_out <= data_1_in;
					data_2_out <= data_2_in;
				end if;
				
			when REG_AB_WRITE =>
				--WB contains two values
				--reg_1
				if wb_reg_1_addr = reg_1_addr then
					--Data 1 needs WB 1
					data_1_out <= wb_1_in;
				elsif wb_reg_2_addr = reg_1_addr then
					--Data 1 needs WB 2
					data_1_out <= wb_2_in;
				else
					--Data 1 needs no WB
					data_1_out <= data_1_in;
				end if;
				--reg_1b
				if wb_reg_1_addr = reg_1b_addr then
					--Data 1 needs WB 1
					data_1b_out <= wb_1_in;
				elsif wb_reg_2_addr = reg_1b_addr then
					--Data 1 needs WB 2
					data_1b_out <= wb_2_in;
				else
					--Data 1 needs no WB
					data_1b_out <= data_1b_in;
				end if;
				--reg_2
				if wb_reg_1_addr = reg_2_addr then 
					--Data 2 needs WB 1
					data_2_out <= wb_1_in;
				elsif wb_reg_2_addr = reg_2_addr then
					--Data 2 needs WB 2
					data_2_out <= wb_2_in;
				else
					--WB is not needed
					data_2_out <= data_2_in;
				end if;
				
			when REG_LDI_WRITE =>
				--WB contains single LDI value
				if wb_reg_1_addr = reg_1_addr then
					--Single WB value is needed for data 1
					data_1_out <= wb_1_in;
					data_2_out <= data_2_in;
				elsif wb_reg_1_addr = reg_1b_addr then
					--Single WB value is needed for data 1b
					data_1b_out <= wb_1_in;
					data_2_out <= data_2_in;
				elsif wb_reg_1_addr = reg_2_addr then
					--Single WB value is needed for data 2
					data_1_out <= data_1_in;
					data_2_out <= wb_1_in;
				else
					--WB is not needed
					data_1_out <= data_1_in;
					data_2_out <= data_2_in;
				end if;
			
			when REG_DONT_WRITE =>
				--WB is not needed
				data_1_out <= data_1_in;
				data_2_out <= data_2_in;
		end case;
	end process forward_signals;
end Behavioral;
