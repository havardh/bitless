----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:09:33 10/24/2013 
-- Design Name: 
-- Module Name:    pipe_stage1 - behave 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pipe_stage1 is
	generic(
		PC_DATA_WIDTH		: integer := 10;
		INSTR_DATA_WIDTH	: integer := 16
	);
	port(
		clk			: in	STD_LOGIC;
		pc_we		: in	STD_LOGIC;
		pc_src_sel	: in	STD_LOGIC;
		pc_br_src	: in	STD_LOGIC_VECTOR(PC_DATA_WIDTH-1 downto 0);
		instr_outpt	: out	STD_LOGIC_VECTOR(INSTR_DATA_WIDTH-1 downto 0)
	);
end pipe_stage1;

architecture behave of pipe_stage1 is

	-- Program Counter signals
	signal pc_out	: STD_LOGIC_VECTOR(PC_DATA_WIDTH-1 downto 0);
	component program_counter
		port(
			clk			: in STD_LOGIC;
			address_in	: in STD_LOGIC_VECTOR(PC_DATA_WIDTH-1 downto 0);
			address_out	: out STD_LOGIC_VECTOR(PC_DATA_WIDTH-1 downto 0);
			pc_wr_enb	: in STD_LOGIC
		);
	end component;

	-- Incrementer signals
	
	component incrementer
	
	end component;

	-- 

begin


end behave;

