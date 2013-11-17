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
		bus_clk     : in std_logic;

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
	component constant_memory is
		generic (
			size : natural -- Number of 16 bit words to store
		);
		port (
			--clk            : in  std_logic; -- System clock input, ICE
			memclk         : in  std_logic; -- Clock signal
			read_address_a : in  std_logic_vector(DMEM_ADDR_SIZE-1 downto 0); -- Read address A
			read_data_a    : out std_logic_vector(31 downto 0); -- Data read A
			read_address_b : in  std_logic_vector(DMEM_ADDR_SIZE-1 downto 0); -- Read address B
			read_data_b    : out std_logic_vector(31 downto 0); -- Read data B
			write_address  : in  std_logic_vector(DMEM_ADDR_SIZE-1 downto 0); -- Write address
			write_data     : in  std_logic_vector(15 downto 0); -- Data to write
			write_enable   : in  std_logic -- Take a guess
		);
	end component;

	component core is
		generic(
        instruct_data_size  : natural := 16;
        reg_addr_size       : natural := 5;
        reg_data_size       : natural := 16;
        memory_data_size    : natural := 32;
        memory_addr_size    : natural := 16
		);
		port(
			clk                 : in std_logic; -- Small cycle clock signal

			pl_stop_core        : in std_logic;
			reset               : in std_logic; -- Resets the processor core

			proc_finished       : out std_logic := '0';
			-- Connection to instruction memory:
			instruction_addr    : out std_logic_vector(IMEM_ADDR_SIZE - 1 downto 0);
			instruction_data    : in  std_logic_vector(instruct_data_size - 1 downto 0);

			-- Connections to the constant memory controller:
			constant_addr       : out std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0);
			constant_data       : in  std_logic_vector(memory_data_size - 1 downto 0);

			-- Connections to the input buffer:
			input_read_addr     : out std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0);
			input_read_data     : in  std_logic_vector(memory_data_size - 1 downto 0);

			-- Connections to the output buffer:
			output_write_addr   : out std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0);
			output_write_data   : out std_logic_vector(memory_data_size - 1 downto 0);
			output_we           : out std_logic;
			
			output_read_addr    : out std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0);
			output_read_data    : in  std_logic_vector(memory_data_size - 1 downto 0)
		);
	end component;

	component instruction_memory is
		generic (
			size : natural -- Number of 16 bit words to store
		);
		port (
			memclk        : in  std_logic; -- Clock signal
			read_address  : in  std_logic_vector(IMEM_ADDR_SIZE-1 downto 0); -- Read address
			read_data     : out std_logic_vector(15 downto 0); -- Data read
			write_address : in  std_logic_vector(IMEM_ADDR_SIZE-1 downto 0); -- Write address
			write_data    : in  std_logic_vector(15 downto 0); -- Data to write
			write_enable  : in  std_logic -- Take a guess
		);
	end component;

	component ringbuffer is
		generic(
			data_width		: natural := 32;   -- Width of a buffer word
			address_width	: natural := 16;   -- Width of the address inputs
			buffer_size		: natural := 1024; -- Size of the buffer, in words
			window_size		: natural := 512   -- Size of the ring buffer window, in words
		);
		port(
			memclk		: in std_logic; -- Memory clock
			sample_clk	: in std_logic; -- Sample clock ("large cycle" clock)

			reset       : in std_logic; -- Resets the addresses

			-- Data and address I/O for using the buffer as output buffer:
			b_data_in     : in  std_logic_vector(data_width - 1 downto 0);    -- B data input
			b_data_out    : out std_logic_vector(data_width - 1 downto 0);    -- B data output
			b_off_address : in  std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0); -- Address offset for B-buffer
			b_we          : in  std_logic; -- Write enable for writing data from data_in to address address_in

			-- Data and address I/O for using the buffer as input buffer:
			a_data_out    : out std_logic_vector(data_width - 1 downto 0);    -- A data output
			a_off_address : in  std_logic_vector(DMEM_ADDR_SIZE - 1 downto 0); -- Address offset for the A-buffer

			mode			: in ringbuffer_mode	-- Buffer mode
		);
	end component;

	-- Pipeline control register:
	signal control_register : pipeline_control_register := (num_cores => std_logic_vector(to_unsigned(NUMBER_OF_CORES, 4)),
		stopmode => '1', reset => '0', constcore_1 => b"0000", constcore_2 => b"0000");

	-- Zero-extended internal bus address:
	signal internal_dest_address : std_logic_vector(15 downto 0);
	-- Zero-extended internal bus device:
	signal internal_device : std_logic_vector(15 downto 0);
	signal internal_core : std_logic_vector(15 downto 0);

	-- Processor control signals:
	signal processor_reset, processor_stop : std_logic_vector(0 to NUMBER_OF_CORES - 1);

	-- Constant memory signals:
	signal constmem_write_enable : std_logic := '0';
	signal constmem_address_array : d_address_array(0 to NUMBER_OF_CORES - 1); -- Constant memory address array, from cores
	signal constmem_data_array : data_array_32(0 to NUMBER_OF_CORES - 1);       -- Constant memory read data, to cores
	signal constmem_write_address : std_logic_vector(DMEM_ADDR_SIZE-1 downto 0);
	signal constmem_read_address_a, constmem_read_address_b : std_logic_vector(DMEM_ADDR_SIZE-1 downto 0);
	signal constmem_read_data_a, constmem_read_data_b : std_logic_vector(31 downto 0);

	-- Instruction memory signals:
	signal instr_read_address : i_address_array(0 to NUMBER_OF_CORES - 1);
	signal instr_read_data : data_array_16(0 to NUMBER_OF_CORES - 1);
	signal instr_write_address : std_logic_vector(IMEM_ADDR_SIZE-1 downto 0);
	signal instr_write_enable : std_logic_vector(0 to NUMBER_OF_CORES - 1);

	-- Input buffer signals:
	signal input_read_address : d_address_array(-1 to NUMBER_OF_CORES - 1);
	signal input_read_data : data_array_32(-1 to NUMBER_OF_CORES - 1);
	signal input_write_data : std_logic_vector(31 downto 0);
	signal input_write_enable : std_logic := '0';

	-- Output buffer signals:
	signal output_read_address : d_address_array(0 to NUMBER_OF_CORES - 1);
	signal output_read_data : data_array_32(0 to NUMBER_OF_CORES - 1);
	signal output_write_address : d_address_array(0 to NUMBER_OF_CORES - 1);
	signal output_write_data : data_array_32(0 to NUMBER_OF_CORES - 1);
	signal output_write_enable : std_logic_vector(0 to NUMBER_OF_CORES - 1);

	-- Sample clock reset pulse:
	signal prev_sample_clk_value, reset_pulse : std_logic := '0';

	-- Core control registers:
	signal core_control_registers : core_control_register_array(0 to NUMBER_OF_CORES - 1) :=
		(others => (reset => '0', stopmode => '0', instruction_memory_size => std_logic_vector(to_unsigned(log2(IMEM_SIZE), 5)),
			finished => 'Z'));
