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
         reset : IN  std_logic;
         proc_finished : OUT  std_logic;
         pl_stop_core        : in std_logic;
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
   signal reset : std_logic := '0';
   signal pl_stop_core : std_logic := '0';
   signal instruction_data : std_logic_vector(15 downto 0) := (others => '0');
   signal constant_data : std_logic_vector(31 downto 0) :=    "00000000000000000000000000000000";
   signal input_read_data : std_logic_vector(31 downto 0) :=  "11111111111111111111111111111111";
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
	
	constant load_instruction0  : std_logic_vector(15 downto 0) := "0111000001000000";
	
	
	constant store_instruction0 : std_logic_vector(15 downto 0) := "0111110001000000";
	
	constant finished_instruction : std_logic_vector(15 downto 0) := "0011000000000000";
	
	constant no_op_instruction : std_logic_vector(15 downto 0) := (others => '0');
    
    constant branch_instruction0 : std_logic_vector(15 downto 0) := "1100000000000001";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: core PORT MAP (
          clk => clk,
          reset => reset,
          proc_finished => proc_finished,
          pl_stop_core => pl_stop_core,
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
		
		instruction_data <= no_op_instruction;
		wait for clk_period;
		
		
		instruction_data <= store_instruction0;
		wait for clk_period;
		
        
        instruction_data <= branch_instruction0;
        
        wait for clk_period;
        
        instruction_data <= load_instruction0;
		wait for clk_period;
        
        instruction_data <= load_instruction0;
		wait for clk_period;
        
        instruction_data <= load_instruction0;
		wait for clk_period;
		
		
		pl_stop_core <= '1';
		wait for clk_period*2;
		pl_stop_core <= '0';

		instruction_data <= load_instruction0;
		wait for clk_period*3;
		
		instruction_data <= no_op_instruction;
		wait for clk_period;
		
		
		instruction_data <= store_instruction0;
		wait for clk_period;
		
        
      instruction_data <= branch_instruction0;
        
      wait for clk_period;
        
      instruction_data <= load_instruction0;
		wait for clk_period;
        
      instruction_data <= load_instruction0;
		wait for clk_period;
        
      instruction_data <= load_instruction0;
		wait for clk_period;
		--instruction_data <= finished_instruction;
		
        instruction_data <= finished_instruction;
		wait for clk_period;
		
      -- insert stimulus here 

      wait;
   end process;

END;
