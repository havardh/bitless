-- Internal bus interface package
-- This file contains types and component definitions for the internal bus.

library ieee;
use ieee.std_logic_1164.all;

package internal_bus is

	-- Address type for the internal bus. Assumes 23 bit EBI bus addresses.
	type internal_address is
		record
			toplevel : std_logic; -- Toplevel "selector"
			pipeline : std_logic_vector(1 downto 0);  -- Pipeline number
			device   : std_logic_vector(3 downto 0);  -- Pipeline device
			coredev  : std_logic_vector(1 downto 0);  -- Core device
			address  : std_logic_vector(13 downto 0); -- Address of the byte to address in the device
		end record;

	-- Data type for the internal bus.
	subtype internal_data is std_logic_vector(15 downto 0);

	-- EBI controller - bus master for the internal bus and slave for the EBI bus.
	component ebi_controller is
		port (
			clk : in std_logic;
			reset : in std_logic;

			-- EBI inputs:
			ebi_address      : in std_logic_vector(22 downto 0);
			ebi_data         : inout std_logic_vector(15 downto 0);
			ebi_cs           : in std_logic;
			ebi_read_enable  : in std_logic;
			ebi_write_enable : in std_logic;

			-- Internal bus master outputs:
			int_address      : out internal_address;
			int_data_out     : in  std_logic_vector(15 downto 0); -- OUT of FPGA
			int_data_in      : out std_logic_vector(15 downto 0); -- IN to FPGA
			int_write_enable : inout std_logic;
			int_read_enable  : inout std_logic
		);
	end component;

	-- Toplevel processor control register:
	type toplevel_control_register is
		record
			number_of_pipelines  : std_logic_vector(2 downto 0);
			ebi_controller_reset : std_logic;
			master_reset         : std_logic;
			led0, led1           : std_logic;
			button0, button1     : std_logic;
			master_enable        : std_logic;
		end record;

	-- Processor core control register:
	type core_status_register is
		record
			reset                   : std_logic;
			running                 : std_logic;
			instruction_memory_size : std_logic_vector(4 downto 0);
			deadline_missed         : std_logic;
		end record;

	-- Converts an integer to a pipeline address:
	function make_pipeline_address(number : integer) return std_logic_vector;

	-- Converts an EBI address to an internal address:
	function make_internal_address(ebi_address : std_logic_vector(22 downto 0)) return internal_address;

	-- Generic log2 function (FIXME: move to somewhere else):
	function log2(number : natural) return integer;

end internal_bus;

package body internal_bus is

	-- Converts an integer to a pipeline address:
	function make_pipeline_address(number : integer) return std_logic_vector is
	begin
		case number is
			when 0 =>
				return b"00";
			when 1 =>
				return b"01";
			when 2 =>
				return b"10";
			when 3 =>
				return b"11";
			when others =>
				return "--";
		end case;
	end make_pipeline_address;

	function make_internal_address(ebi_address : std_logic_vector(22 downto 0)) return internal_address is
		variable retval : internal_address;
	begin
		retval.toplevel := ebi_address(22);
		retval.pipeline := ebi_address(21 downto 20);
		retval.device := ebi_address(19 downto 16);
		retval.coredev := ebi_address(15 downto 14);
		retval.address := ebi_address(13 downto 0);
		return retval;
	end make_internal_address;

	function log2(number : natural) return integer is
		variable remainder : integer := number;
		variable retval : integer := 0;
	begin
		while remainder > 0 loop
			retval := retval + 1;
			remainder := remainder / 2;
		end loop;
		return retval;
	end log2;

end package body;
