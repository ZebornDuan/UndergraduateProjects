library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity hazard is
	port(
		memoryRead: in std_logic;
		exe_memory_read: in std_logic;
		goal: in std_logic_vector(3 downto 0);
		instruction: in std_logic_vector(15 downto 0);
		r_x: in std_logic_vector(2 downto 0);
		r_y: in std_logic_vector(2 downto 0);
		selection: in std_logic_vector(2 downto 0);
		
		pause: out std_logic := '0';
		bubble: out std_logic := '0'
	);
end entity;

architecture behavior of hazard is
begin
	process(memoryRead,selection, instruction,r_x,r_y,exe_memory_read,goal)
	begin
		if memoryRead = '1' and 
			((selection = "001" and r_y = instruction(10 downto 8)) or (selection = "000" and r_x = instruction(7 downto 5))) then
--			pause <= '1';
			bubble <= '1';
		else
--			pause <= '0';
			bubble <= '0';
		end if;
		if exe_memory_read = '1' and (goal = '0' & instruction(10 downto 8) or goal = '0' & instruction(7 downto 5)) then
                    pause <= '1';
--                    bubble <= '1';
                else
                    pause <= '0';
--                    bubble <= '0';
                end if;
	end process;
end behavior;

