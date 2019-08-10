library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_ry is
	port(
		immediate: in std_logic_vector(15 downto 0);
		ry: in std_logic_vector(15 downto 0);
		rx: in std_logic_vector(15 downto 0);
		forward_datay: in std_logic_vector(15 downto 0);
		from_forwardy: in std_logic;
		alu_mux_ry: in std_logic_vector(1 downto 0);
		alu_ry: out std_logic_vector(15 downto 0)
	);
end mux_ry;

architecture behavior of mux_ry is
begin
	process(alu_mux_ry, from_forwardy, rx, ry, forward_datay, immediate)
	begin
		if from_forwardy = '0' then
			case alu_mux_ry is
				when "00" =>
					alu_ry <= immediate;
				when "01" =>
					alu_ry <= ry;
				when "10" =>
					alu_ry <= rx;
				when "11" =>
					alu_ry <= "0000000000000001";
				when others =>
					alu_ry <= "0000000000000000";
			end case;
		else
			alu_ry <= forward_datay;
		end if;
	end process;
end behavior;