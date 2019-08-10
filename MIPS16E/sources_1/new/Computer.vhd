----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2017/11/27 22:24:22
-- Design Name: 
-- Module Name: Computer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Computer is
    port (
        
        op:in std_logic;
        clk_hand : in std_logic;
        clk_in,rst: in std_logic;
        leds: out std_logic_vector(31 downto 0) := x"00000000";
        
        -- vga port
--        R: out std_logic_vector(2 downto 0) := "000";
--        G: out std_logic_vector(2 downto 0) := "000";
--        B: out std_logic_vector(1 downto 0) := "00";
        video_color: out std_logic_vector(7 downto 0);
--        leds:  out std_logic_vector(7 downto 0);
        Hs: out std_logic := '0';
        Vs: out std_logic := '0';
        video_clk: out std_logic;
        video_de: out std_logic := '0';
        
            
		base_ram_data : inout std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
        base_ram_addr : out std_logic_vector(19 downto 0) := "00000000000000000000";    
        oe1,we1:out STD_LOGIC := '1';
        en1:out STD_LOGIC := '1';
		ext_ram_data : inout std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
        ext_ram_addr : out std_logic_vector(19 downto 0) := "00000000000000000000"; 
        oe2,we2:out STD_LOGIC := '1';
        en2:out STD_LOGIC := '1';   
        --chuan kou 
        rdn:out STD_LOGIC := '1';
        wrn:out STD_LOGIC := '1'; 
        tsre : in STD_LOGIC;
        tbre : in STD_LOGIC;
        dataready : in std_logic;
        --FLASH
        flash_byte : out STD_LOGIC := '1'; --操作模式,采用字模式
        flash_vpen : out STD_LOGIC := '1'; --写保护，置为1
        flash_ce : out STD_LOGIC := '0' ; --使能信号,该模块只负责flash的读，故ce置为0即可
        flash_oe : out STD_LOGIC := '1'; --读使能
        flash_we : out STD_LOGIC := '1'; --写使能
        flash_rp : out STD_LOGIC := '1'; --工作模式，1为工作
        flash_addr : out STD_LOGIC_VECTOR( 22 downto 0 ) := "00000000000000000000000"; --flash内存地址
        flash_data : inout STD_LOGIC_VECTOR( 15 downto 0 )--flash输出信号
 

  ) ;
end entity ; -- Computer

architecture Computer_beh of Computer is
    

    ---- IF begin
    --component InstructionFetch is
 --       port (
 --           rst : in STD_LOGIC;
 --           clk : in STD_LOGIC;
 --           PC_in : in  STD_LOGIC_VECTOR (15 downto 0);
 --           Instruction_in : in  STD_LOGIC_VECTOR (15 downto 0);

 --           Instruction_out : out  STD_LOGIC_VECTOR (15 downto 0);
 --           PC_out : out STD_LOGIC_VECTOR (15 downto 0);
 --           PC_out_Add1:out std_logic_vector(15 downto 0)
 --       );
 --   end component InstructionFetch;

    component   PCAdder is    
        port( 
                adderIn : in std_logic_vector(15 downto 0);
                adderOut : out std_logic_vector(15 downto 0)
            );
    end component PCAdder;

    component PCMux is
    port( 
            branch : in std_logic;
            PCNext : in std_logic_vector(15 downto 0);
            PCJump : in std_logic_vector(15 downto 0);          
            PCOut : out std_logic_vector(15 downto 0)
        );
    end component PCMux;

    component PCRegister is
    port(   
            rst,clk : in std_logic;
            PCHold : in std_logic;
            PCHold2: in std_logic;
            PCIn : in std_logic_vector(15 downto 0);
            PCOut : out std_logic_vector(15 downto 0)
        );
    end component PCRegister;


