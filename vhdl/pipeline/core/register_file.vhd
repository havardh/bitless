library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.core_constants.all;

entity register_file is
	port(
		clk				: in std_logic;

		spec_address	: in std_logic_vector(4 downto 0);
		reg_1_address	: in std_logic_vector(4 downto 0);
		reg_2_address	: in std_logic_vector(4 downto 0);
		write_address	: in std_logic_vector(4 downto 0);

		data_in_A		: in std_logic_vector(15 downto 0);
		data_in_B		: in std_logic_vector(15 downto 0);

		write_reg_enb	: in std_logic;
		write_b_enb		: in std_logic;

		spec_reg		: out std_logic_vector(15 downto 0);
		reg_1_data		: out std_logic_vector(15 downto 0);
		reg_2_data		: out std_logic_vector(15 downto 0)

	);
end entity;

architecture Behaviour of register_file is

	type regs_t is array (31 downto 1) of std_logic_vector(15 downto 0);
	signal regs : regs_t := (others => (others => '0'));

begin
	registers: process(clk)
	begin
		if rising_edge(clk) then
			if write_reg_enb='1' then 
				regs(to_integer(unsigned(write_address)))<=data_in_A;
			end if;
			if write_b_enb='1' then
				regs(to_integer(unsigned(write_address)+1))<=data_in_B;
			end if;
		end if;
	end process;

reg_1_data <= (others=>'0') when reg_1_address="00000"
			else regs(to_integer(unsigned(reg_1_address)));

reg_2_data <= (others=>'0') when reg_2_address="00000"
			else regs(to_integer(unsigned(reg_2_address)));

spec_reg <= (others=>'0') when spec_address="00000"
			else regs(to_integer(unsigned(spec_address)));

end Behaviour;

















