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
	component constant_memory is
		generic (
			size : natural -- Number of 16 bit words to store
		);
		port (
			clk            : in  std_logic; -- System clock input, ICE
			memclk         : in  std_logic; -- Clock signal
			read_address_a : in  std_logic_vector(15 downto 0); -- Read address A
			read_data_a    : out std_logic_vector(31 downto 0); -- Data read A
			read_address_b : in  std_logic_vector(15 downto 0); -- Read address B
			read_data_b    : out std_logic_vector(31 downto 0); -- Read data B
			write_address  : in  std_logic_vector(15 downto 0); -- Write address
			write_data     : in  std_logic_vector(15 downto 0); -- Data to write
			write_enable   : in  std_logic -- Take a guess
		);
	end component;

	component core is
		generic(
			address_width : natural := 16
		);

		port(
			clk					: in std_logic; -- Small cycle clock signal
			memclk				: in std_logic; -- Memory clock signal
			sample_clk			: in std_logic; -- Reset signal, "large cycle" clock signal

			reset				: in std_logic; -- Resets the processor core

			-- Connections to the constant memory controller:
			constant_addr		: out std_logic_vector(address_width - 1 downto 0);
			constant_data		: in  std_logic_vector(31 downto 0);

			-- Connections to the input buffer:
			input_read_addr		: out std_logic_vector(address_width - 1 downto 0);
			input_read_data		: in  std_logic_vector(31 downto 0);
			input_re			: out std_logic;

			-- Connections to the output buffer:
			output_write_addr	: out std_logic_vector(address_width - 1 downto 0);
			output_write_data	: out std_logic_vector(31 downto 0);
			output_we			: out std_logic;
			
			output_read_address	: out std_logic_vector(address_width - 1 downto 0);
			output_read_data	: in  std_logic_vector(31 downto 0);
			output_re			: out std_logic
		);
	end component;

	-- Pipeline control register:
	signal control_register : pipeline_control_register;

	-- Constant memory signals:
	signal constmem_write_enable : std_logic := '0';
	signal constmem_address_array : address_array(0 to NUMBER_OF_CORES); -- Constant memory address array, from cores
	signal constmem_data_array : data_array_32(0 to NUMBER_OF_CORES);       -- Constant memory read data, to cores
	signal constmem_write_address : std_logic_vector(15 downto 0);
	signal constmem_read_address_a, constmem_read_address_b : std_logic_vector(15 downto 0);
	signal constmem_read_data_a, constmem_read_data_b : std_logic_vector(31 downto 0);
begin
	control_register.num_cores <= std_logic_vector(to_unsigned(NUMBER_OF_CORES, 4));

	-- Internal bus read process:
	internal_bus_read: process(clk, int_re)
	begin
		if rising_edge(int_re) then
			if int_address.toplevel = '0' and int_address.pipeline = pipeline_address then
				case int_address.device is
					when b"0000" =>
						int_data_out <= control_register.constcore_1 & control_register.constcore_2 & b"0000" & control_register.num_cores;
					when b"0001" =>
						int_data_out <= constmem_read_data_a(15 downto 0); -- Remove after testing
					when b"0010" =>
						int_data_out <= constmem_read_data_a(31 downto 16); -- Remove after testing
					when b"0011" =>
						int_data_out <= constmem_read_data_b(15 downto 0); -- Remove after testing
					when b"0100" =>
						int_data_out <= constmem_read_data_b(31 downto 16); -- Remove after testing
					when others =>
						-- Read core memory
				end case;
			end if;
		end if;
	end process;

	-- Internal bus write process:
	internal_bus_write: process(clk, int_we)
	begin
		if rising_edge(clk) then
			if int_we = '1' then
				if int_address.toplevel = '0' and int_address.pipeline = pipeline_address then
					case int_address.device is
						when b"0000" =>
							control_register.constcore_1 <= int_data_in(15 downto 12);
							control_register.constcore_2 <= int_data_in(11 downto 8);
						when b"0001" =>
							constmem_write_enable <= '1';
						when others =>
							-- Write core memory
					end case;
				end if;
			else
				constmem_write_enable <= '0';
			end if;
		end if;
	end process;

	-- Instantiate the constant memory:
	constmem_write_address <= b"00" & int_address.address;
	const_mem: constant_memory
		generic map(size => 1024)
		port map(
			clk => clk,
			memclk => memory_clk,
			write_address => constmem_write_address,
			write_data => int_data_in,
			write_enable => constmem_write_enable,
			read_address_a => constmem_read_address_a,
			read_data_a => constmem_read_data_a,
			read_address_b => constmem_read_address_b,
			read_data_b => constmem_read_data_b
		);

	megamux: process(constmem_read_data_a, constmem_read_data_b,
		constmem_address_array, constmem_data_array)
	begin
		for i in 0 to NUMBER_OF_CORES - 1 loop
			if i = to_integer(unsigned(control_register.constcore_1)) then
				constmem_data_array(i) <= constmem_read_data_a;
				constmem_read_address_a <= constmem_address_array(i);
			elsif i = to_integer(unsigned(control_register.constcore_2)) then
				constmem_data_array(i) <= constmem_read_data_b;
				constmem_read_address_b <= constmem_address_array(i);
			else
				constmem_data_array(i) <= (others => '0');
			end if;
		end loop;
	end process;

	generate_cores:
	for i in 0 to NUMBER_OF_CORES - 1 generate
		-- Input buffer:
		--input_buffer:
		-- Output buffer:
		--output_buffer:

		-- Instruction memory:

		-- Core:
		processor_core: core
			generic map(address_width => 16)
			port map(
				clk => clk,
				memclk => memory_clk,
				sample_clk => sample_clk,
				reset => '0',
				constant_addr => constmem_address_array(i),
				constant_data => constmem_data_array(i),
				input_read_addr => open,
				input_read_data => (others => '0'),
				input_re => open,
				output_write_addr => open,
				output_write_data => open,
				output_we => open,
				output_read_address => open,
				output_read_data => (others => '0'),
				output_re => open
			);
	end generate;

end behaviour;
