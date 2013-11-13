-- Toplevel processor core module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

library work;
use work.core_constants.all;
use work.internal_bus.all;

entity core is
    generic(
        instruct_addr_size  : natural := 16;
        instruct_data_size  : natural := 16;
        reg_addr_size       : natural := 5;
        reg_data_size       : natural := 16;
        memory_data_size    : natural := 32;
        memory_addr_size    : natural := 16
    );

    port(
        clk                 : in std_logic; -- Small cycle clock signal
        memclk              : in std_logic; -- Memory clock signal
        sample_clk          : in std_logic; -- Reset signal, "large cycle" clock signal
			
        reset               : in std_logic; -- Resets the processor core
        
		  proc_finished       : out std_logic := '0';
        -- Connection to instruction memory:
        instruction_addr    : out std_logic_vector(instruct_addr_size - 1 downto 0);
        instruction_data    : in  std_logic_vector(instruct_data_size - 1 downto 0);
        
        -- Connections to the constant memory controller:
        constant_addr       : out std_logic_vector(memory_addr_size - 1 downto 0);
        constant_data       : in  std_logic_vector(memory_data_size - 1 downto 0);

        -- Connections to the input buffer:
        input_read_addr     : out std_logic_vector(memory_addr_size - 1 downto 0);
        input_read_data     : in  std_logic_vector(memory_data_size - 1 downto 0);

        -- Connections to the output buffer:
        output_write_addr   : out std_logic_vector(memory_addr_size - 1 downto 0);
        output_write_data   : out std_logic_vector(memory_data_size - 1 downto 0);
        output_we           : out std_logic;
        
        output_read_addr    : out std_logic_vector(memory_addr_size - 1 downto 0);
        output_read_data    : in  std_logic_vector(memory_data_size - 1 downto 0)
    );
end entity;

architecture behaviour of core is

   signal stop_core_signal : STD_LOGIC;

--********* Stage 1 - PC *********
    component adder is
        port (
            a, b    : in    std_logic_vector(reg_data_size-1 downto 0);
            c       : in    std_logic;
            result  : out   std_logic_vector(reg_data_size-1 downto 0);
            flags   : out   alu_flags
        );
    end component;
    --Pipeline registers for stage 1
    signal pc_reg           : std_logic_vector(reg_data_size-1 downto 0);
    signal pc_inc           : std_logic_vector(reg_data_size-1 downto 0);
    signal pc_we            : std_logic;
    
    signal branch_enable    : std_logic;
	 signal do_branch        : std_logic;
    signal branch_target    : std_logic_vector(9 downto 0);
    
--********* Stage 2 - Control unit and register file *********
    component control_unit is
        port (  
            opt_code            : in    std_logic_vector (5 downto 0);
		      
				stop_core           : out STD_LOGIC;
            alu_op              : out alu_operation;
            reg_write_e         : out register_write_enable;
            wb_src              : out wb_source;
            mem_src             : out mem_source;
            output_write_enable : out std_logic;
            add_imm             : out std_logic;
            load_const          : out std_logic;
            branch_enable       : out std_logic
        );
    end component;
    
    component register_file is
        port(
            clk             : in std_logic;

            reg_1_address   : in std_logic_vector(reg_addr_size-1 downto 0);
            reg_2_address   : in std_logic_vector(reg_addr_size-1 downto 0);
            write_address   : in std_logic_vector(reg_addr_size-1 downto 0);

            data_in         : in std_logic_vector(31 downto 0);

            write_reg_enb   : in register_write_enable;

            reg_1_data      : out std_logic_vector(reg_data_size-1 downto 0);
            reg_1b_data     : out std_logic_vector(reg_data_size-1 downto 0); 
            reg_2_data      : out std_logic_vector(reg_data_size-1 downto 0)

        );
    end component register_file;
    
    -- signals
    -- data signals
    signal id_imm_value         : std_logic_vector(memory_data_size-1 downto 0);
	 signal id_branch_flags      : std_logic_vector(3 downto 0);
    
    -- addr signals
    signal id_reg_1_addr        : std_logic_vector( reg_addr_size-1 downto 0);
    signal id_reg_2_addr        : std_logic_vector( reg_addr_size-1 downto 0);
    signal id_spec_addr         : std_logic_vector( reg_addr_size-1 downto 0);
    
    -- control signals
    signal id_bubble            : std_logic;
    signal id_alu_op            : alu_operation;
    signal id_reg_we            : register_write_enable;
    signal id_reg_wb_src        : wb_source;
    signal id_mem_slct          : mem_source;
    signal id_output_we         : std_logic;
    signal id_add_imm           : std_logic;
    signal id_load_const        : std_logic;

        
