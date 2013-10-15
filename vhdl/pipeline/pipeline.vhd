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
			clk 			: in std_logic; 		-- Main clock ("small cycle" clock)
			memclk			: in std_logic; 	-- Memory clock
			sample_clk		: in std_logic; 	-- Sample clock ("large cycle" clock)

			-- Data and address I/O for using the buffer as output buffer:
			rw_data_in		: in std_logic_vector(15 downto 0);						-- B data input
			rw_data_out		: out std_logic_vector(data_width - 1 downto 0);	-- B data output
			rw_off_address	: in std_logic_vector(address_width - 1 downto 0);	-- Address offset for B-buffer
			write_en		: in std_logic;	-- Write enable for writing data from data_in to address address_in

			-- Data and address I/O for using the buffer as input buffer:
			ro_data_out		: out std_logic_vector(data_width - 1 downto 0);	-- A data output
			ro_off_address	: in std_logic_vector(address_width - 1 downto 0);	-- Address offset for the A-buffer

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
			constant_read_address : out std_logic_vector(15 downto 0)
		);
	end component;

	-- Pipeline control register:
	type pipeline_control_register is record
			enabled : std_logic;
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

	-- Constant arbitration unit read address, passed to the constant memory:
	signal arbiter_read_address : std_logic_vector(15 downto 0);

	-- Signals from the internal bus to the instruction memories of the cores:
	type core_instr_address_array is array(NUMBER_OF_CORES - 1 downto 0) of std_logic_vector(15 downto 0);
	signal core_instr_address : core_instr_address_array;
	type core_instr_we_array is array(NUMBER_OF_CORES - 1 downto 0) of std_logic;
	signal core_instr_write_enable : core_instr_we_array;
	type core_instr_data_array is array(NUMBER_OF_CORES - 1 downto 0) of std_logic_vector(15 downto 0);
	signal core_instr_read_data : core_instr_data_array;

	-- Signals for the input buffer:
	signal input_buffer_out, input_buffer_rodata_out : std_logic_vector(31 downto 0);
	signal input_buffer_write_enable : std_logic;
	signal input_buffer_roaddress, input_buffer_out_address : std_logic_vector(15 downto 0);
begin
	pipeline_control.enabled <= '1';
	pipeline_control.num_cores <= std_logic_vector(to_unsigned(NUMBER_OF_CORES, 5));

	-- TODO: The below process is just to make things synthesize and a suggestion for memory mapping.
	internal_bus_process: process(clk, int_re, int_we)
	begin
		if rising_edge(clk) then

			-- Internal bus read:
			if int_re = '1' then
				if int_address.pipeline = pipeline_address then
					case to_integer(unsigned(int_address.device)) is
						when 0 =>
							int_data_out(15) <= pipeline_control.enabled;
							int_data_out(14 downto 5) <= (others => '0');
							int_data_out(4 downto 0) <= pipeline_control.num_cores;
						when 1 => -- Input buffer
							int_data_out <= input_buffer_out(15 downto 0);
						when 2 => -- Output buffer
						when 3 => -- Constant memory
							int_data_out <= constant_data_out(15 downto 0);
						when others => -- Cores and stuff?
					end case;
				end if;
			end if;

			-- Internal bus write:
			if int_we = '1' then
				if int_address.pipeline = pipeline_address then
					case to_integer(unsigned(int_address.device)) is
						when 0 =>
							-- Pipeline control register is read-only?
						when 1 => -- Input buffer
							input_buffer_write_enable <= '1';
						when 2 => -- Ouput buffer
						when 3 => -- Constant memory
							constant_write_enable <= '1';
						when others => -- Cores and stuff
							core_instr_address(to_integer(unsigned(int_address.device) - 3)) <= int_address.address(15 downto 0);
							core_instr_write_enable(to_integer(unsigned(int_address.device) - 3)) <= '1';
					end case;
				end if;
			else
				for i in 0 to NUMBER_OF_CORES - 1 loop
					core_instr_write_enable(i) <= '0';
				end loop;
				input_buffer_write_enable <= '0';
				constant_write_enable <= '0';
			end if;
		end if;
	end process;

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
			constant_read_address => arbiter_read_address
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
					constant_addr => open, -- Should be connected to the constant memory arbitration unit
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
