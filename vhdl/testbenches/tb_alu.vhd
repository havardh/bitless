--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:53:20 11/03/2013
-- Design Name:   
-- Module Name:   Z:/tdt4295/vhdl/testbenches/tb_alu.vhd
-- Project Name:  ProsjektetTDT4295
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
 
ENTITY tb_alu IS
END tb_alu;
 
ARCHITECTURE behavior OF tb_alu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         dsp_clk : IN  std_logic;
         cpu_clk : IN  std_logic;
         cpu_input_register_1 : IN  std_logic_vector(15 downto 0);
         cpu_input_register_2 : IN  std_logic_vector(15 downto 0);
         cpu_input_const : IN  std_logic_vector(15 downto 0);
         cpu_input_const_w : IN  std_logic;
         operation : IN  std_logic;
         result : OUT  std_logic_vector(31 downto 0);
         flags : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal dsp_clk : std_logic := '0';
   signal cpu_clk : std_logic := '0';
   signal cpu_input_register_1 : std_logic_vector(15 downto 0) := (others => '0');
   signal cpu_input_register_2 : std_logic_vector(15 downto 0) := (others => '0');
   signal cpu_input_const : std_logic_vector(15 downto 0) := (others => '0');
   signal cpu_input_const_w : std_logic := '0';
   signal operation : std_logic := '0';

 	--Outputs
   signal result : std_logic_vector(31 downto 0);
   signal flags : std_logic;

   -- Clock period definitions
   constant dsp_clk_period : time := 10 ns;
   constant cpu_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          dsp_clk => dsp_clk,
          cpu_clk => cpu_clk,
          cpu_input_register_1 => cpu_input_register_1,
          cpu_input_register_2 => cpu_input_register_2,
          cpu_input_const => cpu_input_const,
          cpu_input_const_w => cpu_input_const_w,
          operation => operation,
          result => result,
          flags => flags
        );

   -- Clock process definitions
   dsp_clk_process :process
   begin
		dsp_clk <= '0';
		wait for dsp_clk_period/2;
		dsp_clk <= '1';
		wait for dsp_clk_period/2;
   end process;
 
   cpu_clk_process :process
   begin
		cpu_clk <= '0';
		wait for cpu_clk_period/2;
		cpu_clk <= '1';
		wait for cpu_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for dsp_clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
