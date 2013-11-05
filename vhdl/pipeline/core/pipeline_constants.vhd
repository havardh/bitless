library IEEE;
use IEEE.STD_LOGIC_1164.all;

package pipeline_constants is

    type id_mem is 
    record
        wb_src
		mem_src
		input_read
		constant_read
		out_read
		immidiate_value
		reg1_addr
		reg2_addr
    end record;

	type mem_ex is
    record
        --TODO
    end record;
	
    type ex_wb is
    record
        --TODO      
    end record;

   


end pipeline_constants;