-- Toplevel processor core module

library ieee;
use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

library work;
use work.core_constants.all;
use work.internal_bus.all;

entity core is
    generic(
        instruct_addr_size  : natural := 16,
        instruct_data_size  : natural := 16,
        reg_addr_size       : natural := 5,
        reg_data_size       : natural := 16,
        memory_data_size    : natural := 32,
        memory_addr_size    : natural := 16

    );

    port(
        clk                 : in std_logic; -- Small cycle clock signal
        memclk              : in std_logic; -- Memory clock signal
        sample_clk          : in std_logic; -- Reset signal, "large cycle" clock signal

        reset               : in std_logic; -- Resets the processor core
        
        -- Connection to instruction memory:
        instruction_address : out std_logic_vector(instruct_addr_size - 1 downto 0);
        instruction_data    : in std_logic_vector(instruct_data_size downto 0);
        
        -- Connections to the constant memory controller:
        constant_addr       : out std_logic_vector(memory_addr_size - 1 downto 0);
        constant_data       : in  std_logic_vector(memory_data_size - 1 downto 0);

        -- Connections to the input buffer:
        input_read_addr     : out std_logic_vector(memory_addr_size - 1 downto 0);
        input_read_data     : in  std_logic_vector(memory_data_size downto 0);

        -- Connections to the output buffer:
        output_write_addr   : out std_logic_vector(memory_addr_size - 1 downto 0);
        output_write_data   : out std_logic_vector(memory_data_size downto 0);
        output_we           : out std_logic;
        
        output_read_address : out std_logic_vector(memory_addr_size - 1 downto 0);
        output_read_data    : in  std_logic_vector(memory_data_size downto 0)
    );
end entity;

architecture behaviour of core is

--********* Stage 1 - PC *********
    component adder is
        port (
            a, b    : in    std_logic_vector(reg_data_size-1 downto 0);
            result  : out   std_logic_vector(reg_data_size-1 downto 0);
            flags   : out   alu_flags
        );
    end component;
    --Pipeline registers for stage 1
    signal pc_reg           : std_logic_vector(reg_data_size-1 downto 0);
    signal pc_inc           : std_logic_vector(reg_data_size-1 downto 0);
    signal pc_we            : std_logic;
    
    signal branch_enable    : std_logic;
    signal branch_val       : std_logic_vector(9 downto 0);
    
