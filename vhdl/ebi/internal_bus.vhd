-- Internal bus interface package
-- This file contains types and component definitions for the internal bus.

library ieee;
use ieee.std_logic_1164.all;

package internal_bus is

	-- Address type for the internal bus. If you are changing this, remember to change the header
	-- file in sw/ebi_interface.h. Assumes 27 bit EBI bus addresses.
	type internal_address is
		record
			pipeline : std_logic_vector(1  downto 0); -- Number of the pipeline to address
			device   : std_logic_vector(4  downto 0); -- Number of the device in the pipeline to address
			address  : std_logic_vector(20 downto 0); -- Address of the byte to address in the device
		end record;

	-- Data type for the internal bus.
	subtype internal_data is std_logic_vector(15 downto 0);

	-- EBI controller - bus master for the internal bus and slave for the EBI bus.
	component ebi_controller is
		port (
			clk : in std_logic;

			-- EBI inputs:
			ebi_address      : in std_logic_vector(27 downto 0);
			ebi_data         : inout std_logic_vector(15 downto 0);
			ebi_cs           : in std_logic;
			ebi_read_enable  : in std_logic;
			ebi_write_enable : in std_logic;

			-- Internal bus master outputs:
			int_address      : out internal_address;
			int_data         : inout internal_data;
			int_write_enable : inout std_logic;
			int_read_enable  : inout std_logic
		);
	end component;

end internal_bus;
