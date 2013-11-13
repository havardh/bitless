--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:	16:36:56 11/13/2013
-- Design Name:
-- Module Name:	M:/Github/tdt4295/vhdl/testbenches/tb_core.vhd
-- Project Name:  tdt4295_core
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: core
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY tb_core IS
END tb_core;

ARCHITECTURE behavior OF tb_core IS

	 -- Component Declaration for the Unit Under Test (UUT)
	 COMPONENT core
	 PORT(
			clk : IN  std_logic;
			memclk : IN  std_logic;
			sample_clk : IN  std_logic;
			reset : IN  std_logic;
			proc_finished : OUT  std_logic;
			instruction_addr : OUT  std_logic_vector(15 downto 0);
			instruction_data : IN  std_logic_vector(15 downto 0);
			constant_addr : OUT  std_logic_vector(15 downto 0);
			constant_data : IN  std_logic_vector(31 downto 0);
			input_read_addr : OUT  std_logic_vector(15 downto 0);
			input_read_data : IN  std_logic_vector(31 downto 0);
			output_write_addr : OUT  std_logic_vector(15 downto 0);
			output_write_data : OUT  std_logic_vector(31 downto 0);
			output_we : OUT  std_logic;
			output_read_addr : OUT  std_logic_vector(15 downto 0);
			output_read_data : IN  std_logic_vector(31 downto 0)
		  );
	 END COMPONENT;

	--Inputs
	signal clk : std_logic := '0';
	signal memclk : std_logic := '0';
	signal sample_clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal instruction_data : std_logic_vector(15 downto 0) := (others => '0');
	signal constant_data : std_logic_vector(31 downto 0) := (others => '0');
	signal input_read_data : std_logic_vector(31 downto 0) := (others => '0');
	signal output_read_data : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
	signal proc_finished : std_logic;
	signal instruction_addr : std_logic_vector(15 downto 0);
	signal constant_addr : std_logic_vector(15 downto 0);
	signal input_read_addr : std_logic_vector(15 downto 0);
	signal output_write_addr : std_logic_vector(15 downto 0);
	signal output_write_data : std_logic_vector(31 downto 0);
	signal output_we : std_logic;
	signal output_read_addr : std_logic_vector(15 downto 0);

	-- Clock period definitions
	constant clk_period : time := 10 ns;
	constant memclk_period : time := 10 ns;
	constant sample_clk_period : time := 10 ns;

	--Instruction constants
	constant gc_load_store : std_logic_vector(1 downto 0) := "01"; --Group bits value code for load/store instructions
	constant fc_load_store : std_logic_vector(1 downto 0) := "11"; --Function bits value code for store instructions

	 --Option constants
	constant oc_store : std_logic_vector(1 downto 0) := "11"; --Option bits value code for store to output buffer
	constant oc_load1 : std_logic_vector(1 downto 0) := "00"; --Option bits value code for load from input buffer
	constant oc_load2 : std_logic_vector(1 downto 0) := "01"; --Option bits value code for load from output buffer
	constant oc_load3 : std_logic_vector(1 downto 0) := "10"; --Option bits value code for load from constant buffer


	--Instructions
	--Currently the address in the the b-registers in the following commands does not matter, and isn't used.
	--This is because there's no memory connected, so all stores will have to check real-time on the outputlines from core,
	--and all loads will have to check the register files and have the value ready on the inputlines on core when the instruction is run.

	  --Store instructions
	constant store_outpt_1 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_store &"10101"&"00010"; --Store value in register 13 into the output address register 2's value points to
	constant store_outpt_2 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_store &"11111"&"00011"; --Store value in register 31 into the output address register 3's value points to
	constant store_outpt_3 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_store &"00000"&"00100"; --Store value in register 0 into the output address register 4's value points to
	constant store_outpt_4 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_store &"01010"&"00101"; --Store value in register 8 into the output address register 5's value points to
	constant store_outpt_5 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_store &"11011"&"00110"; --Store value in register 27 into the output address register 6's value points to
	constant store_outpt_6 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_store &"00100"&"00111"; --Store value in register 4 into the output address register 7's value points to
	constant store_outpt_7 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_store &"00111"&"01000"; --Store value in register 7 into the output address register 8's value points to
	constant store_outpt_8 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_store &"11000"&"01001"; --Store value in register 24 into the output address register 9's value points to

	  --Load instructions
	constant load_inpt_1 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_load1 &"00010"&"00000"; --Load the value pointed to by the address in register 0 to register 2. Value loads to input buffer
	constant load_inpt_2 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_load1 &"00011"&"00000"; --Load the value pointed to by the address in register 0 to register 3. Value loads to input buffer
	constant load_inpt_3 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_load1 &"00100"&"00000"; --Load the value pointed to by the address in register 0 to register 4. Value loads to output buffer
	constant load_inpt_4 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_load2 &"00101"&"00000"; --Load the value pointed to by the address in register 0 to register 5. Value loads to output buffer
	constant load_inpt_5 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_load2 &"00110"&"00000"; --Load the value pointed to by the address in register 0 to register 6. Value loads to output buffer
	constant load_inpt_6 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_load3 &"00111"&"00000"; --Load the value pointed to by the address in register 0 to register 7. Value loads to constant buffer
	constant load_inpt_7 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_load3 &"01000"&"00000"; --Load the value pointed to by the address in register 0 to register 8. Value loads to constant buffer
	constant load_inpt_8 : std_logic_vector(15 downto 0) := gc_load_store & fc_load_store & oc_load3 &"01001"&"00000"; --Load the value pointed to by the address in register 0 to register 9. Value loads to constant buffer

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: core PORT MAP (
			 clk => clk,
			 memclk => memclk,
			 sample_clk => sample_clk,
			 reset => reset,
			 proc_finished => proc_finished,
			 instruction_addr => instruction_addr,
			 instruction_data => instruction_data,
			 constant_addr => constant_addr,
			 constant_data => constant_data,
			 input_read_addr => input_read_addr,
			 input_read_data => input_read_data,
			 output_write_addr => output_write_addr,
			 output_write_data => output_write_data,
			 output_we => output_we,
			 output_read_addr => output_read_addr,
			 output_read_data => output_read_data
		  );

	-- Clock process definitions
	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	memclk_process :process
	begin
		memclk <= '0';
		wait for memclk_period/2;
		memclk <= '1';
		wait for memclk_period/2;
	end process;

	sample_clk_process :process
	begin
		sample_clk <= '0';
		wait for sample_clk_period/2;
		sample_clk <= '1';
		wait for sample_clk_period/2;
	end process;


	-- Stimulus process
	stim_proc: process
	begin
		-- hold reset state for 100 ns.
	  reset <= '1';
		wait for 100 ns;
	  reset <= '0';

		wait for clk_period*10;

		-- insert stimulus here