--********* Stage 2 - Control unit and register file *********
    component control_unit is
        port (  
            clk                 : in    std_logic;
            reset               : in    std_logic;
            
            opt_code            : in    std_logic_vector (5 downto 0);
            alu_op              : out   alu_operation;
            imm_select          : out   std_logic;
            reg_write_e         : out   std_logic;
            reg_b_wr            : out   std_logic;
            reg_write_source    : out   std_logic_vector (1 downto 0);
            output_write_enable : out   std_logic;
            read_from_const_mem : out   std_logic;
            branch_enable       : out   std_logic;
            pc_write_enable     : out   std_logic
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
        
        -- addr signals
        signal id_reg_addr_1        : std_logic_vector( reg_addr_size-1 downto 0);
        signal id_reg_addr_2        : std_logic_vector( reg_addr_size-1 downto 0);
        signal id_spec_addr         : std_logic_vector( reg_addr_size-1 downto 0);
        
        -- control signals
        signal id_bubble            : std_logic;
        signal id_alu_op            : alu_operation;
        signal id_reg_we            : register_write_enable;
        signal id_reg_wb_src        : wb_source;
        signal id_mem_slct          : mem_source;
        signal id_load_imm          : std_logic;
        signal id_output_we         : std_logic;
        signal id_add_imm           : std_logic;
        signal id_load_const        : std_logic;

        
--********* Stage 3 - Memory access / MEM *********
    component forwarding_unit is
        Port (
            wb_reg              : in STD_LOGIC_VECTOR(reg_addr_size-1 downto 0); 
            reg_addr_1          : in STD_LOGIC_VECTOR(reg_addr_size-1 downto 0); 
            reg_addr_2          : in STD_LOGIC_VECTOR(reg_addr_size-1 downto 0); 
            reg_write           : in STD_LOGIC;
            forward_1           : out STD_LOGIC;
            forward_2           : out STD_LOGIC
        );
    end component forwarding_unit;
        
    -- signals
        -- data signals
        signal mem_reg_data_1_in    : std_logic_vector(reg_data_size-1 downto 0);
        signal mem_reg_data_1_out   : std_logic_vector(reg_data_size-1 downto 0);
        signal mem_reg_data_1b      : std_logic_vector(reg_data_size-1 downto 0);
        signal mem_reg_data_2_in    : std_logic_vector(reg_data_size-1 downto 0);
        signal mem_reg_data_2_out   : std_logic_vector(reg_data_size-1 downto 0);
        signal mem_imm_value        : std_logic_vector(memory_data_size-1 downto 0);
        signal mem_mem_value        : std_logic_vector(memory_data_size-1 downto 0);
        -- addr signals
        signal mem_reg_addr_1        : std_logic_vector( reg_addr_size-1 downto 0);
        signal mem_reg_addr_2        : std_logic_vector( reg_addr_size-1 downto 0);
        
        -- control signals
        signal mem_alu_op           : alu_operation;
        signal mem_reg_we           : register_write_enable;
        signal mem_reg_wb_src       : wb_source;
        signal mem_mem_slct         : mem_source;
        signal mem_load_imm         : std_logic;
        signal mem_output_we        : std_logic;
        signal mem_add_imm          : std_logic;
        signal mem_load_const       : std_logic;
        
        -- forward unit
        signal mem_forward_1        : std_logic;
        signal mem_forward_2        : std_logic; 
        
-- ********* Stage 4 - ALU *********
    component alu is
        port (
            -- CLK
            dsp_clk, cpu_clk        : in    std_logic;
            -- ALU input data:
            cpu_input_register_1    : in    std_logic_vector(reg_data_size-1 downto 0);
            cpu_input_register_2    : in    std_logic_vector(reg_data_size-1 downto 0);
            cpu_input_const         : in    std_logic_vector(reg_data_size-1 downto 0);
            cpu_input_const_w       : in    std_logic;
            -- ALU control:
            operation               : in    alu_operation;
            -- ALU result data:
            result                  : out   std_logic_vector(31 downto 0);
            flags                   : out   alu_flags
        );
    end component;
    
    
    -- signals
        -- data signals
        signal ex_reg_data_1_in     : std_logic_vector(reg_data_size-1 downto 0);
        signal ex_reg_data_2_in     : std_logic_vector(reg_data_size-1 downto 0);
        signal ex_reg_data_1_out    : std_logic_vector(reg_data_size-1 downto 0);
        signal ex_reg_data_2_out    : std_logic_vector(reg_data_size-1 downto 0);
        signal ex_imm_value         : std_logic_vector(memory_data_size-1 downto 0);
        signal ex_mem_value         : std_logic_vector(memory_data_size-1 downto 0);
        signal ex_alu_result        : std_logic_vector(memory_data_size-1 downto 0);
        signal ex_wb_data           : std_logic_vector(memory_data_size-1 downto 0);
        signal ex_alu_flags         : alu_flags;
        -- addr signals
        signal ex_reg_addr_1        : std_logic_vector( reg_addr_size-1 downto 0);
        signal ex_reg_addr_2        : std_logic_vector( reg_addr_size-1 downto 0);
       
        -- control signals
        signal ex_alu_op            : alu_operation;
        signal ex_reg_we            : register_write_enable;
        signal ex_reg_wb_src        : wb_source;
        signal ex_load_const        : std_logic;
        
        -- forward unit
        signal ex_forward_1         : std_logic;
        signal ex_forward_2         : std_logic;

    -- ****** STAGE 5, write back *******

        -- data signals
        signal wb_data              : std_logic_vector(memory_data_size-1 downto 0);
        signal wb_flags             : alu_flags; 
        
        -- addr signals
        signal wb_reg_write_addr    : std_logic_vector(reg_addr_size-1 downto 0);    
        
        -- control signals
        signal wb_reg_we            : register_write_enable;    
--Other

begin
    
--Pipeline: IF
    pc_incrementer : adder
    port map(
        a       => pc_reg,
        b       => '1',
        result  => pc_inc
    );
    
    pc : process(clk)
    begin
        if rising_edge(clk) then
            if branch_enable = '1' then
                pc_reg <= branch_target;
            else
                pr_reg <= pc_inc;
            end if;
        end if;
    end process;
    
    instruction_address <= pc_reg;

--Pipeline: ID
    branch_target <= instruction_data(9 downto 0);
    
    control_u : control_unit
    port map(
        clk                 => clk,
        reset               => reset,
        opt_code            => instruction(15 downto 10),
        
        bubble              => id_bubble,
        alu_op              => id_alu_op,
        reg_write_e         => id_reg_we,
        reg_write_source    => id_reg_wb_src,
        mem_source          => id_mem_slct,
        load_imm            => id_load_imm,
        output_write_enable => id_output_we,
        add_imm     |       => id_add_imm;
        load_const          => id_load_const;
        branch_enable       => branch_enable
    );
    
    regfile : register_file
    port map(
        clk             => clk,

        reg_1_address   => instruction_data(9 downto 5),
        reg_2_address   => instruction_data(reg_addr_size-1 downto 0),
        write_address   => wb_reg_write_addr,

        data_in         => wb_data,

        write_reg_enb   => wb_reg_we,

        reg_1_data      => mem_reg_data_1_in,
        reg_1b_data     => mem_reg_data_1b,
        reg_2_data      => mem_reg_data_2_in,

    );

    --TODO: Pipeline registerz for signals
    -- signal mappings
        id_imm_value <= sxt(instruction_data(13 downto 0), 32);




--Pipeline: MEM
    

    mem_forward_unit : forwarding_unit
    port map (
        wb_reg              => wb_reg_write_addr; 
        reg_addr_1          => mem_reg_addr_1,
        reg_addr_2          =< mem_reg_addr_2, 
        reg_write           => wb_reg_we,
        forward_1           => mem_forward_1,
        forward_2           => mem_forward_2
    );

    pipeline_id_mem_reg : process(clk)
    begin
        if rising_edge(clk) then
            
            mem_imm_value   <= id_imm_value;    
            mem_reg_addr_1  <= id_reg_addr_1;      
            mem_reg_addr_2  <= id_reg_addr_2;
        
            mem_alu_op      <= id_alu_op;
            mem_reg_we      <= id_reg_we;
            mem_reg_wb_src  <= id_reg_wb_src;
            mem_mem_slct    <= id_mem_slct;
            mem_load_imm    <= id_load_imm;
            mem_output_we   <= id_output_we;
            mem_add_imm     <= id_add_imm;
            mem_load_const  <= id_load_const;
        
         
        end if;
    end process;


    mem_mux_reg1 : process(mem_reg_data_1_in, wb_data, mem_forward_1)
    begin
        if (mem_forward_1 = '1') then
            mem_reg_data_1_out <= wb_data;
        else
            mem_reg_data_1_out <= mem_reg_data_1_in;
        end if;

    end process;

    mem_mux_reg2 : process(mem_add_imm, mem_forward_2, wb_data, mem_reg_addr_2, mem_reg_data_2_in)
    begin
        if (mem_add_imm = '1') then
            mem_reg_data_2_out <= mem_reg_addr_2;
        else if (mem_forward_2 = '1') then
            mem_reg_data_2_out <= wb_data;
        else
            mem_reg_data_2_out <= mem_reg_data_2_in;
        end if;
    end process;

    mem_memory_mux : process(mem_mem_slct, input_read_data, constant_data, output_read_data)
    begin
        case mem_mem_slct is
            when MEM_INPUT =>
                mem_mem_value <= input_read_data;
            when MEM_OUTPUT =>
                mem_mem_value <= output_read_data;
            when MEM_CONST =>
                mem_mem_value <= constant_data;
        end case;
    end process;

    -- signal mapping
    input_read_addr <= mem_reg_data_2_out;
    output_read_address <= mem_reg_data_2_out;
    output_write_addr <= mem_reg_data_2_out; 
    constant_addr <= mem_reg_data_2_out;
    
-- Pipeline: EX
    

    core_alu : alu
    port map (
            -- CLK
            dsp_clk                 => '-', 
            cpu_clk                 => clk; 
            -- ALU input data:
            cpu_input_register_1    => ex_reg_data_1_out;
            cpu_input_register_2    => ex_reg_data_2_out;
            cpu_input_const         => ex_mem_value;
            cpu_input_const_w       => ex_load_const;
            -- ALU control:
            operation               => ex_alu_op;
            -- ALU result data:
            result                  => ex_alu_result;
            flags                   => ex_alu_flags;
    );

    ex_forwarding_unit : forwarding_unit
        port map (
            wb_reg              => wb_reg_write_addr; 
            reg_addr_1          => ex_reg_addr_1,
            reg_addr_2          =< ex_reg_addr_2, 
            reg_write           => wb_reg_we,
            forward_1           => ex_forward_1,
            forward_2           => ex_forward_2
        );    

    pipeline_mem_ex_reg : process(clk)
    begin
        if rising_edge(clk) then
            ex_reg_data_1_in    <= mem_reg_data_1_out;  
            ex_reg_data_2_in    <= mem_reg_data_2_out;
            ex_imm_value        <= mem_imm_value;
            ex_mem_value        <= mem_mem_value;
            ex_reg_addr_1       <= mem_reg_addr_1;
            ex_reg_addr_2       <= mem_reg_addr_2;
           
            ex_alu_op           <= mem_alu_op;         
            ex_reg_we           <= mem_reg_we;
            ex_reg_wb_src       <= mem_reg_wb_src;
            ex_load_const       <= mem_load_const;
        end if;

    end process;

    ex_mux_reg1 : process(ex_reg_data_1_in, wb_data, ex_forward_1)
    begin
        if (ex_forward_1 = '1') then
            ex_reg_data_1_out <= wb_data;
        else
            ex_reg_data_1_out <= mem_reg_data_1_in;
        end if;

    end process;

    ex_mux_reg2 : process(ex_reg_data_2_in, wb_data, ex_forward_2)
    begin
        if (ex_forward_2 = '1') then
            ex_reg_data_2_out <= wb_data;
        else
            ex_reg_data_2_out <= mem_reg_data_2_in;
        end if;
    end process;

    wb_slct_mux : process(ex_reg_wb_src, ex_imm_value, ex_alu_result, ex_mem_value)
    begin
        case ex_reg_wb_src is 
            when MUX_ALU =>
                ex_wb_data <= ex_alu_result;
            when MUX_MEM =>
                ex_wb_data <= ex_mem_value;
            when MUX_IMM =>
                ex_wb_data <= ex_imm_value;
        end case;
    end process;


    --TODO:
        --mux reg_1
        --mux reg_2
        --alu
        --alu_result_mux
        --forwarding unit
        --stage reg_addr_size-1 pipeline regsz

--Pipeline: WB
    pipeline_ex_wb_reg : process(clk)
    begin
        if (rising_edge(clk)) then
            wb_data             <= ex_wb_data;
            wb_flags            <= ex_alu_flags;
            wb_reg_write_addr   <= ex_reg_addr_1;
            wb_reg_we           <= ex_reg_we;
        end if;
        
    end process;

end behaviour;
