----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_wb is
	port(
		clk : in std_logic;
		reset : in std_logic;
		memtoreg_in:in std_logic_vector(1 downto 0);
		regwrite_in:in std_logic;
		aluout_in :in std_logic_vector(15 downto 0);
		memout_in :in std_logic_vector(15 downto 0);
		rd_in : in std_logic_vector(3 downto 0);
		
		wbregwrite_out : out std_logic;
		wbadress_out : out std_logic_vector(3 downto 0);
		wbregdata_out : out std_logic_vector(15 downto 0)
	);
end mem_wb;

architecture Behavioral of mem_wb is
		shared variable t_wbregwrite_out : std_logic;
		shared variable t_wbadress_out :  std_logic_vector(3 downto 0);
		shared variable t_wbregdata_out :  std_logic_vector(15 downto 0);
begin
process (reset,clk)
begin
	if (reset='1') then
		t_wbregwrite_out:='0';
		t_wbadress_out:="0000";
		t_wbregdata_out:="0000000000000000";
	elsif (clk'event and clk='1') then
			
		t_wbregwrite_out:=regwrite_in;
		t_wbadress_out:=rd_in;
		if	(memtoreg_in="00") then
			t_wbregdata_out:=aluout_in;
		elsif memtoreg_in = "01" then
			t_wbregdata_out:=memout_in;
		elsif memtoreg_in = "10" then 
			if aluout_in = "0000000000000000" then
				t_wbregdata_out:="0000000000000000";
			else
				t_wbregdata_out:="0000000000000001";
			end if;
		elsif memtoreg_in = "11" then
			if aluout_in(15) = '0' then
				t_wbregdata_out:="0000000000000000";
			else
				t_wbregdata_out:="0000000000000001";
			end if;
		end if;
			
	end if;
	wbregwrite_out <= t_wbregwrite_out;
	wbadress_out <= t_wbadress_out;
	wbregdata_out <= t_wbregdata_out;
end process;


end Behavioral;