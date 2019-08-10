library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


--address to register map list
--0000 R0
--0001 R1
--0010 R2
--0011 R3
--0100 R4
--0101 R5
--0110 R6
--0111 R7
--1000 SP
--1001 RA
--1010 IH
--1011 T

entity heap is 
	port(
		reset, clock: in std_logic;
		writeRegister: in std_logic;
		readAddressA: in std_logic_vector(3 downto 0);
		readAddressB: in std_logic_vector(3 downto 0);
		readDataA: out std_logic_vector(15 downto 0);
		readDataB: out std_logic_vector(15 downto 0);

		writeAddress: in std_logic_vector(3 downto 0);
		writeData: in std_logic_vector(15 downto 0);

		SP: out std_logic_vector(15 downto 0);
		RA: out std_logic_vector(15 downto 0);
		IH: out std_logic_vector(15 downto 0);
		R0:out std_logic_vector(15 downto 0);
		R1:out std_logic_vector(15 downto 0);
		R2:out std_logic_vector(15 downto 0);
		R3:out std_logic_vector(15 downto 0);
		R4:out std_logic_vector(15 downto 0);
		R5:out std_logic_vector(15 downto 0);
		R6:out std_logic_vector(15 downto 0);
		R7:out std_logic_vector(15 downto 0);
		T: out std_logic_vector(15 downto 0) 
	);
end heap;

architecture behavior of heap is

signal s0: std_logic_vector(15 downto 0);
signal s1: std_logic_vector(15 downto 0);
signal s2: std_logic_vector(15 downto 0);
signal s3: std_logic_vector(15 downto 0);
signal s4: std_logic_vector(15 downto 0);
signal s5: std_logic_vector(15 downto 0);
signal s6: std_logic_vector(15 downto 0);
signal s7: std_logic_vector(15 downto 0);
signal ssp: std_logic_vector(15 downto 0);
signal ras: std_logic_vector(15 downto 0);
signal sih: std_logic_vector(15 downto 0);
signal st: std_logic_vector(15 downto 0);

begin

	process(readAddressA, readAddressB, s0, s1, s2, s3, s4, s5, s6, s7, ssp, ras ,sih, st)
	begin
		case readAddressA is
			when "0000" =>
				readDataA <= s0;
			when "0001" =>
				readDataA <= s1;
			when "0010" =>
				readDataA <= s2;
			when "0011" =>
				readDataA <= s3;
			when "0100" =>
				readDataA <= s4;
			when "0101" =>
				readDataA <= s5;
			when "0110" =>
				readDataA <= s6;
			when "0111" =>
				readDataA <= s7;
			when "1000" =>
				readDataA <= ssp;
			when "1001" =>
				readDataA <= ras;
			when "1010" =>
				readDataA <= sih;
			when "1011" =>
				readDataA <= st;
			when others =>
				readDataA <= "0000000000000000";
		end case;

		case readAddressB is
			when "0000" =>
				readDataB <= s0;
			when "0001" =>
				readDataB <= s1;
			when "0010" =>
				readDataB <= s2;
			when "0011" =>
				readDataB <= s3;
			when "0100" =>
				readDataB <= s4;
			when "0101" =>
				readDataB <= s5;
			when "0110" =>
				readDataB <= s6;
			when "0111" =>
				readDataB <= s7;
			when "1000" =>
				readDataB <= ssp;
			when "1001" =>
				readDataB <= ras;
			when "1010" =>
				readDataB <= sih;
			when "1011" =>
				readDataB <= st;
			when others =>
				readDataB <= "0000000000000000";
		end case;
	end process;

	process(reset, clock, writeRegister, writeData, writeAddress)
	begin
		if reset = '1' then
			s0 <= "0000000000000000";
			s1 <= "0000000000000000";
			s2 <= "0000000000000000";
			s3 <= "0000000000000000";
			s4 <= "0000000000000000";
			s5 <= "0000000000000000";
			s6 <= "0000000000000000";
			s7 <= "0000000000000000";
			ssp <= "0111111111111111";
			ras <= "0000000000000000";
			sih <= "0000000000000000";
			st <= "0000000000000000";
		elsif clock'event and clock = '0' then
			if writeRegister = '1' then
				case writeAddress is
					when "0000" =>
						s0 <= writeData;
					when "0001" =>
						s1 <= writeData;
					when "0010" =>
						s2 <= writeData;
					when "0011" =>
						s3 <= writeData;
					when "0100" =>
						s4 <= writeData;
					when "0101" =>
						s5 <= writeData;
					when "0110" =>
						s6 <= writeData;
					when "0111" =>
						s7 <= writeData;
					when "1000" =>
						ssp <= writeData;
					when "1001" =>
						ras <= writeData;
					when "1010" =>
						sih <= writeData;
					when "1011" =>
						st <= writeData;
					when others => null;
				end case;
			end if;
		end if;
	end process;

	sp <= ssp;
	ra <= ras;
	ih <= sih;
	t <= st;
	R0 <= s0;
	R1 <= s1;
	R2 <= s2;
	R3 <= s3;
	R4 <= s4;
	R5 <= s5;
	R6 <= s6;
	R7 <= s7;

end behavior;

