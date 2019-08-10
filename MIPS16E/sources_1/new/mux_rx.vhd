library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_rx is
	port(
		rx: in std_logic_vector(15 downto 0);
		ry: in std_logic_vector(15 downto 0);
		sp: in std_logic_vector(15 downto 0);
		pc: in std_logic_vector(15 downto 0);
		ra: in std_logic_vector(15 downto 0);
		ih: in std_logic_vector(15 downto 0);
		t: in std_logic_vector(15 downto 0);
        forward_datax: in std_logic_vector(15 downto 0);
        from_forwardx: in std_logic;
		immediate: in std_logic_vector(15 downto 0);
		alu_mux_rx: in std_logic_vector(2 downto 0);
		alu_rx: out std_logic_vector(15 downto 0)
	);
end mux_rx;

architecture behavior of mux_rx is
begin
	process(alu_mux_rx, from_forwardx, rx, ry, sp, pc, ra, ih, t, forward_datax, immediate)
	begin
	    if from_forwardx = '0' then
			case alu_mux_rx is
				when "000" =>
					alu_rx <= rx;
				when "001" =>
				    alu_rx <= ry;
				when "010" =>
					alu_rx <= sp;
				when "011" =>
					alu_rx <= pc;
				when "100" =>
					alu_rx <= ra;
				when "101" =>
					alu_rx <= ih;
				when "110" =>
					alu_rx <= t;
				when "111" =>
					alu_rx <= immediate;
				when others =>
					alu_rx <= "0000000000000000";
			end case;
		else
			alu_rx <= forward_datax;
		end if;
	end process;
end behavior;