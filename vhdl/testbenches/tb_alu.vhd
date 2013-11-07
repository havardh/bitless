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

library work;
use work.core_constants.all;
 
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
         cpu_input_const : IN  std_logic_vector(31 downto 0);
         cpu_input_const_w : IN  std_logic;
         operation : IN  alu_operation;
         result : OUT  std_logic_vector(31 downto 0);
         flags : OUT  alu_flags
        );
    END COMPONENT;
    

   --Inputs
   signal dsp_clk : std_logic := '0';
   signal cpu_clk : std_logic := '0';
   signal cpu_input_register_1 : std_logic_vector(15 downto 0) := (others => '0');
   signal cpu_input_register_2 : std_logic_vector(15 downto 0) := (others => '0');
   signal cpu_input_const : std_logic_vector(31 downto 0) := (others => '0');
   signal cpu_input_const_w : std_logic := '0';
   signal operation : alu_operation;

 	--Outputs
   signal result : std_logic_vector(31 downto 0);
   signal flags : alu_flags;

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
		
		operation 				 <= ALU_ADD;
		cpu_input_register_1  <= "0000000000000001";
      cpu_input_register_2  <= "0000000000000001";
		wait for cpu_clk_period/2;
		assert result = x"00000002" report "ADD not working!";
		
		operation 				 <= ALU_ADD;
		cpu_input_register_1  <= "1111111111111111";
      cpu_input_register_2  <= "0000000000000010";
		wait for cpu_clk_period/2;
		assert result = x"00000001" report "Result of xFFFF + 2 is not 1!";
		assert flags.overflow = '1' report "Overflow not set";
		
		operation 				 <= ALU_SUB;
		cpu_input_register_1  <= "0111111111111111";
      cpu_input_register_2  <= "0000000000000010";
		wait for cpu_clk_period/2;
		assert result = x"00007FFD" report "SUB not working";
		
		operation 				 <= ALU_OR;
		cpu_input_register_1  <= "0101010101010101";
      cpu_input_register_2  <= "1010101010101010";
		wait for cpu_clk_period/2;
		wait for cpu_clk_period/2;
		assert result = x"FFFFFFFF" report "OR not working!";
		
		operation 				 <= ALU_OR;
		cpu_input_register_1  <= "0000000000001100";
      cpu_input_register_2  <= "0000000000000110";
		wait for cpu_clk_period/2;
		assert result = x"0000000E" report "OR not working!";
		
		operation 				 <= ALU_MUL;
		cpu_input_register_1  <= "0000000000000001";
      cpu_input_register_2  <= "0000000000000001";
		wait for cpu_clk_period/2;
		assert result = x"00000001" report "MUL not working!";
	
		operation 				 <= ALU_MUL;
		cpu_input_register_1  <= "0000000000000111";
      cpu_input_register_2  <= "0000000000000101";
		wait for cpu_clk_period/2;
		assert result = x"00000023" report "MUL not working!";
		
		operation 				 <= ALU_MUL;
		cpu_input_register_1  <= "1111111111111001";
      cpu_input_register_2  <= "0000000000000101";
		wait for cpu_clk_period/2;
		assert result = x"FFFFFFDD" report "MUL not working!";
		
		operation 				 <= ALU_AND;
		cpu_input_register_1  <= "1111111111111001";
      cpu_input_register_2  <= "0000000000000101";
		wait for cpu_clk_period/2;
		assert result = x"00000001" report "AND isn't working";
		
		operation 				 <= ALU_AND;
		cpu_input_register_1  <= "1111111111111001";
      cpu_input_register_2  <= "0000000000000010";
		wait for cpu_clk_period/2;
		assert result = x"00000000" report "AND isn't working";
		assert flags.zero = '1' report "AND zero flag isn't working";
		
		operation 				 <= ALU_AND;
		cpu_input_register_1  <= "1111111111111001";
      cpu_input_register_2  <= "1000000000000010";
		wait for cpu_clk_period/2;
		assert result = x"FFFF8000" report "AND isn't working";
		assert flags.negative = '1' report "AND negative flag isn't working";
		
		operation 				 <= ALU_XOR;
		cpu_input_register_1  <= "0000000110011001";
      cpu_input_register_2  <= "0000000110011010";
		wait for cpu_clk_period/2;
		assert result = x"00000003" report "XOR isn't working";
		assert flags.negative = '0' report "XOR negative flag isn't working";
		
		operation 				 <= ALU_XOR;
		cpu_input_register_1  <= "0000000110011001";
      cpu_input_register_2  <= "1000000110011010";
		wait for cpu_clk_period/2;
		assert result = x"FFFF8003" report "XOR isn't working";
		assert flags.negative = '1' report "XOR negative flag isn't working";
		
		operation 				 <= ALU_NAND;
		cpu_input_register_1  <= "0000000011000000";
      cpu_input_register_2  <= "1111111111111111";
		wait for cpu_clk_period/2;
		assert result = "11111111111111111111111100111111" report "NAND isn't working";
		
		operation 				 <= ALU_NAND;
		cpu_input_register_1  <= "0000000000000011";
      cpu_input_register_2  <= "1111111111111111";
		wait for cpu_clk_period/2;
		assert result = x"FFFFFFFC" report "NAND isn't working";
		
		operation 				 <= ALU_NOR;
		cpu_input_register_1  <= "0101010101010101";
      cpu_input_register_2  <= "1010101010101010";
		wait for cpu_clk_period/2;
		wait for cpu_clk_period/2;
		assert result = x"00000000" report "NOR not working!";
		
		operation 				 <= ALU_NOR;
		cpu_input_register_1  <= "0000000000001100";
      cpu_input_register_2  <= "0000000000000110";
		wait for cpu_clk_period/2;
		assert result = x"FFFFFFF1" report "NOR not working!";
		
		operation 				 <= ALU_MOVE;
		cpu_input_register_1  <= "0000000000001100";
      cpu_input_register_2  <= "0000000000000110";
		wait for cpu_clk_period/2;
		assert result = x"0000000C" report "MOVE not working!";
		
		operation 				 <= ALU_MOVE;
      cpu_input_register_1  <= "0000000000000110";
		cpu_input_register_2  <= "0000000000001100";
		wait for cpu_clk_period/2;
		assert result = x"00000006" report "MOVE not working!";
		
		
		operation 				 <= ALU_MOVE_NEGATIVE;
      cpu_input_register_1  <= "0000000000000110";
		cpu_input_register_2  <= "0000000000001100";
		wait for cpu_clk_period/2;
		assert result = x"FFFFFFF9" report "MOVE_NEG not working!";
		
		operation 				 <= ALU_MOVE_NEGATIVE;
		cpu_input_register_1  <= "0000000000001100";
      cpu_input_register_2  <= "0000000000000110";
		wait for cpu_clk_period/2;
		assert result = x"FFFFFFF3" report "MOVE_NEG not working!";
		
--		operation 				 <= FP_MUL;
--		cpu_input_register_1  <= "0011110000000000";
--    cpu_input_register_2  <= "0011110000000000";
--		wait for cpu_clk_period/2;
--		assert result = "00000000000000000011110000000000" report "FP_MUL not working!";

		operation				<= ALU_FIXED_TO_FLOAT;
		cpu_input_register_1	<= x"0002";
		wait for cpu_clk_period/2;
		assert result = "0100000000000000" report "Fix_to_float not working!";


      wait;
   end process;

END;
