library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.all;


entity MemoryController is
    Port(
		address1 : in  STD_LOGIC_VECTOR (15 downto 0); --1为指令内存地址和数据
		output1 : out  STD_LOGIC_VECTOR (15 downto 0);
		address2 : in  STD_LOGIC_VECTOR (15 downto 0);--2为数据内存地址和数据，用于访存阶段
		output2 : out  STD_LOGIC_VECTOR (15 downto 0);
		clk: in STD_LOGIC;--一个高频时钟
		cpuclock : out STD_LOGIC;--时钟四分频后输出
		
		--flash部分的信号，只是接到上层例化用于管脚绑定，在这一层实际上木有用
		flash_byte : out std_logic;
		flash_vpen : out std_logic;
		flash_ce : out std_logic;
		flash_oe : out std_logic;
		flash_we : out std_logic;
		flash_rp : out std_logic;
		flash_addr : out std_logic_vector(22 downto 1);
		flash_data : inout std_logic_vector(15 downto 0);
		
		--内存读写部分的信号
		dataWrite : in  STD_LOGIC_VECTOR (15 downto 0); --要写的数据
		memoryAddr : out STD_LOGIC_VECTOR (17 downto 0);
		MemWrite : in STD_LOGIC; --内存写信号
		MemRead : in STD_LOGIC; --内存读信号
		memoryEN : out STD_LOGIC;
		memoryOE : out STD_LOGIC;
		memoryRW : out STD_LOGIC;
		
		--扩展数据线
		extendDatabus : inout STD_LOGIC_VECTOR(15 downto 0);
		
		--串口和VGA部分的信号
		serial_wrn : out STD_LOGIC;
		serial_rdn : out STD_LOGIC;
		serial_dataready : in STD_LOGIC;
		serial_tsre : in STD_LOGIC;
		serial_tbre : in STD_LOGIC;
		basicdatabus : inout STD_LOGIC_VECTOR(7 downto 0);
		ram1_en : out STD_LOGIC;
		reset : in STD_LOGIC;
		
		VGA_addr : out std_logic_vector(10 downto 0);
		VGA_write : out std_LOGIC_vector(0 downto 0);
		VGA_char : out std_logic_vector(7 downto 0)
	);
end MemoryController;

architecture Behavioral of MemoryController is

	type state_type is (
		BOOTINIT, --自启动的初始化状态
		BOOT_READFLASH, --从Flash中读数据
		BOOT_WRITERAM, --将读取的数据写到Ram2中
		BOOT_READY, --自启动就绪
		READIR, --取指
		SERIAL, --处理串口读写的状态
		RWRAM, --内存的读或写
		PAUSE --缓冲状态
	);
	signal state : state_type := BOOTINIT;
	
-- Flash元件例化
	component Flash
		port(
			address: in std_logic_vector(22 downto 1);
			dataout: out std_logic_vector(15 downto 0);			
			clk: in std_logic;
			reset: in std_logic;
			flash_byte : out std_logic;
			flash_vpen : out std_logic;
			flash_ce : out std_logic;
			flash_oe : out std_logic;
			flash_we : out std_logic;
			flash_rp : out std_logic;
			flash_addr : out std_logic_vector(22 downto 1);
			flash_data : inout std_logic_vector(15 downto 0);
			
			flash_read : in  std_logic
		);
	end component;
	
	signal flash_addr_input : std_logic_vector(22 downto 1) := "0000000000000000000000";
	signal flash_data_output : std_logic_vector(15 downto 0);
	
	signal flash_read: std_logic; --控制Flash元件的读
	signal flash_state_num: std_logic_vector(2 downto 0) := "000";
	
	signal flash_pc_addr : std_logic_vector(15 downto 0) := x"FFFF"; --初值为-1,用于flash读取地址计算存储
	signal tflash_data : STD_LOGIC_VECTOR(15 downto 0); --临时存储flash中读出的数据

-------------------------------------
-- Memory控制的中间信号
	signal toutput1, toutput2:  STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
	signal WillWrite : STD_LOGIC; --要向总线写数据的信号
	signal BF01 : STD_LOGIC_VECTOR (15 downto 0);
	signal readin, DataBuf, addressTemp : STD_LOGIC_VECTOR (15 downto 0);

-------------------------------------
-- Serial port
	signal serial_flag : STD_LOGIC;
	signal serialHolder : STD_LOGIC_VECTOR (7 downto 0);
	
begin


-- 串口部分

	ram1_en <= '1';	--disable ram1

	with state select
		serial_flag <= 
			NOT MemWrite when RWRAM | SERIAL | PAUSE ,
			'1' when others;
	basicDatabus <= 
		serialHolder when serial_flag = '0' else "ZZZZZZZZ";
	
	-- serial port signal
	serial_wrn <= 
		NOT MemWrite when (address2 = x"BF00" and state = RWRAM) else '1';
	serial_rdn <= 
		NOT MemRead when (address2 = x"BF00" and ((state = SERIAL) or (state = RWRAM) or (state = PAUSE ))) else '1';
	
	serialHolder <= dataWrite (7 downto 0);
	
