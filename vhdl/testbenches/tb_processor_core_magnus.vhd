--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:40:29 11/13/2013
-- Design Name:   
-- Module Name:   M:/Github/tdt4295/tdt4295/vhdl/testbenches/tb_processor_core_magnus.vhd
-- Project Name:  Bitless
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
 
ENTITY tb_processor_core_magnus IS
END tb_processor_core_magnus;
 
ARCHITECTURE behavior OF tb_processor_core_magnus IS 
 
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
   signal constant_data : std_logic_vector(31 downto 0) :=    "00000000000000000000000000000000";
   signal input_read_data : std_logic_vector(31 downto 0) :=  "00000000000000000000000000000001";
   signal output_read_data : std_logic_vector(31 downto 0) := "00000000000000000000000000000010";

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
	
	constant load_instruction0 : std_logic_vector(15 downto 0) := "0111000001000000";
	constant load_instruction1 : std_logic_vector(15 downto 0) := "0111000001000000";
	constant load_instruction2 : std_logic_vector(15 downto 0) := "0111000001000000";
	constant load_instruction3 : std_logic_vector(15 downto 0) := "0111110001000000";
 
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
      wait for clk_period*1.5;	

      --wait for clk_period*10.5;
		reset <= '0';
		instruction_data <= load_instruction0;
		wait for clk_period;
		
		instruction_data <= load_instruction1;
		wait for clk_period;
		
		--instruction_data <= load_instruction2;
		--wait for clk_period;
		
		instruction_data <= load_instruction3;
		wait for clk_period;
		

      -- insert stimulus here 

      wait;
   end process;

END;
