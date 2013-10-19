--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:07:02 10/16/2013
-- Design Name:   
-- Module Name:   M:/Github/tdt4295/vhdl/testbenches/tb_status_register.vhd
-- Project Name:  TDT4295_VHDL_Project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: status_register
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

library work;
use work.core_constants.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_status_register IS
END tb_status_register;
 
ARCHITECTURE behavior OF tb_status_register IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT status_register
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         wr_en : IN  std_logic;
         input : IN  alu_flags;
         output : OUT  alu_flags
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal wr_en : std_logic := '0';
   signal input : alu_flags := (others => '0');

	--Outputs
	signal output : alu_flags := (others => '0');

	-- Clock period definitions
	constant clk_period : time := 10 ns;
	
	-- Alu_flags input definitions
	constant alu_zero	: alu_flags := (zero => '1', others => '0');
	constant alu_carry	: alu_flags := (carry => '1', others => '0');

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: status_register PORT MAP (
		clk => clk,
		reset => reset,
		wr_en => wr_en,
		input => input,
		output => output
	);

	-- Clock process definitions
	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;


	-- Stimulus process
	stim_proc: process
	begin
	
	-- hold reset state for 100 ns.
	wait for 100 ns;

	reset <= '1';
	wait for clk_period*10;

	-- insert stimulus here 
	
	reset <= '0';
	input <= alu_zero;
	wait for clk_period*3;
	
	wr_en <= '1';
	input <= alu_zero;
	wait for clk_period*3;
	
	wr_en <= '0';
	reset <= '1';
	wait for clk_period;
	reset <= '0'; 
	wait for clk_period*2;
	
	wr_en <= '0';
	input <= alu_carry;
	wait for clk_period*3;
	
	wr_en <= '1';
	wait for clk_period*3;

	wait;
	end process;

END;
