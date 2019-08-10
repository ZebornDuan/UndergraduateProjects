library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exe_mem is
	port(
		clk : in std_logic;
		reset : in std_logic;
		--aluout_in : in std_logic_vector(15 downto 0);
		aluout_in : in std_logic_vector(15 downto 0);
		memwrite_in :in std_logic;
		memread_in : in std_logic;
		out_sw_in : in std_logic_vector(15 downto 0);
		
		regwrite_in : in std_logic;
		memtoreg_in : in std_logic_vector(1 downto 0);
		rd_in : in std_logic_vector(3 downto 0);
		
		memadress_out : out std_logic_vector(15 downto 0);
		memdata_out : out std_logic_vector(15 downto 0);
		memwrite_out : out std_logic;
		memread_out:out std_logic;
		memtoreg_out : out std_logic_vector(1 downto 0);
		regwrite_out :out std_logic;
		aluout_out : out std_logic_vector(15 downto 0);
		rd_out : out std_logic_vector(3 downto 0)
	);
end exe_mem;

architecture Behavioral of exe_mem is

	shared variable	t_memadress_out :  std_logic_vector(15 downto 0);
	shared variable	t_memdata_out :  std_logic_vector(15 downto 0);
	shared variable	t_memwrite_out : std_logic;
	shared variable	t_memread_out : std_logic;
	shared variable	t_memtoreg_out : std_logic_vector(1 downto 0);
	shared variable	t_regwrite_out : std_logic;
	shared variable	t_aluout_out :  std_logic_vector(15 downto 0);
	shared variable	t_rd_out : std_logic_vector(3 downto 0);
begin
process(reset,clk)
begin

	if (reset='1') then
			t_aluout_out := "0000000000000000";
			t_memadress_out :="0000000000000000";
			t_memdata_out:="0000000000000000";
			t_memread_out:='0';
			t_memwrite_out :='0';
			t_memtoreg_out :="00";
			t_regwrite_out :='0';
			t_rd_out :="0000";
		elsif (clk'event and clk='1') then
			t_memwrite_out:=memwrite_in;
			t_memread_out:=memread_in;
			t_memtoreg_out:=memtoreg_in;
			t_regwrite_out:=regwrite_in;
			t_aluout_out:=aluout_in;
			t_memadress_out:=aluout_in;
			t_memdata_out:=out_sw_in;
			t_rd_out :=rd_in;
		end if;
		memadress_out <= t_memadress_out;
		memdata_out <= t_memdata_out;
		memwrite_out <= t_memwrite_out;
		memread_out <= t_memread_out;
		memtoreg_out <= t_memtoreg_out;
		regwrite_out <= t_regwrite_out;
		aluout_out <= t_aluout_out;
		rd_out <= t_rd_out;
end process;
end Behavioral;

