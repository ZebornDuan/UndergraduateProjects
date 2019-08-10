library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
entity VGA_Controller is
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
end entity VGA_Controller;

architecture behave of VGA_Controller is
	signal clk: std_logic; -- div 50M to 25M
signal OnOff: std_logic;
signal vector_x : std_logic_vector(9 downto 0);        --X 10b 640
signal vector_y : std_logic_vector(8 downto 0);        --Y 9b 480
signal r0 : std_logic_vector(2 downto 0);
signal g0 : std_logic_vector(2 downto 0);
signal b0 : std_logic_vector(1 downto 0);
signal hs1 : std_logic;
signal vs1 : std_logic;

signal char: std_logic_vector(7 downto 0) := "00000000";
signal pr: STD_LOGIC_VECTOR(0 DOWNTO 0);
signal char_addr: std_logic_vector(14 downto 0);
signal caddr: std_logic_vector(10 downto 0);
    type matrix IS array (15 downto 0) of std_logic_vector (15 downto 0);
    signal zero : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000011111100000",
        "0000010000100000",
        "0000010000100000",
        "0000010000100000",
        "0000010000100000",
        "0000010000100000",
        "0000010000100000",
        "0000010000100000",
        "0000011111100000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );

    signal one : matrix := (
         "0000000000000000",
         "0000000000000000",
         "0000000111000000",
         "0000001011000000",
         "0000000011000000",
         "0000000011000000",
         "0000000011000000",
         "0000000011000000",
         "0000000011000000",
         "0000000011000000",
         "0000111111111000",
         "0000000000000000",
         "0000000000000000",
         "0000000000000000",
         "0000000000000000",
         "0000000000000000"
    );
    signal symbolr : matrix := (
      "0000000000000000",
      "0000000000000000",
      "0000000111111000",
      "0000000111111100",
      "0000000110000100",
      "0000000110001000",
      "0000000111110000",
      "0000000110110000",
      "0000000110011000",
      "0000000110001100",
      "0000000110000110",
      "0000000110000011",
      "0000000000000000",
      "0000000000000000",
      "0000000000000000",
      "0000000000000000"
    );
    signal two : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000011111110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000111111110000",
        "0000110000000000",
        "0000110000000000",
        "0000110000000000",
        "0000111111100000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal three : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000011111110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000011111110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000011111110000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal four : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000010000110000",
        "0000010000110000",
        "0000010000110000",
        "0000010000110000",
        "0000011111110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal five : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000111111100000",
        "0000110000000000",
        "0000110000000000",
        "0000110000000000",
        "0000111111110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000011111110000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal six : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000111111100000",
        "0000110000000000",
        "0000110000000000",
        "0000110000000000",
        "0000111111100000",
        "0000110000100000",
        "0000110000100000",
        "0000110000100000",
        "0000111111100000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal seven : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000011111110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000110000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal symboli : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000000011110000",
        "0000000001100000",
        "0000000001100000",
        "0000000001100000",
        "0000000001100000",
        "0000000001100000",
        "0000000001100000",
        "0000000001100000",
        "0000000011110000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal symbolh : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000010000110000",
        "0000010000110000",
        "0000010000110000",
        "0000010000110000",
        "0000011111110000",
        "0000010000110000",
        "0000010000110000",
        "0000010000110000",
        "0000010000110000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal symbolt : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000001111111100",
        "0000000001100000",
        "0000000001100000",
        "0000000001100000",
        "0000000001100000",
        "0000000001100000",
        "0000000001100000",
        "0000000001100000",
        "0000000001100000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal symbols : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000000011110000",
        "0000000110011000",
        "0000000100001110",
        "0000000010000000",
        "0000000001000000",
        "0000000000100000",
        "0000000000010000",
        "0000011100011000",
        "0000000110001000",
        "0000000011110000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal symbolp : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000111111000000",
        "0000110000110000",
        "0000110000110000",
        "0000110000110000",
        "0000111111100000",
        "0000110000000000",
        "0000110000000000",
        "0000110000000000",
        "0000110000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal symbolp2 : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000001111110000",
        "0000001100001000",
        "0000001100001000",
        "0000001100001000",
        "0000001111110000",
        "0000001100000000",
        "0000001100000000",
        "0000001100000000",
        "0000001100000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
    signal symbolc : matrix := (
        "0000000000000000",
        "0000000000000000",
        "0000001111000000",
        "0000011000100000",
        "0000110000000000",
        "0000110000000000",
        "0000110000000000",
        "0000110000000000",
        "0000110000000000",
        "0000011000100000",
        "0000001111000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000",
        "0000000000000000"
    );
begin


