library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
	port(
		alu_op: in std_logic_vector(2 downto 0);
		alu_rx: in std_logic_vector(15 downto 0);
		alu_ry: in std_logic_vector(15 downto 0);
		alu_out: out std_logic_vector(15 downto 0)
	);
end alu;

architecture behavior of alu is

begin
	process(alu_rx, alu_ry, alu_op)
	begin
		case alu_op is
			when "000" =>
				alu_out <= (alu_rx + alu_ry);
			when "001" =>
				alu_out <= (alu_rx - alu_ry);
			when "010" =>
				alu_out <= (alu_rx and alu_ry);
			when "011" =>
				alu_out <= (alu_rx or alu_ry);
			when "100" =>
				if (alu_ry = X"0000") then
					alu_out <= to_stdlogicvector((to_bitvector(alu_rx)) sll 8);
				else
					alu_out <= to_stdlogicvector((to_bitvector(alu_rx)) sll (conv_integer(alu_ry)));
				end if;
			when "101" =>
				if (alu_ry = X"0000") then
					alu_out <= to_stdlogicvector((to_bitvector(alu_rx)) sra 8);
				else
					alu_out <= to_stdlogicvector((to_bitvector(alu_rx)) sra (conv_integer(alu_ry)));
				end if;
			when "110" =>
				alu_out <= to_stdlogicvector((to_bitvector(alu_rx)) sll (conv_integer(alu_ry)));
			when "111" =>
				alu_out <= alu_rx;
			when others =>
				alu_out <= "0000000000000000";
 		end case;
	end process;
end behavior;