--********* Stage 3 - Memory access / MEM *********
    component forwarding_unit_mem is
        Port (
            reg_we		: in register_write_enable;
            
            wb_reg_1_addr,
            reg_1_addr,
            reg_2_addr	: in std_logic_vector(4 downto 0);
            
            data_1_in,
            data_1b_in,
            data_2_in   : in std_logic_vector(15 downto 0);
            
            data_1_out,
            data_1b_out,
            data_2_out	: out std_logic_vector(15 downto 0);
            
            data_wb_in	: in std_logic_vector(31 downto 0)
        );
    end component;
        
    -- data signals
    -- data signals
    signal mem_reg_1_data       : std_logic_vector(reg_data_size-1 downto 0);
    signal mem_reg_1b_data      : std_logic_vector(reg_data_size-1 downto 0);
    signal mem_reg_2_data       : std_logic_vector(reg_data_size-1 downto 0);
    signal mem_fw_1             : std_logic_vector(reg_data_size-1 downto 0);
    signal mem_fw_1b            : std_logic_vector(reg_data_size-1 downto 0);
    signal mem_fw_2             : std_logic_vector(reg_data_size-1 downto 0);
    signal mem_imm_value        : std_logic_vector(memory_data_size-1 downto 0);
    signal mem_mem_value        : std_logic_vector(memory_data_size-1 downto 0);
    -- address signals
    signal mem_reg_1_addr       : std_logic_vector( reg_addr_size-1 downto 0);
    signal mem_reg_2_addr       : std_logic_vector( reg_addr_size-1 downto 0);
    
    -- control signals
    signal mem_alu_op           : alu_operation;
    signal mem_reg_we           : register_write_enable;
    signal mem_reg_wb_src       : wb_source;
    signal mem_mem_slct         : mem_source;
    signal mem_output_we        : std_logic;
    signal mem_add_imm          : std_logic;
    signal mem_load_const       : std_logic;
        
-- ********* Stage 4 - ALU *********
    component alu is
        port (
            -- CLK
            dsp_clk, cpu_clk        : in    std_logic;
            -- ALU input data:
            cpu_input_register_1    : in    std_logic_vector(reg_data_size-1 downto 0);
            cpu_input_register_2    : in    std_logic_vector(reg_data_size-1 downto 0);
            cpu_input_const         : in    std_logic_vector(memory_data_size-1 downto 0);
            cpu_input_const_w       : in    std_logic;
            -- ALU control:
            operation               : in    alu_operation;
            -- ALU result data:
            result                  : out   std_logic_vector(31 downto 0);
            flags                   : out   alu_flags
        );
    end component;
	 
	 component forwarding_unit_ex is
    Port (
			reg_we		: in register_write_enable;
            
			wb_reg_1_addr,
			reg_1_addr,
			reg_2_addr	: in std_logic_vector(4 downto 0);
			
			data_1_in,
			data_2_in   : in std_logic_vector(15 downto 0);
            
			data_1_out,
			data_2_out	: out std_logic_vector(15 downto 0);
            
			data_wb_in	: in std_logic_vector(15 downto 0)
    );
	end component;
    
    
    -- signals
    -- data signals
    signal ex_reg_1_data        : std_logic_vector(reg_data_size-1 downto 0);
    signal ex_reg_1b_data       : std_logic_vector(reg_data_size-1 downto 0);
    signal ex_reg_2_data        : std_logic_vector(reg_data_size-1 downto 0);
    signal ex_fw_1              : std_logic_vector(reg_data_size-1 downto 0);
    signal ex_fw_1b             : std_logic_vector(reg_data_size-1 downto 0);
    signal ex_fw_2              : std_logic_vector(reg_data_size-1 downto 0);
    signal ex_imm_value         : std_logic_vector(memory_data_size-1 downto 0);
    signal ex_mem_value         : std_logic_vector(memory_data_size-1 downto 0);
    signal ex_alu_result        : std_logic_vector(memory_data_size-1 downto 0);
    signal ex_wb_data           : std_logic_vector(memory_data_size-1 downto 0);
    signal ex_alu_flags         : alu_flags;
    -- addr signals
    signal ex_reg_1_addr        : std_logic_vector( reg_addr_size-1 downto 0);
    signal ex_reg_2_addr        : std_logic_vector( reg_addr_size-1 downto 0);
   
    -- control signals
    signal ex_alu_op            : alu_operation;
    signal ex_reg_we            : register_write_enable;
    signal ex_reg_wb_src        : wb_source;
    signal ex_load_const        : std_logic;
    
    -- ****** STAGE 5, write back *******

    -- data signals
    signal wb_data              : std_logic_vector(memory_data_size-1 downto 0);
    signal wb_flags             : alu_flags; 
    
    -- addr signals
    signal wb_reg_1_addr        : std_logic_vector(reg_addr_size-1 downto 0);
    signal wb_reg_2_addr        : std_logic_vector(reg_addr_size-1 downto 0);
    
    -- control signals
    signal wb_reg_we            : register_write_enable;    