-------------------------------------
-- Flash部分

	flash_local: Flash port map(
		address => flash_addr_input,
		dataout => flash_data_output,
		clk=> clk,
		reset=> reset,
		flash_byte => flash_byte,
		flash_vpen => flash_vpen,
		flash_ce => flash_ce,
		flash_oe => flash_oe,
		flash_we => flash_we,
		flash_rp => flash_rp,
		flash_addr => flash_addr,
		flash_data => flash_data,
		flash_read => flash_read
	);
-------------------------------------

--分频
	with state select
		cpuclock <= 
			'1' when SERIAL | READIR,
			'0' when others;

-- 内存部分

	output1 <= toutput1;
	output2 <= toutput2;
	extendDatabus <= DataBuf when WillWrite = '0' else "ZZZZZZZZZZZZZZZZ";
	memoryAddr <= "00" & addressTemp;
	
	-- BF专门处理
	BF01(0) <= serial_tsre and serial_tbre;
	BF01(1) <= serial_dataready;
	BF01(15 downto 2) <= "00000000000000";
	
	memoryEN <= '0'; --使能一直打开
	
	memoryRW <= 
		'1' when (address2 = x"BF00" and state = RWRAM) 
		else NOT MemWrite when state = RWRAM
		else '0' when (state = BOOT_WRITERAM)
		else '1';
		
	with state select
		memoryOE <= 
			NOT MemRead when RWRAM,
			'1' when BOOT_READFLASH | BOOT_WRITERAM,
			'0' when others;
-----------------------------------------


-- VGA部分
	VGA_addr <= address2(10 downto 0);
	VGA_char <= dataWrite(7 downto 0);
	VGA_write <="1" when ((MemWrite='1') and (state=RWRAM) and (address2(15 downto 12)=x"F"))else "0"; 

--主要控制的process
	process(clk, reset)
	begin
		if reset='1' then
			state <= READIR;
			toutput1 <= extendDatabus;
			
		elsif clk'event and clk='1' then
			case state is
				-- Flash自启动过程
				when BOOTINIT => --Flash引导初始化
					flash_state_num <= "000";
					flash_read <= '1';
					state <= BOOT_READFLASH;
					DataBuf <= dataWrite;
					addressTemp <= "0000000000000000";
					WillWrite <= '1';
				
				when BOOT_READFLASH => --Flash读取数据
					flash_read <= '0';
					DataBuf <= tflash_data;
					addressTemp <= flash_pc_addr;
					WillWrite <= '1';
					case flash_state_num is
						when "000" =>
							flash_addr_input <= "0000000000000000000000" + flash_pc_addr + 1;
							flash_pc_addr <= flash_pc_addr + 1;
							flash_state_num <= flash_state_num + 1;
						when "110" =>
							tflash_data <= flash_data_output;
							flash_state_num <= "000";
							state <= BOOT_WRITERAM;
						when others =>
							flash_state_num <= flash_state_num + 1;
					end case;				
				when BOOT_WRITERAM => --Flash读取的数据写入Ram2
					flash_read <= '1';
					DataBuf <= tflash_data;
					addressTemp <= flash_pc_addr;
					WillWrite <= '0';
					if flash_pc_addr < x"0FFF" then --读取尚未结束，继续进入flash循环
						state <= BOOT_READFLASH; --读取系统程序区0~x0FFF的所有指令(虽然实际监控程序木有那么多指令)
					else
						state <= BOOT_READY; --否则进入引导就绪状态
					end if;
				
				when BOOT_READY => --引导就绪状态
					state <= READIR;
					flash_read <= '1';
					WillWrite <= '1';
					DataBuf <= dataWrite;
					addressTemp <= "0000000000000000";
				
				-- 自启动结束，等待cpu读写指令
				when READIR => --取指
					flash_read <= '1';
					DataBuf <= dataWrite;
					state <= SERIAL;
					addressTemp <= address1;
					WillWrite <= '1';
					toutput1 <= extendDatabus;
				when SERIAL => --串口读写
					flash_read <= '1';
					DataBuf <= dataWrite;
					addressTemp <= address1;
					WillWrite <= NOT MemWrite;
					state <= RWRAM;
				when RWRAM => --访存
					flash_read <= '1';
					DataBuf <= dataWrite;
					addressTemp <= address2;
					WillWrite <= NOT MemWrite;
					state <= PAUSE;
					case address2 is
						when x"BF01" =>
							toutput2 <= BF01;
						when x"BF00" =>
							toutput2 <= "00000000" & basicDatabus;
						when others =>
							toutput2 <= extendDatabus;		
					end case;
				when PAUSE => --缓冲
					flash_read <= '1';
					WillWrite <= '1';
					DataBuf <= dataWrite;
					addressTemp <= address2;
					state <= READIR;
				when others =>
					state <= READIR;
			end case;
		end if;
	end process;
end Behavioral;