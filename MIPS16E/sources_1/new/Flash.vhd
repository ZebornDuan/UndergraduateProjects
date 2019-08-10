
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--负责flash读写的元件例化
entity Flash is
	port(
		address: in std_logic_vector(22 downto 1); --采用字模式
		dataout: out std_logic_vector(15 downto 0); --从flash读取的信号输出到上层
		flash_read : in  std_logic; --更上层例化控制flash读的信号
		clk: in std_logic; --接一个高频时钟
		reset: in std_logic;
		
		flash_byte : out std_logic := '1'; --操作模式，采用字模式
		flash_vpen : out std_logic := '1'; --写保护，置为1
		flash_ce : out std_logic := '0'; --使能信号,该模块只负责flash的读，故ce置为0即可 
		flash_oe : out std_logic := '1'; --读使能
		flash_we : out std_logic := '1'; --写使能
		flash_rp : out std_logic := '1'; --工作模式，1为工作
		flash_addr : out std_logic_vector(22 downto 1) := "0000000000000000000000"; --flash内存地址
		flash_data : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ"--flash给的数据
		);
end Flash;

architecture Behavioral of Flash is
	type flash_state is (
		BOOT_START1, --加载监控程序起始状态，尚未加载完成
		BOOT_START2,
		BOOT_START3,
		BOOT_ADDRREADY,--准备Flash读取地址
		BOOT_DATAREAD,--Flash读取
		BOOT_DATAREAD2--一个缓冲周期
	);
	SHARED VARIABLE state : flash_state := BOOT_START1;
begin

	--这些信号的值不变即可
	flash_byte <= '1';
	flash_vpen <= '1';
	flash_ce <= '0';
	flash_rp <= '1';

	process(clk, reset)
	begin
		if (reset = '1') then
			dataout <= "0000100000000000";
			flash_oe <= '1';
			flash_we <= '1';
			state := BOOT_START1;
			flash_data <= "ZZZZZZZZZZZZZZZZ";
		elsif (clk'event and clk = '1') then
			if (flash_read = '0') then
				case state is
				-- 读取flash
					when BOOT_START1 => --引导起始状态1,设置flash写使能
						flash_we <= '0';
						state := BOOT_START2;
					when BOOT_START2 =>--引导起始状态2,切换Flash为读模式，设置模式数据
						flash_data <= x"00FF";
						state := BOOT_START3;
					when BOOT_START3 =>--引导起始状态3，写入模式数据
						flash_we <= '1';
						state := BOOT_ADDRREADY;
					when BOOT_ADDRREADY =>--准备Flash读取数据地址
						flash_addr <= address; --从0地址开始读取
						flash_oe <= '0'; --开启读使能
						flash_data <= "ZZZZZZZZZZZZZZZZ"; --数据线设为高阻
						state := BOOT_DATAREAD;
					when BOOT_DATAREAD => --读取Flash数据并输出
						dataout <= flash_data;--变量赋值是立即生效滴！
						flash_oe <= '1';
						state := BOOT_DATAREAD2;
					when BOOT_DATAREAD2 =>
						state := BOOT_START1;
				end case;
			end if;
		end if;
	end process;

end Behavioral;

