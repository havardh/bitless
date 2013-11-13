library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.core_constants.all;

entity register_file is
	port(
		clk				: in std_logic;

		-- Read addresses
		reg_1_address	: in std_logic_vector(4 downto 0);
		reg_2_address	: in std_logic_vector(4 downto 0);
		
		-- Read data		
		reg_1_data		: out std_logic_vector(15 downto 0);
		  -- 1b is the high 16 bits of reg_1
		reg_1b_data		: out std_logic_vector(15 downto 0);
		reg_2_data		: out std_logic_vector(15 downto 0);
		
		-- Write terminal
		write_address	: in std_logic_vector(4 downto 0);
		data_in			: in std_logic_vector(31 downto 0);
		write_reg_enb	: in register_write_enable


	);
end entity;

architecture Behaviour of register_file is

	type regs_t is array (31 downto 0) of std_logic_vector(31 downto 0);
	
	-- RAM
	signal regs : regs_t := (others => (others => '0'));
	
	-- Internal signals
	signal reg_1_data_int : std_logic_vector(31 downto 0);
	signal write_data_int : std_logic_vector(31 downto 0);
	signal write_addr_int : std_logic_vector(4 downto 0);
begin
	
	-- Internal write data signal
	write_data_int <= data_in when write_reg_enb = REG_AB_WRITE 
							else X"0000" & data_in(15 downto 0);
	-- Internal write address signal
	write_addr_int <= write_address when write_reg_enb /= REG_LDI_WRITE
							else "00001";
	
	-- Register write process
	write_registers: process(clk)
	begin
		if rising_edge(clk) then
			if write_reg_enb /= REG_DONT_WRITE then
				regs(to_integer(unsigned(write_addr_int))) <= write_data_int;		
			end if;
		end if;
	end process;

	-- Internal reg 1 read data
	reg_1_data_int <= (others=>'0') when reg_1_address = "00000"
				else regs(to_integer(unsigned(reg_1_address)));
				
	-- Hack the outputs
	reg_1_data <= reg_1_data_int(15 downto 0);	
	reg_1b_data <= reg_1_data_int(31 downto 16);
	

	reg_2_data <= (others=>'0') when reg_2_address = "00000"
				else regs(to_integer(unsigned(reg_2_address)))(15 downto 0);

end Behaviour;
