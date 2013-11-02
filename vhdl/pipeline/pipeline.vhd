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
			buffer_address_width : natural := 16;   -- Buffer address bus width
			const_address_width  : natural := 16;   -- Constant memory address width (minimum log2(constant memory size)).
			instr_memory_size    : natural := 1024; -- Instruction memory size
			instr_address_width  : natural := 16    -- Instruction memory address width (minimum log2(instr_memory_size)).
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

	signal control_register : pipeline_control_register;
begin
	control_register.num_cores <= std_logic_vector(to_unsigned(NUMBER_OF_CORES, 4));

	-- Internal bus read process:
	internal_bus_read: process(clk, int_re)
	begin
		if rising_edge(int_re) then
			if int_address.toplevel = '0' and int_address.pipeline = pipeline_address then
				case int_address.device is
					when b"0000" =>
						int_data_out <= b"000000000000" & control_register.num_cores;
					when b"0001" =>
						-- Read constant memory
					when others =>
						-- Read core memory
				end case;
			end if;
		end if;
	end process;

	-- Internal bus write process:
	internal_bus_write: process(clk, int_we)
	begin
		if rising_edge(int_we) then
			if int_address.toplevel = '0' and int_address.pipeline = pipeline_address then
				case int_address.device is
					when b"0000" =>
						-- The control register is currently read only.
					when b"0001" =>
						-- Write constant memory
					when others =>
						-- Write core memory
				end case;
			end if;
		end if;
	end process;

	generate_cores:
	for i in 0 to NUMBER_OF_CORES - 1 generate
		-- Input buffer:
		--input_buffer:
		-- Output buffer:
		--output_buffer:
		-- Core:
		--processor_core: 
	end generate;

end behaviour;
