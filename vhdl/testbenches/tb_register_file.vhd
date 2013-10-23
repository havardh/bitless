--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:06:42 10/23/2013
-- Design Name:   
-- Module Name:   Z:/tdt4295/vhdl/testbenches/tb_register_file.vhd
-- Project Name:  ProsjektetTDT4295
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: register_file
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
 
ENTITY tb_register_file IS
END tb_register_file;
 
ARCHITECTURE behavior OF tb_register_file IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT register_file
    PORT(
         clk : IN  std_logic;
         reg_1_address : IN  std_logic_vector(4 downto 0);
         reg_2_address : IN  std_logic_vector(4 downto 0);
         write_address : IN  std_logic_vector(4 downto 0);
         data_in : IN  std_logic_vector(31 downto 0);
         write_reg_enb : IN  register_write_enable;
         reg_1_data : OUT  std_logic_vector(15 downto 0);
         reg_2_data : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reg_1_address : std_logic_vector(4 downto 0) := (others => '0');
   signal reg_2_address : std_logic_vector(4 downto 0) := (others => '0');
   signal write_address : std_logic_vector(4 downto 0) := (others => '0');
   signal data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal write_reg_enb : register_write_enable := reg_dont_write;

 	--Outputs
   signal reg_1_data : std_logic_vector(15 downto 0);
   signal reg_2_data : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: register_file PORT MAP (
          clk => clk,
          reg_1_address => reg_1_address,
          reg_2_address => reg_2_address,
          write_address => write_address,
          data_in => data_in,
          write_reg_enb => write_reg_enb,
          reg_1_data => reg_1_data,
          reg_2_data => reg_2_data
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

      wait for clk_period*10;

		--Test for data write to one register
		data_in <= x"00010001";
		write_reg_enb <= REG_A_WRITE;
		write_address <= "00010";
		
		wait for clk_period*2;
		
		--Test for data write to two registers
		data_in <= x"00030002";
		write_reg_enb <= REG_AB_WRITE;
		write_address <= "00100";
		
		wait for clk_period*2;
		
		--Test for LDI write
		data_in <= x"0000000A";
		write_reg_enb <= REG_LDI_WRITE;
		
		wait for clk_period*2;
		
		reg_1_address <= "00000";
		reg_2_address <= "00001";
		write_reg_enb <= REG_DONT_WRITE;
		
		wait for clk_period*2;
		
		reg_1_address <= "00010";
		reg_2_address <= "00011";
		
		wait for clk_period*2;
		
		reg_1_address <= "00100";
		reg_2_address <= "00101";
		
      wait;
   end process;

END;
