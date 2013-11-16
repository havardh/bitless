-- Toplevel Testbench
-- ISE sucks, so this had to be written from scratch.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.internal_bus.all;

entity tb_toplevel is
end tb_toplevel;

architecture testbench of tb_toplevel is
	-- The unit to test, UUT:
	component toplevel is
		port (
			fpga_clk 	: in std_logic; -- FPGA clock, 60 MHz input clock

			-- EBI interface lines:
			ebi_address : in    std_logic_vector(22 downto 0);	-- EBI address lines
			ebi_data		: inout std_logic_vector(15 downto 0); -- EBI data lines
			ebi_re		: in    std_logic;	-- EBI read enable (active low)
			ebi_we		: in    std_logic;	-- EBI write enable (active low)
			ebi_cs		: in    std_logic;	-- EBI chip select (active low)

			-- Miscellaneous lines:
			ctrl_bus	  : inout std_logic_vector(2 downto 0) -- Control bus connected to the MCU
		);
	end component;

	-- FPGA clock, 60 MHz:
	signal fpga_clk : std_logic;
	constant clk_period : time := 16.6 ns;

	-- EBI signals:
	signal ebi_address : std_logic_vector(22 downto 0) := (others => '0');
	signal ebi_data : std_logic_vector(15 downto 0) := (others => '0');
	signal ebi_re, ebi_we, ebi_cs : std_logic := '1';

	-- Other connections:
	signal ctrl_bus : std_logic_vector(2 downto 0);

	-- Makes an EBI address:
	function make_ebi_address(toplevel : boolean; pipeline : std_logic_vector(1 downto 0);
		device : std_logic_vector(3 downto 0); coredev : std_logic_vector(1 downto 0);
		address : std_logic_vector(13 downto 0)) return std_logic_vector is
		variable retval : std_logic_vector(22 downto 0);
	begin
		if toplevel = true then
			retval(22) := '1';
		else
			retval(22) := '0';
		end if;
		retval(21 downto 20) := pipeline;
		retval(19 downto 16) := device;
		retval(15 downto 14) := coredev;
		retval(13 downto 0) := address;
		return retval;
	end make_ebi_address;

	signal toplevel_control_register : std_logic_vector(15 downto 0) := (others => '0');

	constant EBI_CS_WAIT : time := 50 ns;
	constant EBI_RE_WAIT : time := 200 ns;
	constant EBI_WE_WAIT : time := 150 ns;

begin

	-- Instantiate the toplevel component:
	uut: toplevel
		port map(
			fpga_clk => fpga_clk,
			ebi_address => ebi_address,
			ebi_data => ebi_data,
			ebi_re => ebi_re,
			ebi_we => ebi_we,
			ebi_cs => ebi_cs,
			ctrl_bus => ctrl_bus
		);

	-- FPGA clock process:
	clk_process: process
	begin
		fpga_clk <= '0';
		wait for clk_period/2;
		fpga_clk <= '1';
		wait for clk_period/2;
	end process;

	-- Stimulus process:
	stim_proc: process
	begin

		-- Reset? Not really neccessary...
		wait for 40 ns;
		wait for clk_period * 2;

		-- Read the toplevel control register:
		report "Reading toplevel control register";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(true, b"00", b"0000", b"00", b"00000000000000");
		ebi_data <= (others => 'Z');
		wait for EBI_CS_WAIT;
		ebi_re <= '0';
		wait for EBI_RE_WAIT;
		ebi_re <= '1';
		toplevel_control_register <= ebi_data;
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		-- Read pipeline 0's control register:
		report "Reading pipeline control register";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0000", b"00", b"00000000000000");
		ebi_data <= (others => 'Z');
		wait for EBI_CS_WAIT;
		ebi_re <= '0';
		wait for EBI_RE_WAIT;
		ebi_re <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		-- Read core 0's control register:
		report "Reading core control register";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"00", b"00000000000000");
		ebi_data <= (others => 'Z');
		wait for EBI_CS_WAIT;
		ebi_re <= '0';
		wait for EBI_RE_WAIT;
		ebi_re <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		report "Writing no-op into core 0's instruction memory";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000000000");
		ebi_data <= x"0000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		-- Write the first instruction to memory of core 0:
		report "Writing LOAD into core 0's instruction memory";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000000001");
--		ebi_data <= b"0111000001000000";
		ebi_data <= b"0111000010000000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		report "Writing no-op into core 0's instruction memory";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000000010");
		ebi_data <= x"0000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;
		
		report "Writing no-op into core 0's instruction memory";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000000011");
		ebi_data <= x"0000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		report "Writing no-op into core 0's instruction memory";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000000100");
		ebi_data <= x"0000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		report "Writing no-op into core 0's instruction memory";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000000101");
		ebi_data <= x"0000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		-- Write the second instruction to memory of core 0:
		report "Writing STORE into core 0's instruction memory";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000000110");
--		ebi_data <= b"0111110001000000";
		ebi_data <= b"0111110010000000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		report "Writing no-op into core 0's instruction memory";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000000111");
		ebi_data <= x"0000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;
		
		report "Writing no-op into core 0's instruction memory";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000001000");
		ebi_data <= x"0000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;
		
		report "Writing no-op into core 0's instruction memory";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000001001");
		ebi_data <= x"0000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		-- Write some no-ops to the instruction memory:
--		for i in 0 to 4 loop
--			report "Writing no-op into core 0's instruction memory";
--			ebi_cs <= '0';
--			ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000000000");
--			ebi_data <= x"0000";
--			wait for EBI_CS_WAIT;
--			ebi_we <= '0';
--			wait for EBI_WE_WAIT;
--			ebi_we <= '1';
--			wait for EBI_CS_WAIT;
--			ebi_cs <= '1';
--			wait for EBI_CS_WAIT;
--		end loop;

		-- Write the third instruction to memory of core 0:
		report "Writing END into core 0's instruction memory";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"01", b"00000000001010");
		ebi_data <= b"0011000000000000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		-- Write a sample to the input buffer, address 0:
		report "Writing a sample into the input buffer of pipeline 0";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0010", b"00", b"00000000000000");
		ebi_data <= x"beef";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		-- Disable the stopmode in the processor core:
		report "Enabling processor!";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"00", b"00000000000000");
		ebi_data <= (others => '0');
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		-- Wait a little while...
		ebi_data <= (others => 'Z'); -- looks pretty in the wave graph...
		wait for clk_period * 25;

		-- Stop the pipeline:
		report "Stopping processor!";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0100", b"00", b"00000000000000");
		ebi_data <= (1 => '1', others => '0');
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		-- Read the output buffer:
		report "Reading the output buffer...";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0011", b"00", b"00000000000000");
		ebi_data <= (others => 'Z');
		wait for EBI_CS_WAIT;
		ebi_re <= '0';
		wait for EBI_RE_WAIT;
		ebi_re <= '1';
		assert ebi_data = x"beef" report "Pipeline does not work!" severity failure;
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';
		wait for EBI_CS_WAIT;

		wait;
	end process;

end architecture;
