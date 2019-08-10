library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_address is
	port(
		pc_offset: in std_logic_vector(15 downto 0);
		rx: in std_logic_vector(15 downto 0);
		ra: in std_logic_vector(15 downto 0);
		from_forward_address: in std_logic;
		forward_address: in std_logic_vector(15 downto 0);
		address_mux: in std_logic_vector(1 downto 0);
		address: out std_logic_vector(15 downto 0)
	);
end mux_address;

architecture behavior of mux_address is
begin
	process(address_mux, from_forward_address, rx, ra, pc_offset, forward_address)
		begin
		if from_forward_address = '0' then
			case address_mux is
				when "00" =>
					address <= pc_offset;
				when "01" =>
					address <= rx;
				when "10" =>
					address <= ra;
				when others =>
					address <= "0000000000000000";
			end case;
		else
			address <= forward_address;
		end if;
	end process;
end behavior;