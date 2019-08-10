library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PCMux is
	port( 
			branch : in std_logic;
			PCNext : in std_logic_vector(15 downto 0);
			PCJump : in std_logic_vector(15 downto 0);			
			PCOut : out std_logic_vector(15 downto 0)
		);
end PCMux;

architecture Behavioral of PCMux is
begin
	process(branch, PCNext, PCJump)
	begin 
		if (branch = '0') then
			PCOut <= PCNext;
		else
			PCOut <= PCJump;    -- some problems in PCJump
		end if;
	end process;

end Behavioral;

