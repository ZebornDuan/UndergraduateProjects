library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder is
	port(
		pc: in std_logic_vector(15 downto 0);
		offset: in std_logic_vector(15 downto 0);
		address: out std_logic_vector(15 downto 0)
	);
end adder;

architecture behavior of adder is
begin
	address <= (pc + offset);
end behavior;