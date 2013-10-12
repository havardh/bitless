-- EBI controller testbench
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.internal_bus.all;

entity tb_ebi_controller is
end tb_ebi_controller;

architecture behavior of tb_ebi_controller is

	-- Component Declaration for the Unit Under Test (UUT)
 
	component ebi_controller
		port (
			clk : in std_logic;
			reset : in std_logic;
			ebi_address : in std_logic_vector(24 downto 0);
			ebi_data : inout std_logic_vector(15 downto 0);
			ebi_cs : in std_logic;
			ebi_read_enable : in std_logic;
			ebi_write_enable : in std_logic;
			int_address : out internal_address;
			int_data_out : in internal_data;
			int_data_in : out internal_data;
			int_write_enable : out std_logic;
			int_read_enable  : out std_logic
		);
	end component;

	--Inputs
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal ebi_address : std_logic_vector(24 downto 0) := (others => '0');
	signal ebi_cs : std_logic := '1';
	signal ebi_read_enable : std_logic := '1';
	signal ebi_write_enable : std_logic := '1';
	signal int_data_out : internal_data := (others => '0');

	--BiDirs
	signal ebi_data : std_logic_vector(15 downto 0);

	--Outputs
	signal int_address : internal_address;
	signal int_data_in : internal_data;
	signal int_write_enable : std_logic;
	signal int_read_enable : std_logic;

	-- Clock period definitions
	constant clk_period : time := 10 ns;
 
begin

	-- Instantiate the Unit Under Test (UUT)
	uut: ebi_controller PORT MAP (
			clk => clk,
			reset => reset,
			ebi_address => ebi_address,
			ebi_data => ebi_data,
			ebi_cs => ebi_cs,
			ebi_read_enable => ebi_read_enable,
			ebi_write_enable => ebi_write_enable,
			int_address => int_address,
			int_data_out => int_data_out,
			int_data_in => int_data_in,
			int_write_enable => int_write_enable,
			int_read_enable => int_read_enable
		);

   -- Clock process definitions
	clk_process: process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	-- Internal bus write process:
	process (int_read_enable)
	begin
		if rising_edge(int_read_enable) then
			int_data_out <= x"beef";
		end if;
	end process;

	-- Stimulus process
	stim_proc: process
	begin
		-- hold reset state for 100 ns.
		wait for 100 ns;	
		wait for clk_period*10;

		-- Reset the EBI controller:
		reset <= '1';
		wait for clk_period * 4;
		reset <= '0';
		wait for clk_period * 4;

		-- Test an EBI write transfer:
		ebi_address <= b"01" & b"00100" & b"110110110110110010";
		ebi_data <= x"1234";
		ebi_cs <= '0';
		wait for clk_period * 4;

		-- No changes to the internal bus here!
		assert int_write_enable = '0' report "Internal bus write enable is asserted!";
		assert int_read_enable = '0' report "Internal bus read enable is asserted!";

		-- Do write:
		ebi_write_enable <= '0';
		wait for clk_period * 2;
		assert int_data_in = ebi_data report "Internal data is not equal to EBI data";

		wait for clk_period * 2;
		ebi_write_enable <= '1';
		wait for clk_period * 2;
		ebi_cs <= '1'; -- Disable the chip select
		wait for clk_period * 2;

		-- Try an EBI read transfer:
		ebi_address <= b"10" & b"11011" & b"001001001001001101"; -- Simply the inverse of the above
		ebi_cs <= '0';
		wait for clk_period * 4;

		ebi_read_enable <= '0';	-- Do the read
		wait for clk_period * 2;
		assert int_data_out = ebi_data report "Internal data is not equal to EBI data";
		ebi_read_enable <= '1';

		ebi_cs <= '1'; -- Disable the EBI interface.
		wait for clk_period * 4;

		wait;
	end process;

end;