begin
	-- Zero-extended internal signals:
	internal_dest_address <= b"00" & int_address.address;
	internal_device <= b"000000000000" & int_address.device;

	-- Adder getting the number of core being addressed over the internal bus:
	internal_core <= std_logic_vector(unsigned(internal_device) - x"0004");

	-- Internal bus read process:
	internal_bus_read: process(bus_clk, int_re)
	begin
		if falling_edge(bus_clk) then
			if int_re = '1' then
				if int_address.toplevel = '0' and int_address.pipeline = pipeline_address then
					case int_address.device is
						when x"0" =>
							int_data_out <= control_register.constcore_1 & control_register.constcore_2 &
								control_register.stopmode & control_register.reset & b"00" & control_register.num_cores;
						when x"1" => -- Constant memory is write-only
							int_data_out <= (others => '0');
						when x"2" => -- Input buffer is write-only?
							int_data_out <= (others => '0');
						when x"3" => -- Read the output buffer
							int_data_out <= input_read_data(NUMBER_OF_CORES - 1)(15 downto 0);
						when others =>
							-- Read core memories
							case int_address.coredev is
								when b"00" =>
									int_data_out <=
										core_control_registers(to_integer(unsigned(internal_core))).instruction_memory_size
										& b"00000000" & core_control_registers(to_integer(unsigned(internal_core))).finished
										& core_control_registers(to_integer(unsigned(internal_core))).stopmode
										& core_control_registers(to_integer(unsigned(internal_core))).reset;
								when others =>
									int_data_out <= (others => '0');
							end case;
					end case;
				end if;
			end if;
		end if;
	end process;

	-- Internal bus write process:
	internal_bus_write: process(bus_clk, int_we)
	begin
		if rising_edge(bus_clk) then
			if int_we = '1' then
				if int_address.toplevel = '0' and int_address.pipeline = pipeline_address then
					case int_address.device is
						when x"0" =>
							control_register.constcore_1 <= int_data_in(15 downto 12);
							control_register.constcore_2 <= int_data_in(11 downto 8);
							control_register.stopmode <= int_data_in(7);
							control_register.reset <= int_data_in(6);
						when x"1" =>
							constmem_write_enable <= '1';
						when x"2" =>
							input_write_enable <= '1';
						when x"3" =>
							-- Write the output buffer
						when others =>
							-- Write core memories
							case int_address.coredev is
								when b"00" =>
									core_control_registers(to_integer(unsigned(internal_core))).reset <=
										int_data_in(0);
									core_control_registers(to_integer(unsigned(internal_core))).stopmode <=
										int_data_in(1);
								when b"01" =>
									instr_write_enable(to_integer(unsigned(internal_core))) <= '1';
								when others =>
							end case;
					end case;
				end if;
			else
				constmem_write_enable <= '0';
				input_write_enable <= '0';
				for i in 0 to NUMBER_OF_CORES - 1 loop
					instr_write_enable(i) <= '0';
				end loop;
			end if;
		end if;
	end process;

	resetter: process(clk)
	begin
		if rising_edge(clk) then
			if reset_pulse = '1' then
				reset_pulse <= '0';
			elsif prev_sample_clk_value /= sample_clk then
				reset_pulse <= '1';
				prev_sample_clk_value <= sample_clk;
			end if;
		end if;
	end process resetter;

	-- Instantiate the constant memory:
	const_mem: constant_memory
		generic map(size => 1024)
		port map(
			--clk => clk,
			memclk => memory_clk,
			write_address => internal_dest_address(DMEM_ADDR_SIZE-1 downto 0),
			write_data => int_data_in,
			write_enable => constmem_write_enable,
			read_address_a => constmem_read_address_a,
			read_data_a => constmem_read_data_a,
			read_address_b => constmem_read_address_b,
			read_data_b => constmem_read_data_b
		);

	-- Big mux controlling access to the constant memory:
