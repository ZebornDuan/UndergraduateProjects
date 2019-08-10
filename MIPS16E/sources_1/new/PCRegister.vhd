library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PCRegister is
	port(	
			rst,clk : in std_logic;
			PCHold : in std_logic;
			PCHold2: in std_logic;
			PCIn : in std_logic_vector(15 downto 0);
			PCOut : out std_logic_vector(15 downto 0):="0000000000000000"
		);
end PCRegister;

architecture Behavioral of PCRegister is
signal s_pc_in:std_logic_vector(15 downto 0);
begin
	process(clk,rst,PCIn,PCHold,PCHold2)
	begin
	   s_pc_in <= PCIn;
		if (rst = '1') then 
			PCOut <= "0000000000000000";
		elsif clk'event and clk = '1'then
		
		      if PCHold2 = '1' then
		          PCOut <= s_pc_in - "0000000000000001";
			elsif PCHold = '0' then
				PCOut <= s_pc_in;
	       else
	           PCOut <= s_pc_in - "0000000000000010";
			end if;
		end if;
	end process;
end Behavioral;

