library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_goal is
	port(
		alu_select_goal: in std_logic_vector(2 downto 0);
		rx: in std_logic_vector(2 downto 0);
		ry: in std_logic_vector(2 downto 0);
		rz: in std_logic_vector(2 downto 0);
		goal: out std_logic_vector(3 downto 0)
	);
end mux_goal;

architecture behavior of mux_goal is
begin
	process(alu_select_goal, rx, ry, rz)
	begin
		case alu_select_goal is
			when "000" =>   --rx
				goal <= "0" & rx;
			when "001" =>   --ry
				goal <= "0" & ry;
			when "010" =>   --rz
				goal <= "0" & rz;
			when "011" =>   --sp
				goal <= "1000";
			when "100" =>   --ra
				goal <= "1001";
			when "101" =>   --IH
				goal <= "1010";
			when "110" =>   --T
				goal <= "1011";
			when others =>
				goal <= "0000";
		end case;
	end process;
end behavior;
	