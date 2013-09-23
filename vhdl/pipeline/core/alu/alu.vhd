-- ALU Toplevel Module

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.core_constants.all;

entity alu is
	port (
		-- ALU input data:
		a, b, c : in std_logic_vector(15 downto 0);

		-- ALU result data:
		result : out std_logic_vector(15 downto 0);
		flags  : out alu_flags;

		-- ALU control:
		operation : in alu_operation
	);
end alu;

architecture behaviour of alu is

	component adder is
		port (
			a, b : in std_logic_vector(15 downto 0);
			result : out std_logic_vector(15 downto 0);
			flags  : out alu_flags
		);
	end component;

	signal adder_result : std_logic_vector(15 downto 0);
	signal adder_flags : alu_flags;
begin
	add: adder
		port map (
			a => a,
			b => b,
			result => adder_result,
			flags => adder_flags
		);

	alu_process: process(operation)
	begin
		flags.negative <= '0';
		flags.overflow <= '0';
		flags.carry <= '0';
		flags.zero <= '0';

		case operation is
			when ALU_ADD =>
				result <= adder_result;
				flags <= adder_flags;
			when ALU_AND =>
				result <= a and b;
				if (a and b) = x"0000" then
					flags.zero <= '1';
				end if;
			when ALU_NAND =>
				result <= a nand b;
				if (a nand b) = x"0000" then
					flags.zero <= '1';
				end if;
			when ALU_OR =>
				result <= a or b;
				if (a or b) = x"0000" then
					flags.zero <= '1';
				end if;
			when ALU_NOR =>
				result <= a nor b;
				if (a nor b) = x"0000" then
					flags.zero <= '1';
				end if;
			when ALU_XOR =>
				result <= a xor b;
				if (a xor b) = x"0000" then
					flags.zero <= '1';
				end if;
			when ALU_MOVE =>
				result <= a;
				if a = x"0000" then
					flags.zero <= '1';
				end if;
			when ALU_MOVE_NEGATIVE =>
				result <= not a;
				if (not a) = x"0000" then
					flags.zero <= '1';
				end if;
		end case;
	end process alu_process;
end behaviour;

