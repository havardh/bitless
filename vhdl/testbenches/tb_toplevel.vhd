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
			ctrl_bus				: inout std_logic_vector(2 downto 0); -- Control bus connected to the MCU
			led0, led1			: out std_logic; -- LEDs
			button0, button1	: in  std_logic; -- Buttons
			gpio_bus				: inout std_logic_vector(12 downto 0) -- GPIO bus, connected to a header
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
	signal led0, led1 : std_logic;
	signal button0, button1 : std_logic := '0';
	signal ctrl_bus : std_logic_vector(2 downto 0);
	signal gpio_bus : std_logic_vector(12 downto 0);

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
			ctrl_bus => ctrl_bus,
			led0 => led0,
			led1 => led1,
			button0 => button0,
			button1 => button1
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

		-- Reset? Not neccessary...
		wait for 40 ns;
		report "VHDL testbenches are like giant scripts that do not support functions";
		wait for clk_period * 2;

		-- Read the toplevel control register:
		report "Reading toplevel control register...";
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

		-- Report how many pipelines the processor is configured for:
		report "Number of pipelines: " & integer'image(to_integer(unsigned(toplevel_control_register and x"0007")));
		wait for clk_period * 4;

		-- Do a reset of the processor:
		report "Resetting processor...";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(true, b"00", b"0000", b"00", b"00000000000000");
		ebi_data <= toplevel_control_register or x"8000";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';

		wait for clk_period * 4;

		-- Finish the reset by clearing the reset bit in the control register:
		report "Clearing the reset bit of the processor control register...";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(true, b"00", b"0000", b"00", b"00000000000000");
		ebi_data <= toplevel_control_register and x"7fff";
		wait for EBI_CS_WAIT;
		ebi_we <= '0';
		wait for EBI_WE_WAIT;
		ebi_we <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';

		report "Processor reset finished!";
		wait for clk_period * 4;

		-- Read the control register of pipeline 0:
		report "Reading the control register of pipeline 0";
		ebi_cs <= '0';
		ebi_address <= make_ebi_address(false, b"00", b"0000", b"00", b"00000000000000");
		ebi_data <= (others => 'Z');
		wait for EBI_CS_WAIT;
		ebi_re <= '0';
		wait for EBI_RE_WAIT;
		ebi_re <= '1';
		wait for EBI_CS_WAIT;
		ebi_cs <= '1';

		wait for clk_period * 4;

--		NOTE: The following transfer cannot be verified as long as the constant memory is write-only.
--		-- Write something to the constant memory of pipeline 0:
--		report "Writing 0xbeef to address 0 in the constant memory of pipeline 0";
--		ebi_cs <= '0';
--		ebi_address <= make_ebi_address(false, b"00", b"0001", b"00", b"00000000000000");
--		ebi_data <= x"beef";
--		wait for EBI_CS_WAIT;
--		ebi_we <= '0';
--		wait for EBI_WE_WAIT;
--		ebi_we <= '1';
--		wait for EBI_CS_WAIT;
--		ebi_cs <= '1';

		wait for clk_period * 4;

		wait;
	end process;

end architecture;
