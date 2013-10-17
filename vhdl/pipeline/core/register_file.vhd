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

		write_a_enb		: in std_logic;
		write_b_enb		: in std_logic;

		spec_reg		: out std_logic_vector(15 downto 0);
		reg_1_data		: out std_logic_vector(15 downto 0);
		reg_2_data		: out std_logic_vector(15 downto 0);

	);
end register_file;

architecture Behaviour of register_file is

begin

end Behaviour;