--   component  VGA_play is
--        Port(
--            -- common port
--            CLK_0: in std_logic; -- must 50M
--            clkout: out std_logic; -- used to sync
--            reset: in std_logic;
            
            
--            -- vga port
--            color: out std_logic_vector(7 downto 0);
--            color1:out std_logic_vector(7 downto 0);
--            Hs: out std_logic := '0';
--            Vs: out std_logic := '0';
--            v_clk: out std_logic;
--            de: out std_logic := '0';
            
--            -- fifo memory
--            wctrl: in std_logic_vector(0 downto 0); -- 1 is write
--            waddr: in std_logic_vector(10 downto 0);
--            wdata : in std_logic_vector(7 downto 0)
--        );
--    end component VGA_play;
    
    component fontRom
        port (
                clka : in std_logic;
                addra : in std_logic_vector(10 downto 0);
                douta : out std_logic_vector(7 downto 0)
        );
    end component;
    
	component VGA_Controller
        port (
        -- common port
        RegPC: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegR0: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegR1: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegR2: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegR3: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegR4: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegR5: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegR6: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegR7: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegSP: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegIH: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegT: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Clock: in std_logic; -- must 50M
        reset: in std_logic;
        video_vsync: OUT STD_LOGIC:= '0';
        video_hsync: OUT STD_LOGIC:= '0';
        video_pixel: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        video_clk: OUT STD_LOGIC;
        -- vga port
        video_de: out std_logic := '0'
    );    
    end component;

    --component MemoryController is
    --Port(
    --    address1 : in  STD_LOGIC_VECTOR (15 downto 0); --1为指令内存地址和数据
    --    output1 : out  STD_LOGIC_VECTOR (15 downto 0);
    --    address2 : in  STD_LOGIC_VECTOR (15 downto 0);--2为数据内存地址和数据，用于访存阶段
    --    output2 : out  STD_LOGIC_VECTOR (15 downto 0);
    --    clk: in STD_LOGIC;--一个高频时钟
    --    cpuclock : out STD_LOGIC;--时钟四分频后输出
        
    --    --flash部分的信号，只是接到上层例化用于管脚绑定，在这一层实际上木有用
    --    flash_byte : out std_logic;
    --    flash_vpen : out std_logic;
    --    flash_ce : out std_logic;
    --    flash_oe : out std_logic;
    --    flash_we : out std_logic;
    --    flash_rp : out std_logic;
    --    flash_addr : out std_logic_vector(22 downto 1);
    --    flash_data : inout std_logic_vector(15 downto 0);
        
    --    --内存读写部分的信号
    --    dataWrite : in  STD_LOGIC_VECTOR (15 downto 0); --要写的数据
    --    memoryAddr : out STD_LOGIC_VECTOR (17 downto 0);
    --    MemWrite : in STD_LOGIC; --内存写信号
    --    MemRead : in STD_LOGIC; --内存读信号
    --    memoryEN : out STD_LOGIC;
    --    memoryOE : out STD_LOGIC;
    --    memoryRW : out STD_LOGIC;
        
    --    --扩展数据线
    --    extendDatabus : inout STD_LOGIC_VECTOR(15 downto 0);
        
    --    --串口和VGA部分的信号
    --    serial_wrn : out STD_LOGIC;
    --    serial_rdn : out STD_LOGIC;
    --    serial_dataready : in STD_LOGIC;
    --    serial_tsre : in STD_LOGIC;
    --    serial_tbre : in STD_LOGIC;
    --    basicdatabus : inout STD_LOGIC_VECTOR(7 downto 0);
    --    ram1_en : out STD_LOGIC;
    --    reset : in STD_LOGIC;
    --    VGA_addr : out std_logic_vector(10 downto 0);
    --    VGA_write : out std_LOGIC_vector(0 downto 0);
    --    VGA_char : out std_logic_vector(7 downto 0)
    --);
    --end component MemoryController;

   component MemoryUnit
    port(
        --时钟
        clk : in std_logic;
        rst : in std_logic;
        
        --串口
        data_ready : in std_logic;      --数据准备信号，='1'表示串口的数据已准备好（读串口成功，可显示读到的data）
        tbre : in std_logic;                --发送数据标志
        tsre : in std_logic;                --数据发送完毕标志，tsre and uart_tbre = '1'时写串口完毕
        wrn : out std_logic;                --写串口，初始化为'1'，先置为'0'并把RAM1data赋好，再置为'1'写串口
        rdn : out std_logic;                --读串口，初始化为'1'并将RAM1data赋为"ZZ..Z"，
                                                --若data_ready='1'，则把rdn置为'0'即可读串口（读出数据在RAM1data上）
        
        --RAM1（DM）和RAM2（IM）
        MemRead : in std_logic;         --控制读DM的信号，='1'代表需要读
        MemWrite : in std_logic;        --控制写DM的信号，='1'代表需要写
        
        dataIn : in std_logic_vector(15 downto 0);      --写内存时，要写入DM或IM的数据
        
        ramAddr : in std_logic_vector(15 downto 0);     --读DM/写DM/写IM时，地址输入
        PCOut : in std_logic_vector(15 downto 0);           --读IM时，地址输入
        dataOut : out std_logic_vector(15 downto 0);        --读DM时，读出来的数据/读出的串口状态
        insOut : out std_logic_vector(15 downto 0);     --读IM时，出来的指令
        
        ram1_addr : out std_logic_vector(19 downto 0);  --RAM1地址总线
        ram2_addr : out std_logic_vector(19 downto 0);  --RAM2地址总线
        ram1_data : inout std_logic_vector(15 downto 0);--RAM1数据总线
        ram2_data : inout std_logic_vector(15 downto 0);--RAM2数据总线
        
--        ram2AddrOutput : out std_logic_vector(17 downto 0);
        
        ram1_en : out std_logic;        --RAM1使能，='1'禁止
        ram1_oe : out std_logic;        --RAM1读使能，='1'禁止；
        ram1_we : out std_logic;        --RAM1写使能，='1'禁止
        ram2_en : out std_logic;        --RAM2使能，='1'禁止
        ram2_oe : out std_logic;        --RAM2读使能，='1'禁止
        ram2_we : out std_logic;        --RAM2写使能，='1'禁止
        MemoryState : out std_logic_vector(15 downto 0);
   
        --Flash
        flash_addr : out std_logic_vector(22 downto 0);     --flash地址线
        flash_data : inout std_logic_vector(15 downto 0);   --flash数据线
        
        flash_byte : out std_logic; --flash操作模式，常置'1'
        flash_vpen : out std_logic; --flash写保护，常置'1'
        flash_rp : out std_logic;       --'1'表示flash工作，常置'1'
        flash_ce : out std_logic;       --flash使能
        flash_oe : out std_logic;       --flash读使能，'0'有效，每次读操作后置'1'
        flash_we : out std_logic        --flash写使能
    );
    end component;
    

    --时钟
    component Clock
    port ( 
        rst : in STD_LOGIC;
        clk : in  STD_LOGIC;
        
        clkout :out STD_LOGIC;
        clk1 : out  STD_LOGIC;
        clk2 : out STD_LOGIC
    );
    end component;

    component id is
        port(
        clock, reset, pause, flush: in std_logic;
        clock_register: in std_logic;
        jump, bubble: in std_logic;
        instruction: in std_logic_vector(15 downto 0);
        fromPC: in std_logic_vector(15 downto 0);
        
        write_register: in std_logic;
        writeData: in std_logic_vector(15 downto 0);
        writeAddress: in std_logic_vector(3 downto 0);
    
        memoryRead: out std_logic;
        memoryWrite: out std_logic;
        registerWrite: out std_logic;
        where: out std_logic;
        wb_memory_or_alu_out: out std_logic_vector(1 downto 0);
        branch: out std_logic_vector(2 downto 0);
        
        pc: out std_logic_vector(15 downto 0);
        
        immediate: out std_logic_vector(15 downto 0);
        rx: out std_logic_vector(15 downto 0);
        ry: out std_logic_vector(15 downto 0);
        sp: out std_logic_vector(15 downto 0);
        ra: out std_logic_vector(15 downto 0);
        ih: out std_logic_vector(15 downto 0);
        t: out std_logic_vector(15 downto 0);
        R0: out std_logic_vector(15 downto 0);
        R1: out std_logic_vector(15 downto 0);
        R2: out std_logic_vector(15 downto 0);
        R3: out std_logic_vector(15 downto 0);
        R4: out std_logic_vector(15 downto 0);
        R5: out std_logic_vector(15 downto 0);
        R6: out std_logic_vector(15 downto 0);
        R7: out std_logic_vector(15 downto 0);
        
        exe_alu_op: out std_logic_vector(2 downto 0);
        exe_alu_rx: out std_logic_vector(2 downto 0);
        exe_alu_ry: out std_logic_vector(1 downto 0);
        exe_address: out std_logic_vector(1 downto 0);
        exe_select_goal: out std_logic_vector(2 downto 0);
        r_x: out std_logic_vector(2 downto 0);
        r_y: out std_logic_vector(2 downto 0);
        r_z: out std_logic_vector(2 downto 0)
        
    );
    end component id;



    component exe is
        port(
        clock: in std_logic;
        reset : in std_logic;
        from_wb_memory_or_alu_out: in std_logic_vector(1 downto 0);
        wb_memory_or_alu_out: out std_logic_vector(1 downto 0);
        exe_select_goal: in std_logic_vector(2 downto 0);
        exe_alu_op: in std_logic_vector(2 downto 0);
        exe_alu_rx: in std_logic_vector(2 downto 0);
        exe_alu_ry: in std_logic_vector(1 downto 0);
        exe_address: in  std_logic_vector(1 downto 0);
        from_memoryWrite: in std_logic;
        memoryWrite: out std_logic;
        from_memoryRead: in std_logic;
        memoryRead: out std_logic;
        from_registerWrite: in std_logic;
        registerWrite: out std_logic;
        fromWhere: in std_logic;
        where: out std_logic;
        memoryData : out STD_LOGIC_VECTOR(15 downto 0);
        
         memory_data_forward: in std_logic;
                       forward_memory_data: in std_logic_vector(15 downto 0);
        
                forward_exe_alu_rx: out std_logic_vector(2 downto 0);
                        forward_exe_alu_ry: out std_logic_vector(1 downto 0);
                        forward_exe_address: out  std_logic_vector(1 downto 0);
                forward_r_x: out std_logic_vector(2 downto 0);
                        forward_r_y: out std_logic_vector(2 downto 0);

        fromBranch: in std_logic_vector(2 downto 0);
        shouldJump: out std_logic;
        jumpAddress: out std_logic_vector(15 downto 0);
        
        rx: in std_logic_vector(15 downto 0);
        ry: in std_logic_vector(15 downto 0);
        sp: in std_logic_vector(15 downto 0);
        pc: in std_logic_vector(15 downto 0);
        ra: in std_logic_vector(15 downto 0);
        ih: in std_logic_vector(15 downto 0);
        t: in std_logic_vector(15 downto 0);
        immediate: in std_logic_vector(15 downto 0);
        
        r_x: in std_logic_vector(2 downto 0);
        r_y: in std_logic_vector(2 downto 0);
        r_z: in std_logic_vector(2 downto 0);
        
        goal: out std_logic_vector(3 downto 0);
        alu_out: out std_logic_vector(15 downto 0);

        from_forwardx: in std_logic;
        from_forwardy: in std_logic;
        from_forward_address: in std_logic;
        
        forward_datax: in std_logic_vector(15 downto 0);
        forward_datay: in std_logic_vector(15 downto 0);
        forward_address: in std_logic_vector(15 downto 0)
    );
    end component exe;


    --component EXEMEM is

    --end  component EXEMEM;


    component exe_mem is
        port(
            clk : in std_logic;
            reset : in std_logic;
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
    end component;

    component mem_wb is
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
    end component;

    --component MEMWB is

    --end  component MEMWB;

    component forward is
        port(
            exe_alu_rx: in std_logic_vector(2 downto 0);
            exe_alu_ry: in std_logic_vector(1 downto 0);
            exe_select_address: in std_logic_vector(1 downto 0);
            
            memoryWrite: in std_logic;
                    exe_where: in std_logic;

            rx: in std_logic_vector(2 downto 0);
            ry: in std_logic_vector(2 downto 0);

            address_memory: in std_logic_vector(3 downto 0);
            mem_registerWrite: in std_logic;
            mem_aluout: in std_logic_vector(15 downto 0);
            
            memory_which: in std_logic_vector(1 downto 0);
            wb_memory_data: in std_logic_vector(15 downto 0);

            address_wb: in std_logic_vector(3 downto 0);
            wb_registerWrite: in std_logic;
            wb_toRegister: in std_logic_vector(15 downto 0);

            from_forward_datax: out std_logic;
            from_forward_datay: out std_logic;
            from_forward_address: out std_logic;
            
            from_forward_memory: out std_logic;
            
            forward_memory: out std_logic_vector(15 downto 0);
            
            forward_datay: out std_logic_vector(15 downto 0);

            forward_data: out std_logic_vector(15 downto 0)

        );
    end component forward;

    component hazard is
        port(
        memoryRead: in std_logic;
--        goal: in std_logic_vector(3 downto 0);
        exe_memory_read: in std_logic;
		goal: in std_logic_vector(3 downto 0);
        instruction: in std_logic_vector(15 downto 0);
        r_x: in std_logic_vector(2 downto 0);
                r_y: in std_logic_vector(2 downto 0);
                selection: in std_logic_vector(2 downto 0);
        
        pause: out std_logic;
        bubble: out std_logic
    );
    end component  hazard;

  
    component RestControler is
    port(

        reset_in: in STD_LOGIC;
        load_finsh: in std_logic;
        reset_out: out STD_LOGIC
        );
    end component RestControler;

-----clock---

signal R0test:std_logic_vector(15 downto 0);
signal R1test:std_logic_vector(15 downto 0);
signal R2test:std_logic_vector(15 downto 0);
signal R3test:std_logic_vector(15 downto 0);
signal R4test:std_logic_vector(15 downto 0);
signal R5test:std_logic_vector(15 downto 0);
signal R6test:std_logic_vector(15 downto 0);
signal R7test:std_logic_vector(15 downto 0);

signal mem_test_pc:std_logic_vector(15 downto 0);

signal clk_3 : std_logic;
signal clk_registers : std_logic;
signal clk : std_logic;
signal clkIn_clock : std_logic;
--signal clk_div4 : std_logic:='0';
--signal clk_div8 : std_logic:='0';


signal s_forward_r_x: std_logic_vector(2 downto 0);
signal s_forward_r_y: std_logic_vector(2 downto 0);

signal s_forward_exe_alu_rx:std_logic_vector(2 downto 0);
signal s_forward_exe_alu_ry:std_logic_vector(1 downto 0);
signal s_forward_exe_address:std_logic_vector(1 downto 0);

signal s_pc_mux:std_logic_vector(15 downto 0);
signal s_pc_add_address:std_logic_vector(15 downto 0);
signal s_pc_reg:std_logic_vector(15 downto 0);
signal s_flash_load_finsh: std_logic;
signal s_reset_out: std_logic;

signal s_id_memoryRead:std_logic;
signal s_id_memoryWrite:std_logic;
signal s_id_registerWrite:std_logic;
signal s_id_where:STD_LOGIC;
signal s_id_wb_memory_or_alu_out:std_logic_vector(1 downto 0);
signal s_id_branch:std_logic_vector(2 downto 0);
signal s_id_pc:std_logic_vector(15 downto 0);
signal s_id_immediate:std_logic_vector(15 downto 0);

signal s_id_rx:std_logic_vector(15 downto 0);
signal s_id_ry:std_logic_vector(15 downto 0);
signal s_id_sp:std_logic_vector(15 downto 0);
signal s_id_ra:std_logic_vector(15 downto 0);
signal s_id_ih:std_logic_vector(15 downto 0);
signal s_id_t:std_logic_vector(15 downto 0);     
signal s_id_exe_alu_op:std_logic_vector(2 downto 0);
signal s_id_exe_alu_rx:std_logic_vector(2 downto 0);
signal s_id_exe_alu_ry:std_logic_vector(1 downto 0);
signal s_id_exe_address:std_logic_vector(1 downto 0);
signal s_id_exe_select_goal:std_logic_vector(2 downto 0);
signal s_id_r_x:std_logic_vector(2 downto 0);
signal s_id_r_y:std_logic_vector(2 downto 0);
signal s_id_r_z:std_logic_vector(2 downto 0);

signal s_exe_regwrite_out:std_logic;
signal s_exe_aluout_out:STD_LOGIC_VECTOR(15 downto 0);

--signal s_mem_rd_in:std_logic_vector(3 downto 0);
--signal s_mem_rd_id_exe:std_logic_vector(3 downto 0);


signal  s_exe_wb_memory_or_alu_out:std_logic_vector(1 downto 0);
signal  s_exe_memoryWrite:std_logic;
signal  s_exe_memoryRead:std_logic;
signal  s_exe_registerWrite:std_logic;
signal  s_exe_where:std_logic;
signal  s_exe_memData : std_logic_vector (15 downto 0);
signal  s_exe_shouldJump:std_logic;
signal  s_exe_jumpAddress:std_logic_vector(15 downto 0);
signal  s_exe_goal:std_logic_vector(3 downto 0);
signal  s_exe_alu_out:std_logic_vector(15 downto 0);
signal  s_exe_memadress_out:std_logic_vector(15 downto 0);
signal  s_exe_memdata_out:std_logic_vector(15 downto 0);
signal  s_exe_memwrite_out:std_logic;
signal  s_exe_memread_out:std_logic;
signal  s_exe_memtoreg_out:std_logic_vector(1 downto 0);
signal  s_exe_rd_out:std_logic_vector(3 downto 0);


signal s_memout_mem: std_logic_vector(15 downto 0);
signal s_instruction: std_logic_vector(15 downto 0);
signal s_pause:STD_LOGIC;
signal s_bubble:std_logic;
signal s_wb_write: std_logic;
signal s_wb_writeData:  std_logic_vector(15 downto 0);
signal s_wb_writeAddress:  std_logic_vector(3 downto 0);
----vga----

signal vga_data:std_logic_vector(7 downto 0):="00010001";
signal vga_addr:std_logic_vector(10 downto 0):="00000000100";
signal VGA_write : std_logic_vector(0 downto 0);
signal count:natural range 0 to 3 := 0;

signal s_from_forward_datax:std_logic;
signal s_from_forward_datay:std_logic;
signal s_from_forward_address:std_logic;
signal s_forward_data:std_logic_vector(15 downto 0);

--font rom
signal fontRomAddr : std_logic_vector(10 downto 0);
signal fontRomData : std_logic_vector(7 downto 0);

signal s_forward_memory: std_logic;
signal s_forward_memory_data:std_logic_vector(15 downto 0);
signal s_forward_datay:std_logic_vector(15 downto 0);


begin

    u18 : Clock
    port map(
        rst => rst,
        clk => clkIn_clock,
        
        clkout => clk,
        clk1 => clk_3,
        clk2 => clk_registers
    );

    u17 : MemoryUnit
        port map( 
            clk => clkIn_clock,
            rst => rst,
            
            data_ready => dataready,
            tbre => tbre,
            tsre => tsre,
            wrn => wrn,
            rdn => rdn,
              
            MemRead => s_exe_memread_out,
            MemWrite => s_exe_memwrite_out,
            
            dataIn => s_exe_memdata_out,
            
            ramAddr => s_exe_memadress_out,
            PCOut => s_pc_reg, --- 
           
            dataOut => s_memout_mem,---
            insOut => s_instruction,---
            
            ram1_addr => base_ram_addr(19 downto 0),
            ram2_addr => ext_ram_addr(19 downto 0),
            ram1_data => base_ram_data(15 downto 0),
            ram2_data => ext_ram_data(15 downto 0),
            
            ram1_en => en1,
            ram1_oe => oe1,
            ram1_we => we1,
            ram2_en => en2,
            ram2_oe => oe2,
            ram2_we => we2,
--            ram2_addr => base_ram_addr(19 downto 0),
--            ram1_addr => ext_ram_addr(19 downto 0),
--            ram2_data => base_ram_data(15 downto 0),
--            ram1_data => ext_ram_data(15 downto 0),
            
--            ram2_en => en1,
--            ram2_oe => oe1,
--            ram2_we => we1,
--            ram1_en => en2,
--            ram1_oe => oe2,
--            ram1_we => we2,
            MemoryState => mem_test_pc,
            
            flash_addr => flash_addr,
            flash_data => flash_data,
            
            flash_byte => flash_byte,
            flash_vpen => flash_vpen,
            flash_rp => flash_rp,
            flash_ce => flash_ce,
            flash_oe => flash_oe,
            flash_we => flash_we
        );
  

    local_pc_adder: PCAdder port map(
        adderIn => s_pc_reg,
        adderOut => s_pc_add_address
        );

    local_pc_mux: PCMux port map(
   
            branch => s_exe_shouldJump,
            PCNext =>  s_pc_add_address,
            PCJump => s_exe_jumpAddress,       
            PCOut => s_pc_mux
        );

    local_pc_reg:  PCRegister port map(   
            rst => rst,
            clk => clk_3,
            PCHold => s_bubble,
            PCHold2 => s_pause,
            PCIn => s_pc_mux,
            PCOut => s_pc_reg
        );


    local_id: id port map(
        --clock_register => clk_registers,
        clock_register => clk,
        clock => clk_3,
        reset => rst,
        pause => s_pause, 
        flush => s_exe_shouldJump,
        jump => s_exe_shouldJump,
        bubble => s_bubble,
        instruction => s_instruction,
        fromPC => s_pc_reg,
        
        write_register =>s_wb_write,
        writeData => s_wb_writeData,
        writeAddress => s_wb_writeAddress,
    
        memoryRead => s_id_memoryRead,
        memoryWrite => s_id_memoryWrite,
        registerWrite => s_id_registerWrite,
        where => s_id_where,

        wb_memory_or_alu_out => s_id_wb_memory_or_alu_out,

        branch => s_id_branch,
        
        pc => s_id_pc,
        
        immediate => s_id_immediate,

        rx => s_id_rx,
        ry => s_id_ry,
        sp => s_id_sp,
        ra =>s_id_ra,
        ih => s_id_ih,
        t => s_id_t,
        R0 => R0test,
        R1 => R1test,
        R2 => R2test,
        R3 => R3test,
        R4 => R4test,
        R5 => R5test,
        R6 => R6test,
        R7 => R7test,
        
        exe_alu_op => s_id_exe_alu_op,
        exe_alu_rx => s_id_exe_alu_rx,
        exe_alu_ry => s_id_exe_alu_ry,
        exe_address => s_id_exe_address,
        exe_select_goal => s_id_exe_select_goal,
        r_x => s_id_r_x,
        r_y => s_id_r_y,
        r_z => s_id_r_z
        
    );
    
    local_exe: exe port map(
                forward_exe_alu_rx => s_forward_exe_alu_rx,
            forward_exe_alu_ry => s_forward_exe_alu_ry,
            forward_exe_address => s_forward_exe_address,
            forward_r_x => s_forward_r_x,
            forward_r_y => s_forward_r_y,
        clock => clk_3,
        reset => rst,
        --pause: in std_logic;
        from_wb_memory_or_alu_out => s_id_wb_memory_or_alu_out,
        wb_memory_or_alu_out => s_exe_wb_memory_or_alu_out,
        exe_select_goal => s_id_exe_select_goal,
        exe_alu_op => s_id_exe_alu_op,
        exe_alu_rx => s_id_exe_alu_rx,
        exe_alu_ry => s_id_exe_alu_ry,
        exe_address => s_id_exe_address,
        from_memoryWrite => s_id_memoryWrite,
        memoryWrite => s_exe_memoryWrite,
        from_memoryRead => s_id_memoryRead,
        memoryRead => s_exe_memoryRead,
        from_registerWrite => s_id_registerWrite,

        registerWrite => s_exe_registerWrite,
        fromWhere => s_id_where,
        where => s_exe_where,
        memoryData => s_exe_memData,
        
        fromBranch => s_id_branch,
        shouldJump => s_exe_shouldJump,
        jumpAddress => s_exe_jumpAddress,
        
        rx => s_id_rx,
        ry => s_id_ry,
        sp => s_id_sp,
        pc => s_id_pc,
        ra => s_id_ra,
        ih => s_id_ih,
        t => s_id_t,
        immediate => s_id_immediate,
        
        r_x => s_id_r_x,
        r_y => s_id_r_y,
        r_z => s_id_r_z,
        
        goal => s_exe_goal,
        alu_out => s_exe_alu_out,

        from_forwardx => s_from_forward_datax,
        from_forwardy => s_from_forward_datay,
        from_forward_address => s_from_forward_address,
        memory_data_forward => s_forward_memory,
        forward_memory_data => s_forward_memory_data,
        
        
        forward_datax => s_forward_data,
        forward_datay => s_forward_datay,
        forward_address => s_forward_data
    );
   
    local_exe_mem: exe_mem port map(
        clk => clk_3,
        reset => rst,
        aluout_in => s_exe_alu_out,
        memwrite_in => s_exe_memoryWrite,
        memread_in => s_exe_memoryRead,
        out_sw_in => s_exe_memData,
        regwrite_in => s_exe_registerWrite,
        memtoreg_in => s_exe_wb_memory_or_alu_out,
        --rd_in => s_mem_rd_id_exe,
        rd_in => s_exe_goal,
        
        memadress_out => s_exe_memadress_out,
        memdata_out => s_exe_memdata_out,
        memwrite_out => s_exe_memwrite_out,
        memread_out => s_exe_memread_out,
        memtoreg_out => s_exe_memtoreg_out,
        regwrite_out => s_exe_regwrite_out,
        aluout_out => s_exe_aluout_out,
        rd_out => s_exe_rd_out
    );
    
	u23 : VGA_Controller
    port map(
    --VGA Side
        video_hsync => Hs,
        video_vsync => Vs,
        video_pixel => video_color,
        video_de => video_de,
        video_clk => video_clk,

    -- data
        RegR0 => R0test,
        RegR1 => R1test,
        RegR2 => R2test,
        RegR3 => R3test,
        RegR4 => R4test,
        RegR5 => R5test,
        RegR6 => R6test,
        RegR7 => R7test,
        RegPC => mem_test_pc,
        RegT => s_id_t,
--        RegT => s_id_immediate,
--        RegIH => s_id_ih,
        RegIH => s_instruction,
--        RegSP => s_id_sp,
        RegSP => s_exe_alu_out,
    --Control Signals
        reset    => rst,
        Clock => clk_in
    );    
   

    local_mem_wb: mem_wb port map(
        clk => clk_3,
        reset => rst,
        memtoreg_in => s_exe_memtoreg_out,
        regwrite_in => s_exe_regwrite_out,
        aluout_in => s_exe_aluout_out,
        memout_in => s_memout_mem,
        --rd_in => s_mem_rd_in,
        rd_in => s_exe_rd_out,
        
        wbregwrite_out => s_wb_write,
        wbadress_out => s_wb_writeAddress,
        wbregdata_out => s_wb_writeData
    );
    
    local_hazard: hazard port map(
        exe_memory_read => s_exe_memoryRead,
        memoryRead => s_id_memoryRead,
        goal => s_exe_goal,
        instruction => s_instruction,
        r_x =>s_id_r_x,
        r_y =>s_id_r_y,
        selection=>s_id_exe_select_goal,
        
        pause => s_pause,
        bubble => s_bubble
    );
    local_forward: forward port map(
--        exe_alu_rx => s_id_exe_alu_rx,
--        exe_alu_ry =>s_id_exe_alu_ry,
--        exe_select_address => s_id_exe_address,

--        rx => s_id_r_x,
--        ry => s_id_r_y,
memory_which => s_exe_memtoreg_out,
wb_memory_data =>s_exe_memdata_out,
exe_alu_rx => s_forward_exe_alu_rx,
        exe_alu_ry =>s_forward_exe_alu_ry,
        exe_select_address => s_forward_exe_address,
        
        memoryWrite => s_exe_memoryWrite,
                exe_where => s_exe_where,

        rx => s_forward_r_x,
        ry => s_forward_r_y,

        address_memory => s_exe_rd_out,
        mem_registerWrite => s_exe_regwrite_out,
        mem_aluout => s_exe_aluout_out,

        --address_wb => s_mem_rd_in,
        address_wb => s_wb_writeAddress,
        wb_registerWrite => s_wb_write,
        wb_toRegister => s_wb_writeData,

        from_forward_datax => s_from_forward_datax,
        from_forward_datay => s_from_forward_datay,
        from_forward_address => s_from_forward_address,
        from_forward_memory => s_forward_memory,
        forward_memory => s_forward_memory_data,
        forward_datay => s_forward_datay,
        forward_data => s_forward_data

    );
   
--    process (clk_in)
--    begin
--        if clk_in'event and clk_in = '1' then    --对50M输入信号二分频
--            clk_div4 <= not clk_div4;
--        end if;
--    end process;
    
--    process (clk_div4)
--      begin
--          if clk_div4'event and clk_div4 = '1' then    --对50M输入信号二分频
--              clk_div8 <= not clk_div8;
--          end if;
--    end process;
                                                              
                                                          
    --clk_chooser
        process(clk_in, clk_hand, op,rst)
        begin
            if op = '1' then
                if rst = '1' then
                    clkIn_clock <= '0';
                else
                    clkIn_clock <=clk_in;
                end if;
            else
                if rst = '1' then
                    clkIn_clock <= '0';
                else 
                    clkIn_clock <= clk_hand;
                end if;
            end if;
        end process;
         
    
   
 --   leds(13 downto 8) <= base_ram_addr(19 downto 14);
--    leds(15 downto 8) <= s_instruction(15 downto 8);
--    leds(7 downto 0) <= s_pc_reg(7 downto 0);
--    leds(7 downto 0) <= fontRomData(7 downto 0);
    leds(15 downto 0) <= s_forward_data;
    leds(28) <= s_forward_memory;
--leds(15 downto 0) <= s_instruction(15 downto 0);
    leds(16) <= s_exe_shouldJump;
    leds(19 downto 17) <= s_id_branch;
    leds(24) <= s_wb_write;
    leds(25) <= s_from_forward_datax;
    leds(26) <= s_exe_regwrite_out;


end architecture ; -- Computer_beh