--	megamux: process(constmem_read_data_a, constmem_read_data_b,
--		constmem_address_array, constmem_data_array, control_register)
--	begin
--		for i in 0 to NUMBER_OF_CORES - 1 loop
--			if i = to_integer(unsigned(control_register.constcore_1)) then
--				constmem_data_array(i) <= constmem_read_data_a;
--				constmem_read_address_a <= constmem_address_array(i);
--			elsif i = to_integer(unsigned(control_register.constcore_2)) then
--				constmem_data_array(i) <= constmem_read_data_b;
--				constmem_read_address_b <= constmem_address_array(i);
--			else
--				constmem_data_array(i) <= (others => '0');
--				constmem_read_address_a <= (others => '0');
--				constmem_read_address_b <= (others => '0');
--			end if;
--		end loop;
--	end process;
	
	constmem_mux: process(control_register.constcore_1, control_register.constcore_2, constmem_read_data_a,
		constmem_read_data_b, constmem_address_array)
	begin
		constmem_data_array <= (others => (others => '0'));
		constmem_data_array(to_integer(unsigned(control_register.constcore_1))) <= constmem_read_data_a;
		constmem_data_array(to_integer(unsigned(control_register.constcore_2))) <= constmem_read_data_b;
		constmem_read_address_a <= constmem_address_array(to_integer(unsigned(control_register.constcore_1)));
		constmem_read_address_b <= constmem_address_array(to_integer(unsigned(control_register.constcore_2)));
	end process constmem_mux;

	-- Instantiate the input buffer:
	input_write_data <= x"0000" & int_data_in;
	input_buffer: ringbuffer
		port map(
			memclk => memory_clk,
			sample_clk => reset_pulse,
			reset => control_register.reset,
			b_data_in => input_write_data,
			b_data_out => open,
			b_off_address => internal_dest_address(DMEM_ADDR_SIZE-1 downto 0),
			b_we => input_write_enable,
			a_data_out => input_read_data(-1),
			a_off_address => input_read_address(-1),
			mode => NORMAL_MODE
		);

	-- Set up the output buffer signals:
	input_read_address(NUMBER_OF_CORES - 1) <= internal_dest_address(DMEM_ADDR_SIZE-1 downto 0);

	generate_cores: for i in 0 to NUMBER_OF_CORES - 1 generate
		-- Instruction memory:
		instruction_mem: instruction_memory
			generic map(size => 512)
			port map(
				memclk => memory_clk,
				write_address => internal_dest_address(IMEM_ADDR_SIZE-1 downto 0),
				write_data => int_data_in,
				write_enable => instr_write_enable(i),
				read_address => instr_read_address(i),
				read_data => instr_read_data(i)
			);

		-- Core:
		processor_reset(i) <= core_control_registers(i).reset or control_register.reset or reset_pulse;
		processor_stop(i) <= core_control_registers(i).stopmode or control_register.stopmode;
		processor_core: core
			port map(
				clk => clk,
				reset => processor_reset(i),
				pl_stop_core => processor_stop(i),
				proc_finished => core_control_registers(i).finished,
				constant_addr => constmem_address_array(i),
				constant_data => constmem_data_array(i),
				instruction_addr => instr_read_address(i),
				instruction_data => instr_read_data(i),
				input_read_addr => input_read_address(i - 1),
				input_read_data => input_read_data(i - 1),
				output_write_addr => output_write_address(i),
				output_write_data => output_write_data(i),
				output_we => output_write_enable(i),
				output_read_addr => output_read_address(i),
				output_read_data => output_read_data(i)
			);

		-- Output buffer:
		output_buffer: ringbuffer
			generic map(data_width => 32, address_width => 16)
			port map(
				memclk => memory_clk,
				sample_clk => reset_pulse,
				reset => control_register.reset,
				b_data_in => output_write_data(i),
				b_data_out => output_read_data(i),
				b_off_address => output_write_address(i),
				b_we => output_write_enable(i),
				a_data_out => input_read_data(i),
				a_off_address => input_read_address(i),
				mode => NORMAL_MODE
			);
	end generate;

end behaviour;
