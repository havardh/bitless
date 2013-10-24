-- Pipeline module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.core_constants.all;
use work.internal_bus.all;

entity pipeline is
	port (
		clk			: in std_logic; -- Small cycle clock
		sample_clk	: in std_logic; -- Large cycle clock
		memory_clk  : in std_logic; -- Memory clock

		-- Address of the pipeline, two bit number:
		pipeline_address : in std_logic_vector(1 downto 0);

		-- Connections to the internal bus interface:
		int_address  : in  internal_address;
		int_data_in  : in  internal_data;
		int_data_out : out internal_data;
		int_re       : in  std_logic; -- Read enable
		int_we       : in  std_logic  -- Write enable
	);
end entity;

architecture behaviour of pipeline is
	component core is
		generic(
			buffer_address_width : natural := 12;   -- Buffer address bus width
			const_address_width  : natural := 12;   -- Constant memory address width (minimum log2(constant memory size)).
			instr_memory_size    : natural := 1024; -- Instruction memory size
			instr_address_width  : natural := 10    -- Instruction memory address width (minimum log2(instr_memory_size)).
		);
		port(
			clk        : in std_logic; -- Small cycle clock signal
			memclk     : in std_logic; -- Memory clock signal
			sample_clk : in std_logic; -- Reset signal, "large cycle" clock signal

			deadline_missed : out std_logic; -- Signal asserted if the processor is not idle on reset

			-- Internal bus connections, used for reading and writing the instruction memory:
			instr_address      : in std_logic_vector(instr_address_width - 1 downto 0);
			instr_data_in      : in std_logic_vector(15 downto 0);
			instr_data_out     : out std_logic_vector(15 downto 0);
			instr_write_enable : in std_logic;

			-- Connections to the constant memory controller:
			constant_addr        : out std_logic_vector(const_address_width - 1 downto 0);
			constant_data        : in  std_logic_vector(31 downto 0);
			constant_request     : out std_logic;
			constant_acknowledge : in  std_logic;

			-- Connections to the input buffer:
			input_address     : out std_logic_vector(buffer_address_width - 1 downto 0);
			input_data        : in  std_logic_vector(31 downto 0);
			input_read_enable : out std_logic;

			-- Connections to the output buffer:
			output_address      : out std_logic_vector(buffer_address_width - 1 downto 0);
			output_data         : out std_logic_vector(31 downto 0);
			output_write_enable : out std_logic;
			output_read_address : out std_logic_vector(buffer_address_width - 1 downto 0);
			output_read_data    : in  std_logic_vector(31 downto 0);
			output_read_enable  : out std_logic
		);
	end component;

	component ringbuffer is
		generic(
			data_width		: natural := 32;		-- Width of a buffer word
			address_width	: natural := 16;		-- Width of the address inputs
			buffer_size		: natural := 4096;	-- Size of the buffer, in words
			window_size		: natural := 2048		-- Size of the ring buffer window, in words
		);
		port(
			clk 				: in std_logic;	-- Main clock ("small cycle" clock)
			memclk			: in std_logic;	-- Memory clock
			sample_clk		: in std_logic;	-- Sample clock ("large cycle" clock)

			-- Data and address I/O for using the buffer as output buffer:
			b_data_in		: in std_logic_vector(15 downto 0);						-- B data input
			b_data_out		: out std_logic_vector(data_width - 1 downto 0);	-- B data output
			b_off_address	: in std_logic_vector(address_width - 1 downto 0);	-- Address offset for B-buffer
			b_re				: in std_logic;												-- Read enable for B
			b_we				: in std_logic;												-- Write enable for writing data from data_in to address address_in

			-- Data and address I/O for using the buffer as input buffer:
			a_data_out		: out std_logic_vector(data_width - 1 downto 0);	-- A data output
			a_off_address	: in std_logic_vector(address_width - 1 downto 0);	-- Address offset for the A-buffer
			a_re				: in std_logic;												-- Read enable for A
			
			-- Data and address for the int bus:
			int_data_in		: in std_logic_vector(15 downto 0);						-- B data input
			int_data_out	: out std_logic_vector(15 downto 0);	-- B data output
			int_address		: in std_logic_vector(address_width - 1 downto 0);	-- Address offset for B-buffer
			int_re			: in std_logic;												-- Read enable for internal bus
			int_we			: in std_logic;												-- Write enable for writing data from data_in to address address_in
			

			mode			: in ringbuffer_mode	-- Buffer mode
		);
	end component;

	component memory is
		generic (
			size          : natural; -- Size of the memory in bytes
			address_width : natural
		);
		port (
			clk : in std_logic;
			write_address : in  std_logic_vector(address_width - 1 downto 0); -- Write address
			read_address  : in  std_logic_vector(address_width - 1 downto 0); -- Read address
			write_data    : in  std_logic_vector(15 downto 0); -- Lower 16 bits is the first word, upper is the second.
			read_data     : out std_logic_vector(31 downto 0); -- Same as above.
			write_enable  : in std_logic
		);
	end component;

	component constant_arbiter is
		generic (
			pipeline_cores      : natural := 4;
			const_address_width : natural := 16
		);
		port (
			clk                   : in std_logic;
			request               : in  std_logic_vector(pipeline_cores - 1 downto 0);
			acknowledge           : out std_logic_vector(pipeline_cores - 1 downto 0);
			constant_address      : in address_array(pipeline_cores - 1 downto 0);
			constant_read_address : out std_logic_vector(15 downto 0)
		);
	end component;

	-- Pipeline control register:
	type pipeline_control_register is record
			enabled : std_logic;
			reset : std_logic;
			num_cores : std_logic_vector(4 downto 0);
		end record;
	signal pipeline_control : pipeline_control_register;

	-- Core status and control register:
	type core_status_register is record
			deadline_missed : std_logic;
			enabled : std_logic;
			instruction_we : std_logic;
		end record;
	type core_control_block is array(0 to NUMBER_OF_CORES - 1) of core_status_register;
	signal core_control : core_control_block;

	-- Signals connected to the constant memory modules:
	signal constant_write_enable : std_logic;
	signal constant_read_address : std_logic_vector(15 downto 0);
	signal constant_data_in : std_logic_vector(31 downto 0);
	signal constant_data_out : std_logic_vector(31 downto 0);
	signal constant_request, constant_acknowledge : std_logic_vector(NUMBER_OF_CORES - 1 downto 0);
	signal constant_address : address_array(NUMBER_OF_CORES - 1 downto 0);

	-- Constant arbitration unit read address, passed to the constant memory:
	signal arbiter_read_address : std_logic_vector(15 downto 0);

	-- Signals from the internal bus to the instruction memories of the cores:
	type core_instr_address_array is array(NUMBER_OF_CORES - 1 downto 0) of std_logic_vector(15 downto 0);
	signal core_instr_address : core_instr_address_array;
	type core_instr_we_array is array(NUMBER_OF_CORES - 1 downto 0) of std_logic;
	signal core_instr_write_enable : core_instr_we_array;
	type core_instr_data_array is array(NUMBER_OF_CORES - 1 downto 0) of std_logic_vector(15 downto 0);
	signal core_instr_read_data : core_instr_data_array;

	signal input_buffer_data_out : std_logic_vector(15 downto 0);
	signal input_buffer_read_enable, input_buffer_write_enable : std_logic;