process(Clock)
begin
if(Clock'event and Clock = '1') then
    clk <= not clk;
    video_clk <= clk;
end if;
end process;

process(clk, reset)    -- 行区间像素数 (800)
begin
if reset = '1' then
    vector_x <= (others => '0');
elsif clk'event and clk = '1' then
    if vector_x = 799 then
        vector_x <= (others => '0');
    else
        vector_x <= vector_x + 1;
    end if;
end if;
end process;

process(clk, reset)    -- 场区间行数 (525)
begin
if reset = '1' then
    vector_y <= (others => '0');
elsif clk'event and clk = '1' then
    if vector_x = 799 then
        if vector_y = 524 then
            vector_y <= (others => '0');
        else
            vector_y <= vector_y + 1;
        end if;
    end if;
end if;
end process;

process(clk, reset) -- 行同步信号（640+消隐区：16空+96低+48空）
begin
if reset='1' then
    hs1 <= '1';
elsif clk'event and clk='1' then
    if vector_x >= 656 and vector_x < 752 then
        hs1 <= '0';
    else
        hs1 <= '1';
    end if;
end if;
end process;

process(clk, reset) -- 场同步信号（480+消隐区：10空+2低+33空）
begin
if reset = '1' then
    vs1 <= '1';
elsif clk'event and clk = '1' then
    if vector_y >= 490 and vector_y < 492 then
        vs1 <= '0';
    else
        vs1 <= '1';
    end if;
end if;
end process;

process(clk, reset)
begin
if reset = '1' then
    video_hsync <= '0';
    video_vsync <= '0';
elsif clk'event and clk = '1' then
    video_hsync <= hs1;
    video_vsync <= vs1;
end if;
end process;


process(Reset, Clock, vector_x, vector_y)
begin
    OnOff <= '1';
    if Reset = '1' then
        OnOff <= '0';
    elsif Clock'event and Clock = '1' then
        if vector_x > 639 or vector_y > 479 then
            OnOff <= '0';
            elsif vector_x > 144 and vector_x < 160 then
                if vector_y > 15 and vector_y < 145 then
                    if(symbolr((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 144 and vector_y < 161 then
                    if(symboli((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 160 and vector_y < 177 then
                    if(symbols((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 176 and vector_y < 193 then
                    if(symbolt((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 192 and vector_y < 208 then
                    if(symbolp2((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    OnOff <= '0';
                end if;
            elsif vector_x > 160 and vector_x < 176 then
                if vector_y > 15 and vector_y < 32 then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 32 and vector_y < 49 then
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 48 and vector_y < 65 then
                    if(two((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 64 and vector_y < 81 then
                    if(three((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 80 and vector_y < 97 then
                    if(four((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 96 and vector_y < 113 then
                    if(five((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 112 and vector_y < 129 then
                    if(six((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 128 and vector_y < 145 then
                    if(seven((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 144 and vector_y < 161 then
                    if(symbolh((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 160 and vector_y < 177 then
                    if(symbolp((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                elsif vector_y > 192 and vector_y < 209 then
                    if(symbolc((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    OnOff <= '0';
                end if;
            elsif vector_y > 15 and vector_y < 32 and vector_x > 192 and vector_x < 448 then
                if(RegR0(15 - ((conv_integer(vector_x)-192)/16)) = '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
            elsif vector_y > 32 and vector_y < 49 and vector_x > 192 and vector_x < 448 then
                if(RegR1(15 - ((conv_integer(vector_x)-192)/16)) = '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
            elsif vector_y > 48 and vector_y < 65 and vector_x > 192 and vector_x < 448 then
                if(RegR2(15 - ((conv_integer(vector_x)-192)/16)) = '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
            elsif vector_y > 64 and vector_y < 81 and vector_x > 192 and vector_x < 448 then
                if(RegR3(15 - ((conv_integer(vector_x)-192)/16)) = '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
            elsif vector_y > 80 and vector_y < 97 and vector_x > 192 and vector_x < 448 then
                if(RegR4(15 - ((conv_integer(vector_x)-192)/16))= '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
            elsif vector_y > 96 and vector_y < 113 and vector_x > 192 and vector_x < 448 then
                if(RegR5(15 - ((conv_integer(vector_x)-192)/16)) = '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
            elsif vector_y > 112 and vector_y < 129 and vector_x > 192 and vector_x < 448 then
                if(RegR6(15 - ((conv_integer(vector_x)-192)/16)) = '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
            elsif vector_y > 128 and vector_y < 145 and vector_x > 192 and vector_x < 448 then
                if(RegR7(15 - ((conv_integer(vector_x)-192)/16)) = '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
            elsif vector_y > 144 and vector_y < 161 and vector_x > 192 and vector_x < 448 then
             if(RegIH(15 - ((conv_integer(vector_x)-192)/16)) = '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
            elsif vector_y > 160 and vector_y < 177 and vector_x > 192 and vector_x < 448 then
                if(RegSP(15 - ((conv_integer(vector_x)-192)/16)) = '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
            elsif vector_y > 176 and vector_y < 192 and vector_x > 192 and vector_x < 448 then
                if(RegT(15 - ((conv_integer(vector_x)-192)/16)) = '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
                elsif vector_y > 192 and vector_y < 209 and vector_x > 192 and vector_x < 448 then
                if(RegPC(15 - ((conv_integer(vector_x)-192)/16)) = '0') then
                    if(zero((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                else
                    if(one((15-conv_integer(vector_y)) mod 16)((15-conv_integer(vector_x)) mod 16) = '1') then
                        OnOff <= '1';
                    else
                        OnOff <= '0';
                    end if;
                end if;
            else
                OnOff <= '0';
            end if;
        end if;
end process;

process(reset, clk, vector_x, vector_y) -- X, Y 坐标控制
begin

if reset = '1' then
    r0 <= "000";
    g0 <= "000";
    b0 <= "00";
    video_de <= '0';
    
elsif clk'event and clk = '1' then
    if vector_x > 639 or vector_y > 479 then
        r0 <= "000";
        g0 <= "000";
        b0 <= "00";
        video_de <= '0';
    else
        video_de <= '1';
        -- play-ground        
        -- play-ground
        
        if OnOff <= '0' then
            r0 <= "011";
            g0 <= "111";
            b0 <= "11";
        else
            r0 <= "000";
            g0 <= "101";
            b0 <= "01";
        end if;
        
        -- play-ground
        -- play-ground
    end if;
end if;
end process;

process(hs1, vs1, r0, g0, b0) -- 最低的色彩输出
begin
if hs1 = '1' and vs1 = '1' then
video_pixel(7 downto 5) <= r0;
video_pixel(4 downto 2) <= g0;
video_pixel(1 downto 0) <= b0; 
 
else
    video_pixel(7 downto 5) <= "000";
    video_pixel(4 downto 2) <= "000";
    video_pixel(1 downto 0) <= "00"; 
end if;


end process;

end behave;