--Other

begin
	 
	 
	 stop_core : process(reset, stop_core_signal) 
	 begin
	     if reset = '1' then
		      proc_finished <= '0';
		  elsif stop_core_signal = '1' then
		      proc_finished <= '1';
		  end if;
	 end process;
	 
--Pipeline: IF
    pc_incrementer : adder
    port map(
        a       => pc_reg,
        b       => x"0000",
        c       => '1',
        result  => pc_inc,
		flags	=> open
    );
	 
	 evaluate_branch : process(branch_enable, wb_flags, id_branch_flags)
	 begin
        if (branch_enable = '1') then
		      if (id_branch_flags(3) = '1' and wb_flags.zero = '1')
				or (id_branch_flags(2) = '1' and wb_flags.carry ='1')
				or (id_branch_flags(1) = '1' and wb_flags.overflow = '1')
				or (id_branch_flags(0) = '1' and wb_flags.negative = '1') then
				    do_branch <= '1';
				else
				    do_branch <= '0';
			   end if;
		  else
		      do_branch <= '0';
		  end if;
	 end process;
	 
    pc : process(clk)
    begin
        if rising_edge(clk) then
            if do_branch = '1' then
                pc_reg <= ext(branch_target, instruct_addr_size);
            else
                pc_reg <= pc_inc;
            end if;
        end if;
    end process;
    
    instruction_addr <= pc_reg;

--Pipeline: ID
    branch_target <= instruction_data(9 downto 0);
    id_branch_flags <= instruction_data(13 downto 10);
    control_u : control_unit
    port map(
        opt_code            => instruction_data(15 downto 10),
        
		  stop_core           => stop_core_signal,
        alu_op              => id_alu_op,
        reg_write_e         => id_reg_we,
        wb_src              => id_reg_wb_src,
        mem_src             => id_mem_slct,
        output_write_enable => id_output_we,
        add_imm				 => id_add_imm,
        load_const          => id_load_const,
        branch_enable       => branch_enable
    );
    
    regfile : register_file
    port map(
        clk             => clk,

        reg_1_address   => instruction_data(9 downto 5),
        reg_2_address   => instruction_data(4 downto 0),
        write_address   => wb_reg_1_addr,

        data_in         => wb_data,

        write_reg_enb   => wb_reg_we,

        reg_1_data      => mem_reg_1_data,
        reg_1b_data     => mem_reg_1b_data,
        reg_2_data      => mem_reg_2_data
    );

    
    -- signal mappings
    id_imm_value <= sxt(instruction_data(13 downto 0), 32);
	 id_reg_1_addr <= instruction_data(9 downto 5);
	 id_reg_2_addr <= instruction_data(4 downto 0);

    
    pipeline_id_mem_reg : process(clk)
    begin
        if rising_edge(clk) then
            
            mem_imm_value   <= id_imm_value;    
            mem_reg_1_addr  <= id_reg_1_addr;
            mem_reg_2_addr  <= id_reg_2_addr;
        
            mem_alu_op      <= id_alu_op;
            mem_reg_we      <= id_reg_we;
            mem_reg_wb_src  <= id_reg_wb_src;
            mem_mem_slct    <= id_mem_slct;
            mem_output_we   <= id_output_we;
            mem_add_imm     <= id_add_imm;
            mem_load_const  <= id_load_const; 
        end if;
    end process;