begin
	pipeline_control.enabled <= '1';
	pipeline_control.num_cores <= std_logic_vector(to_unsigned(NUMBER_OF_CORES, 5));

	-- Internal bus hub for the pipeline:
	internal_bus_process: process(clk, int_re, int_we)
	begin
		-- Read:
		if rising_edge(int_re) then
			if int_address.pipeline = pipeline_address then
				case int_address.device is
					when b"0000" => -- Read the control register
						int_data_out(15) <= pipeline_control.reset;
						int_data_out(5 downto 1) <= pipeline_control.num_cores;
						int_data_out(0) <= pipeline_control.enabled;
					when b"0001" => -- Read the constant memory
						int_data_out <= constant_data_out(15 downto 0);
					when b"0010" => -- Read the input buffer
						input_buffer_read_enable <= '1';
					when b"0011" => -- Read the output buffer
					when others =>
				end case;
			end if;
		end if;

		-- Write:
		if rising_edge(int_we) then
			if int_address.pipeline = pipeline_address then
				case int_address.device is
					when b"0000" => -- Write the control register
						pipeline_control.reset <= int_data_in(15);
					when b"0001" => -- Write the constant memory
						constant_write_enable <= '1';
					when b"0010" => -- Write the input buffer
						int_data_out <= input_buffer_data_out;
						input_buffer_write_enable <= '1';
					when b"0011" => -- Write the output buffer
					when others =>
				end case;
			end if;
		end if;

		-- Reset write enables:
		if falling_edge(clk) then
			if input_buffer_write_enable = '1' then
				input_buffer_write_enable <= '0';
			end if;
			if input_buffer_read_enable = '1' then
				input_buffer_read_enable <= '0';
			end if;
			if constant_write_enable = '1' then
				constant_write_enable <= '0';
			end if;
		end if;
	end process;

	-- Instantiate the input buffer:
	input_buffer: ringbuffer
		port map(
			clk => clk,
			memclk => memory_clk,
			sample_clk => sample_clk,
			mode => RING_MODE,
			-- Connect these to the first core:
			b_data_in => (others => '0'),
			b_data_out => open,
			b_off_address => (others => '0'),
			b_re => '0',
			b_we => '0',
			-- Leave these open for the input buffer:
			a_data_out => open,
			a_off_address => (others => '0'),
			a_re => '0',
			-- Internal bus connections:
			int_data_in => int_data_in,
			int_data_out => input_buffer_data_out,
			int_address => int_address.address,
			int_re => input_buffer_read_enable,
			int_we => input_buffer_write_enable
		);
	
	-- Instantiate the output buffer:
	--output_buffer:

	-- Instantiate the constant memory:
	constant_memory: memory
		generic map(size => 1024, address_width => 16)
		port map(
			clk => memory_clk,
			write_address => int_address.address,
			read_address => constant_read_address,
			write_data => int_data_in,
			read_data => constant_data_out,
			write_enable => constant_write_enable
		);
	constant_read_address <= arbiter_read_address when sample_clk = '0' else int_address.address;

	-- Instantiate the constant memory arbiter. The EBI does not go through this
	-- module, but instead gets direct access to the constant memory.
	const_arbiter: constant_arbiter
		generic map(pipeline_cores => NUMBER_OF_CORES)
		port map(
			clk => clk,
			request => constant_request,
			acknowledge => constant_acknowledge,
			constant_read_address => arbiter_read_address,
			constant_address => constant_address
		);

	-- Generate cores:
	generate_cores:
		for i in 0 to NUMBER_OF_CORES - 1 generate
			core_x: core generic map(
					buffer_address_width => 16,
					const_address_width => 16,
					instr_address_width => 16)
				port map(
					clk => clk,
					memclk => memory_clk,
					sample_clk => sample_clk,
					deadline_missed => open, -- Should be connected to a core control/status register
					instr_address => core_instr_address(i),
					instr_data_in => int_data_in,
					instr_data_out => core_instr_read_data(i),
					instr_write_enable => core_instr_write_enable(i),
					constant_addr => constant_address(i),
					constant_data => constant_data_out,
					constant_request => constant_request(i),
					constant_acknowledge => constant_acknowledge(i),
					-- The stuff below will probably be changed:
					input_address => open,
					input_data => (others => '0'),
					input_read_enable => open,
					output_address => open,
					output_data => open,
					output_write_enable => open,
					output_read_address => open,
					output_read_data => (others => '0'),
					output_read_enable => open
				);
		end generate;

end behaviour;
