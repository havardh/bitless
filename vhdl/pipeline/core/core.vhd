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

--Stage 1 - PC
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
    signal branch_val       : std_logic_vector(reg_data_size-1 downto 0);
    
--Stage 2 - Control unit and register file
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
            reg_2_data      : out std_logic_vector(reg_data_size-1 downto 0)
        );
    end component register_file;
    --Pipeline registers for stage ID
    
        -- data signals
        signal id_imm_value     : std_logic_vector(reg_data_size-1 downto 0);
        
        -- addr signals
        signal id_reg_addr_1        : std_logic_vector( reg_addr_size-1 downto 0);
        signal id_reg_addr_2        : std_logic_vector( reg_addr_size-1 downto 0);
        signal id_reg_write_addr    : std_logic_vector( reg_addr_size-1 downto 0);
        

        -- control signals
        signal id_alu_op            : alu_operation;
        signal id_imm_slct          : std_logic;
        signal id_reg_we            : std_logic;
        signal id_reg_wb_src        : std_logic;
        signal id_mem_slct          : std_logic_vector(1 downto 0);

        
--Stage 3 - Memory access / MEM
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
        signal mem_reg_data_1   : std_logic_vector(reg_data_size-1 downto 0);
        signal mem_reg_data_2   : std_logic_vector(reg_data_size-1 downto 0);
        signal mem_imm_value    : std_logic_vector(reg_data_size-1 downto 0);
        signal mem_mem_value    : std_logic_vector(memory_data_size-1 downto 0);

        -- addr signals
        signal mem_reg_addr_1        : std_logic_vector( reg_addr_size-1 downto 0);
        signal mem_reg_addr_2        : std_logic_vector( reg_addr_size-1 downto 0);
        signal mem_reg_write_addr    : std_logic_vector( reg_addr_size-1 downto 0);
        
        -- control signals
        signal mem_alu_op            : alu_operation;
        signal mem_imm_slct          : std_logic;
        signal mem_reg_we            : std_logic;
        signal mem_reg_wb_src        : std_logic;
        signal mem_mem_slct          : std_logic_vector(1 downto 0);
        
        -- forward unit
        signal mem_forward_1        : std_logic;
        signal mem_forward_2        : std_logic; 
        
--Stage 4 - ALU
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
    
    component forwarding_unit is
        Port (
            wb_reg      : in STD_LOGIC_VECTOR(reg_addr_size-1 downto 0); -- Hazard type 1
            reg_addr_1  : in STD_LOGIC_VECTOR(reg_addr_size-1 downto 0); -- Hazard type a
            reg_addr_2  : in STD_LOGIC_VECTOR(reg_addr_size-1 downto 0); -- Hazard type b
            reg_write   : in STD_LOGIC;
            forward_1   : out STD_LOGIC;
            forward_2   : out STD_LOGIC
        );
    end component forwarding_unit;
    
    -- signals
        -- data signals
        signal ex_reg_data_1        : std_logic_vector(reg_data_size-1 downto 0);
        signal ex_reg_data_2        : std_logic_vector(reg_data_size-1 downto 0);
        signal ex_imm_value         : std_logic_vector(reg_data_size-1 downto 0);
        signal ex_mem_value         : std_logic_vector(memory_data_size-1 downto 0);

        -- addr signals
        signal ex_reg_addr_1        : std_logic_vector( reg_addr_size-1 downto 0);
        signal ex_reg_addr_2        : std_logic_vector( reg_addr_size-1 downto 0);
        signal ex_reg_write_addr    : std_logic_vector( reg_addr_size-1 downto 0);
        
        -- control signals
        signal ex_alu_op            : alu_operation;
        signal ex_reg_we            : std_logic;
        signal ex_reg_wb_src        : std_logic;
        
        -- forward unit
        signal ex_forward_1         : std_logic;
        signal ex_forward_2         : std_logic;

    -- stage 5, write back.

        -- data signals
        signal wb_data              : std_logic_vector(memory_data_size-1 downto 0);
        signal wb_flags             : alu_flags; 
        
        -- addr signals
        signal wb_reg_write_addr    : std_logic_vector(reg_addr_size-1 downto 0);    
        
        -- control signals
        signal wb_reg_we            : std_logic;    
--Other

begin
    
--Pipeline stage 1
    pc_incrementer : adder
    port map(
        a       => pc_reg,
        b       => '1',
        result  => pc_inc
    );
    
    pc : process(clk)
    begin
        if rising_edge(pc_we) then
            if branch_enable = '1' then
                pc_reg <= branch_target;
            else
                pr_reg <= pc_inc;
            end if;
        end if;
    end process;
    
    instruction_address <= pc_reg;
--Pipeline stage 2
    branch_target <= instruction_data(9 downto 0);
    
    control : control_unit
    port map(
        clk                 => clk,
        reset               => reset,
        
        opt_code            => instruction(15 downto 10),
        spec_reg_addr       => id_spec_addr,
        imm_select          => id_imm_slct,
        reg_write_e         => id_reg_we,
        reg_b_wr            => id_reg_wb,
        reg_write_source    => id_reg_src,
        output_write_enable => id_output_we,
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

        reg_1_data      => id_reg_data_1,
        reg_2_data      => id_reg_data_2
    );
    --TODO: Pipeline registerz for signals
    
--Pipeline stage 3
    --TODO:
        --mux reg_1
        --mux reg_2
        --talk to mem
        --mux mem_result
        --forwarding unit
        --stage 3 pipeline regz
        
--Pipeline 4
    --TODO:
        --mux reg_1
        --mux reg_2
        --alu
        --alu_result_mux
        --forwarding unit
        --stage reg_addr_size-1 pipeline regsz

--TOTO:
    --connect the rest (stage 5)

end behaviour;
