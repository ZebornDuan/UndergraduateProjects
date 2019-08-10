
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--����flash��д��Ԫ������
entity Flash is
	port(
		address: in std_logic_vector(22 downto 1); --������ģʽ
		dataout: out std_logic_vector(15 downto 0); --��flash��ȡ���ź�������ϲ�
		flash_read : in  std_logic; --���ϲ���������flash�����ź�
		clk: in std_logic; --��һ����Ƶʱ��
		reset: in std_logic;
		
		flash_byte : out std_logic := '1'; --����ģʽ��������ģʽ
		flash_vpen : out std_logic := '1'; --д��������Ϊ1
		flash_ce : out std_logic := '0'; --ʹ���ź�,��ģ��ֻ����flash�Ķ�����ce��Ϊ0���� 
		flash_oe : out std_logic := '1'; --��ʹ��
		flash_we : out std_logic := '1'; --дʹ��
		flash_rp : out std_logic := '1'; --����ģʽ��1Ϊ����
		flash_addr : out std_logic_vector(22 downto 1) := "0000000000000000000000"; --flash�ڴ��ַ
		flash_data : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ"--flash��������
		);
end Flash;

architecture Behavioral of Flash is
	type flash_state is (
		BOOT_START1, --���ؼ�س�����ʼ״̬����δ�������
		BOOT_START2,
		BOOT_START3,
		BOOT_ADDRREADY,--׼��Flash��ȡ��ַ
		BOOT_DATAREAD,--Flash��ȡ
		BOOT_DATAREAD2--һ����������
	);
	SHARED VARIABLE state : flash_state := BOOT_START1;
begin

	--��Щ�źŵ�ֵ���伴��
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
				-- ��ȡflash
					when BOOT_START1 => --������ʼ״̬1,����flashдʹ��
						flash_we <= '0';
						state := BOOT_START2;
					when BOOT_START2 =>--������ʼ״̬2,�л�FlashΪ��ģʽ������ģʽ����
						flash_data <= x"00FF";
						state := BOOT_START3;
					when BOOT_START3 =>--������ʼ״̬3��д��ģʽ����
						flash_we <= '1';
						state := BOOT_ADDRREADY;
					when BOOT_ADDRREADY =>--׼��Flash��ȡ���ݵ�ַ
						flash_addr <= address; --��0��ַ��ʼ��ȡ
						flash_oe <= '0'; --������ʹ��
						flash_data <= "ZZZZZZZZZZZZZZZZ"; --��������Ϊ����
						state := BOOT_DATAREAD;
					when BOOT_DATAREAD => --��ȡFlash���ݲ����
						dataout <= flash_data;--������ֵ��������Ч�Σ�
						flash_oe <= '1';
						state := BOOT_DATAREAD2;
					when BOOT_DATAREAD2 =>
						state := BOOT_START1;
				end case;
			end if;
		end if;
	end process;

end Behavioral;