--Pipeline: MEM
    mem_forward_unit : forwarding_unit_mem
    port map (
        --MEM
        --addr in
        reg_1_addr          => mem_reg_1_addr,
        reg_2_addr	        => mem_reg_2_addr,
        --data in
        data_1_in           => mem_reg_1_data,
        data_1b_in          => mem_reg_1b_data,
        data_2_in           => mem_reg_2_data,
        --data out
        data_1_out          => mem_fw_1,
        data_1b_out         => mem_fw_1b,
        data_2_out          => mem_fw_2,
        --WB
        reg_we		        => wb_reg_we,
        
        wb_reg_1_addr       => wb_reg_1_addr,
        data_wb_in          => wb_data
    );

    mem_memselect_mux : process(mem_mem_slct, input_read_data, constant_data, output_read_data)
    begin
        case mem_mem_slct is
            when MEM_INPUT =>
                mem_mem_value <= input_read_data;
            when MEM_OUTPUT =>
                mem_mem_value <= output_read_data;
            when MEM_CONST =>
                mem_mem_value <= constant_data;
            when others =>
                mem_mem_value <= constant_data;
        end case;
    end process;

    -- signal mapping
	 output_write_data <= mem_fw_1b & mem_fw_1;
	 output_we <= mem_output_we;
    input_read_addr <= mem_fw_2;
    output_read_addr <= mem_fw_2;
    output_write_addr <= mem_fw_2; 
    constant_addr <= mem_fw_2;
    
-- Pipeline: EX

	pipeline_mem_ex_reg : process(clk)
   begin
        if rising_edge(clk) then
		      if (mem_add_imm ='1') then
				    ex_reg_2_data <= sxt(mem_reg_2_addr, 16);
			   else
				    ex_reg_2_data <= mem_fw_2;
			   end if;
            ex_reg_1_data       <= mem_fw_1;
            ex_imm_value        <= mem_imm_value;
            ex_mem_value        <= mem_mem_value;
            ex_reg_1_addr       <= mem_reg_1_addr;
            ex_reg_2_addr       <= mem_reg_2_addr;
           
            ex_alu_op           <= mem_alu_op;         
            ex_reg_we           <= mem_reg_we;
            ex_reg_wb_src       <= mem_reg_wb_src;
            ex_load_const       <= mem_load_const;
        end if;
    end process;

    core_alu : alu
    port map (
        -- CLK
        dsp_clk                 => '-', 
        cpu_clk                 => clk,
        -- ALU input data:
        cpu_input_register_1    => ex_fw_1,
        cpu_input_register_2    => ex_fw_2,
        cpu_input_const         => ex_mem_value,
        cpu_input_const_w       => ex_load_const,
        -- ALU control:
        operation               => ex_alu_op,
        -- ALU result data:
        result                  => ex_alu_result,
        flags                   => ex_alu_flags
    );

    ex_forwarding_unit : forwarding_unit_ex
    port map (
        reg_we		        => wb_reg_we,
    
        wb_reg_1_addr       => wb_reg_1_addr,
        reg_1_addr          => ex_reg_1_addr,
        reg_2_addr	        => ex_reg_2_addr,
        
        data_1_in           => ex_reg_1_data,
        data_2_in           => ex_reg_2_data,
        
        data_1_out          => ex_fw_1,
        data_2_out          => ex_fw_2,
        
        data_wb_in          => wb_data(15 downto 0)
    );    

    

    wb_slct_mux : process(ex_reg_wb_src, ex_imm_value, ex_alu_result, ex_mem_value)
    begin
        case ex_reg_wb_src is 
            when MUX_ALU =>
                ex_wb_data <= ex_alu_result;
            when MUX_MEM =>
                ex_wb_data <= ex_mem_value;
            when MUX_IMM =>
                ex_wb_data <= ex_imm_value;
            when others =>
                ex_wb_data <= ex_imm_value;
        end case;
    end process;

--Pipeline: WB
    pipeline_ex_wb_reg : process(clk)
    begin
        if (rising_edge(clk)) then
            wb_data             <= ex_wb_data;
            wb_flags            <= ex_alu_flags;
            wb_reg_1_addr       <= ex_reg_1_addr;
            wb_reg_we           <= ex_reg_we;
        end if;
    end process;
end behaviour;