--		--When commands are run, you need one clockcycle between each command, like shown below
--		--First instruction
--		instruction_data <= instruction_1;
--		wait for clk_period*2;
--
--		--Check if instruction worked
--		wait for clk_period*2;
--
--		--Next instruction
--		instruction_data <= instruction_2;
--		wait for clk_period;
--
--		--Check if instruction worked
--		wait for clk_period*2;
--
		--And so on. Between each instruction check the corresponding registers or input-/output-buffers to verify instruction.

		--Load value from input buffer to register 2
		input_read_data <= X"1010101";
		instruction_data <= load_inpt_1;
		wait for clk_period*2;

		--Check if register 2 has the above hex value
		wait for clk_period*2;

		--Load value from input buffer to register 3
		input_read_data <= X"01010101";
		instruction_data <= load_inpt_2;
		wait for clk_period*2;

		--Check if register 3 has the above hex value
		wait for clk_period*2;

		--Load value from input buffer to register 4
		input_read_data <= X"00001111";
		instruction_data <= load_inpt_3;
		wait for clk_period*2;

		--Check if register 4 has the above hex value
		wait for clk_period*2;

		--Load value from input buffer to register 5
		constant_data <= X"1010101";
		instruction_data <= load_inpt_4;
		wait for clk_period*2;

		--Check if register 5 has the above hex value
		wait for clk_period*2;

		--Load value from input buffer to register 6
		constant_data <= X"01010101";
		instruction_data <= load_inpt_5;
		wait for clk_period*2;

		--Check if register 6 has the above hex value
		wait for clk_period*2;

		--Load value from input buffer to register 7
		output_read_data <= X"1010101";
		instruction_data <= load_inpt_6;
		wait for clk_period*2;

		--Check if register 7 has the above hex value
		wait for clk_period*2;

		--Load value from input buffer to register 8
		output_read_data <= X"01010101";
		instruction_data <= load_inpt_7;
		wait for clk_period*2;

		--Check if register 8 has the above hex value
		wait for clk_period*2;

		--Load value from input buffer to register 9
		output_read_data <= X"00001111";
		instruction_data <= load_inpt_8;
		wait for clk_period*2;

		--Check if register 9 has the above hex value


		wait;
	end process;

END;
