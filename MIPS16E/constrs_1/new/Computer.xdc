#Clock
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports clk_in]
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS33} [get_ports clk_uart_in]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_uart_in_IBUF]

create_clock -period 20.000 -name clk_in -waveform {0.000 10.000} [get_ports clk_in]
create_clock -period 90.422 -name clk_uart_in -waveform {0.000 45.211} [get_ports clk_uart_in]

#Touch Button
set_property IOSTANDARD LVCMOS33 [get_ports {touch_btn[*]}]
set_property PACKAGE_PIN J19 [get_ports {touch_btn[0]}]
set_property PACKAGE_PIN E25 [get_ports {touch_btn[1]}]
set_property PACKAGE_PIN F23 [get_ports {touch_btn[2]}]
set_property PACKAGE_PIN E23 [get_ports {touch_btn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk_hand]
set_property PACKAGE_PIN H19 [get_ports clk_hand]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_hand_IBUF]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PACKAGE_PIN F22 [get_ports rst]

#required if touch_btn[4] used as manual clock source

#CPLD
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports wrn]
set_property -dict {PACKAGE_PIN K22 IOSTANDARD LVCMOS33} [get_ports rdn]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports tbre]
set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports tsre]
set_property -dict {PACKAGE_PIN J24 IOSTANDARD LVCMOS33} [get_ports dataready]

#Ext serial
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN L19} [get_ports txd]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN K21} [get_ports rxd]

#USB
set_property -dict {PACKAGE_PIN K3 IOSTANDARD LVCMOS33} [get_ports sl811_a0]
set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVCMOS33} [get_ports sl811_we_n]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports sl811_rd_n]
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports sl811_cs_n]
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports sl811_rst_n]
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports sl811_drq]
set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS33} [get_ports sl811_dack]
set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS33} [get_ports sl811_int]
set_property -dict {PACKAGE_PIN L8 IOSTANDARD LVCMOS33} [get_ports {sl811_data[0]}]
set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS33} [get_ports {sl811_data[1]}]
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS33} [get_ports {sl811_data[2]}]
set_property -dict {PACKAGE_PIN L7 IOSTANDARD LVCMOS33} [get_ports {sl811_data[3]}]
set_property -dict {PACKAGE_PIN L4 IOSTANDARD LVCMOS33} [get_ports {sl811_data[4]}]
set_property -dict {PACKAGE_PIN L3 IOSTANDARD LVCMOS33} [get_ports {sl811_data[5]}]
set_property -dict {PACKAGE_PIN L2 IOSTANDARD LVCMOS33} [get_ports {sl811_data[6]}]
set_property -dict {PACKAGE_PIN R7 IOSTANDARD LVCMOS33} [get_ports {sl811_data[7]}]

#Ethernet
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports dm9k_we_n]
set_property -dict {PACKAGE_PIN D3 IOSTANDARD LVCMOS33} [get_ports dm9k_rd_n]
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS33} [get_ports dm9k_cs_n]
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports dm9k_rst_n]
set_property -dict {PACKAGE_PIN H8 IOSTANDARD LVCMOS33} [get_ports dm9k_int]
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports dm9k_cmd]
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[0]}]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[1]}]
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[2]}]
set_property -dict {PACKAGE_PIN H7 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[3]}]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[4]}]
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[5]}]
set_property -dict {PACKAGE_PIN K7 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[6]}]
set_property -dict {PACKAGE_PIN K6 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[7]}]
set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[8]}]
set_property -dict {PACKAGE_PIN H6 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[9]}]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[10]}]
set_property -dict {PACKAGE_PIN H1 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[11]}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[12]}]
set_property -dict {PACKAGE_PIN J6 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[13]}]
set_property -dict {PACKAGE_PIN K5 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[14]}]
set_property -dict {PACKAGE_PIN F5 IOSTANDARD LVCMOS33} [get_ports {dm9k_data[15]}]

#Digital Video
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33} [get_ports video_clk]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {video_color[7]}]
set_property -dict {PACKAGE_PIN N21 IOSTANDARD LVCMOS33} [get_ports {video_color[6]}]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33} [get_ports {video_color[5]}]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {video_color[4]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports {video_color[3]}]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports {video_color[2]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {video_color[1]}]
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {video_color[0]}]
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports Hs]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports Vs]
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports video_de]

#LEDS
set_property IOSTANDARD LVCMOS33 [get_ports {leds[*]}]
set_property PACKAGE_PIN A17 [get_ports {leds[0]}]
set_property PACKAGE_PIN G16 [get_ports {leds[1]}]
set_property PACKAGE_PIN E16 [get_ports {leds[2]}]
set_property PACKAGE_PIN H17 [get_ports {leds[3]}]
set_property PACKAGE_PIN G17 [get_ports {leds[4]}]
set_property PACKAGE_PIN F18 [get_ports {leds[5]}]
set_property PACKAGE_PIN F19 [get_ports {leds[6]}]
set_property PACKAGE_PIN F20 [get_ports {leds[7]}]
set_property PACKAGE_PIN C17 [get_ports {leds[8]}]
set_property PACKAGE_PIN F17 [get_ports {leds[9]}]
set_property PACKAGE_PIN B17 [get_ports {leds[10]}]
set_property PACKAGE_PIN D19 [get_ports {leds[11]}]
set_property PACKAGE_PIN A18 [get_ports {leds[12]}]
set_property PACKAGE_PIN A19 [get_ports {leds[13]}]
set_property PACKAGE_PIN E17 [get_ports {leds[14]}]
set_property PACKAGE_PIN E18 [get_ports {leds[15]}]
set_property PACKAGE_PIN D16 [get_ports {leds[16]}]
set_property PACKAGE_PIN F15 [get_ports {leds[17]}]
set_property PACKAGE_PIN H15 [get_ports {leds[18]}]
set_property PACKAGE_PIN G15 [get_ports {leds[19]}]
set_property PACKAGE_PIN H16 [get_ports {leds[20]}]
set_property PACKAGE_PIN H14 [get_ports {leds[21]}]
set_property PACKAGE_PIN G19 [get_ports {leds[22]}]
set_property PACKAGE_PIN J8 [get_ports {leds[23]}]

#DPY2
set_property PACKAGE_PIN H9 [get_ports {leds[24]}]
set_property PACKAGE_PIN G8 [get_ports {leds[25]}]
set_property PACKAGE_PIN G7 [get_ports {leds[26]}]
set_property PACKAGE_PIN G6 [get_ports {leds[27]}]
set_property PACKAGE_PIN D6 [get_ports {leds[28]}]
set_property PACKAGE_PIN E5 [get_ports {leds[29]}]
set_property PACKAGE_PIN F4 [get_ports {leds[30]}]
set_property PACKAGE_PIN G5 [get_ports {leds[31]}]

set_property IOSTANDARD LVCMOS33 [get_ports {dip_sw[*]}]
set_property PACKAGE_PIN N3 [get_ports {dip_sw[0]}]
set_property PACKAGE_PIN N4 [get_ports {dip_sw[1]}]
set_property PACKAGE_PIN P3 [get_ports {dip_sw[2]}]
set_property PACKAGE_PIN P4 [get_ports {dip_sw[3]}]
set_property PACKAGE_PIN R5 [get_ports {dip_sw[4]}]
set_property PACKAGE_PIN T7 [get_ports {dip_sw[5]}]
set_property PACKAGE_PIN R8 [get_ports {dip_sw[6]}]
set_property PACKAGE_PIN T8 [get_ports {dip_sw[7]}]
set_property PACKAGE_PIN N2 [get_ports {dip_sw[8]}]
set_property PACKAGE_PIN N1 [get_ports {dip_sw[9]}]
set_property PACKAGE_PIN P1 [get_ports {dip_sw[10]}]
set_property PACKAGE_PIN R2 [get_ports {dip_sw[11]}]
set_property PACKAGE_PIN R1 [get_ports {dip_sw[12]}]
set_property PACKAGE_PIN T2 [get_ports {dip_sw[13]}]
set_property PACKAGE_PIN U1 [get_ports {dip_sw[14]}]
set_property PACKAGE_PIN U2 [get_ports {dip_sw[15]}]
set_property PACKAGE_PIN U6 [get_ports {dip_sw[16]}]
set_property PACKAGE_PIN R6 [get_ports {dip_sw[17]}]
set_property PACKAGE_PIN U5 [get_ports {dip_sw[18]}]
set_property PACKAGE_PIN T5 [get_ports {dip_sw[19]}]
set_property PACKAGE_PIN U4 [get_ports {dip_sw[20]}]
set_property PACKAGE_PIN T4 [get_ports {dip_sw[21]}]
set_property PACKAGE_PIN T3 [get_ports {dip_sw[22]}]
set_property PACKAGE_PIN R3 [get_ports {dip_sw[23]}]
set_property PACKAGE_PIN P5 [get_ports {dip_sw[24]}]
set_property PACKAGE_PIN P6 [get_ports {dip_sw[25]}]
set_property PACKAGE_PIN P8 [get_ports {dip_sw[26]}]
set_property PACKAGE_PIN N8 [get_ports {dip_sw[27]}]
set_property PACKAGE_PIN N6 [get_ports {dip_sw[28]}]
set_property PACKAGE_PIN N7 [get_ports {dip_sw[29]}]
set_property PACKAGE_PIN M7 [get_ports {dip_sw[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports op]
set_property PACKAGE_PIN M5 [get_ports op]

set_property IOSTANDARD LVCMOS33 [get_ports {flash_addr[*]}]
set_property PACKAGE_PIN K8 [get_ports {flash_addr[0]}]
set_property PACKAGE_PIN C26 [get_ports {flash_addr[1]}]
set_property PACKAGE_PIN B26 [get_ports {flash_addr[2]}]
set_property PACKAGE_PIN B25 [get_ports {flash_addr[3]}]
set_property PACKAGE_PIN A25 [get_ports {flash_addr[4]}]
set_property PACKAGE_PIN D24 [get_ports {flash_addr[5]}]
set_property PACKAGE_PIN C24 [get_ports {flash_addr[6]}]
set_property PACKAGE_PIN B24 [get_ports {flash_addr[7]}]
set_property PACKAGE_PIN A24 [get_ports {flash_addr[8]}]
set_property PACKAGE_PIN C23 [get_ports {flash_addr[9]}]
set_property PACKAGE_PIN D23 [get_ports {flash_addr[10]}]
set_property PACKAGE_PIN A23 [get_ports {flash_addr[11]}]
set_property PACKAGE_PIN C21 [get_ports {flash_addr[12]}]
set_property PACKAGE_PIN B21 [get_ports {flash_addr[13]}]
set_property PACKAGE_PIN E22 [get_ports {flash_addr[14]}]
set_property PACKAGE_PIN E21 [get_ports {flash_addr[15]}]
set_property PACKAGE_PIN E20 [get_ports {flash_addr[16]}]
set_property PACKAGE_PIN D21 [get_ports {flash_addr[17]}]
set_property PACKAGE_PIN B20 [get_ports {flash_addr[18]}]
set_property PACKAGE_PIN D20 [get_ports {flash_addr[19]}]
set_property PACKAGE_PIN B19 [get_ports {flash_addr[20]}]
set_property PACKAGE_PIN C19 [get_ports {flash_addr[21]}]
set_property PACKAGE_PIN A20 [get_ports {flash_addr[22]}]

set_property IOSTANDARD LVCMOS33 [get_ports {flash_data[*]}]
set_property PACKAGE_PIN F8 [get_ports {flash_data[0]}]
set_property PACKAGE_PIN E6 [get_ports {flash_data[1]}]
set_property PACKAGE_PIN B5 [get_ports {flash_data[2]}]
set_property PACKAGE_PIN A4 [get_ports {flash_data[3]}]
set_property PACKAGE_PIN A3 [get_ports {flash_data[4]}]
set_property PACKAGE_PIN B2 [get_ports {flash_data[5]}]
set_property PACKAGE_PIN C2 [get_ports {flash_data[6]}]
set_property PACKAGE_PIN F2 [get_ports {flash_data[7]}]
set_property PACKAGE_PIN F7 [get_ports {flash_data[8]}]
set_property PACKAGE_PIN A5 [get_ports {flash_data[9]}]
set_property PACKAGE_PIN D5 [get_ports {flash_data[10]}]
set_property PACKAGE_PIN B4 [get_ports {flash_data[11]}]
set_property PACKAGE_PIN A2 [get_ports {flash_data[12]}]
set_property PACKAGE_PIN B1 [get_ports {flash_data[13]}]
set_property PACKAGE_PIN G2 [get_ports {flash_data[14]}]
set_property PACKAGE_PIN E1 [get_ports {flash_data[15]}]

set_property IOSTANDARD LVCMOS33 [get_ports flash_byte]
set_property PACKAGE_PIN G9 [get_ports flash_byte]
set_property IOSTANDARD LVCMOS33 [get_ports flash_ce]
set_property PACKAGE_PIN A22 [get_ports flash_ce]
set_property IOSTANDARD LVCMOS33 [get_ports flash_oe]
set_property PACKAGE_PIN D1 [get_ports flash_oe]
set_property IOSTANDARD LVCMOS33 [get_ports flash_rp]
set_property PACKAGE_PIN C22 [get_ports flash_rp]
set_property IOSTANDARD LVCMOS33 [get_ports flash_vpen]
set_property PACKAGE_PIN B22 [get_ports flash_vpen]
set_property IOSTANDARD LVCMOS33 [get_ports flash_we]
set_property PACKAGE_PIN C1 [get_ports flash_we]

set_property IOSTANDARD LVCMOS33 [get_ports {base_ram_addr[*]}]
set_property PACKAGE_PIN F24 [get_ports {base_ram_addr[0]}]
set_property PACKAGE_PIN G24 [get_ports {base_ram_addr[1]}]
set_property PACKAGE_PIN L24 [get_ports {base_ram_addr[2]}]
set_property PACKAGE_PIN L23 [get_ports {base_ram_addr[3]}]
set_property PACKAGE_PIN N16 [get_ports {base_ram_addr[4]}]
set_property PACKAGE_PIN G21 [get_ports {base_ram_addr[5]}]
set_property PACKAGE_PIN K17 [get_ports {base_ram_addr[6]}]
set_property PACKAGE_PIN L17 [get_ports {base_ram_addr[7]}]
set_property PACKAGE_PIN J15 [get_ports {base_ram_addr[8]}]
set_property PACKAGE_PIN H23 [get_ports {base_ram_addr[9]}]
set_property PACKAGE_PIN P14 [get_ports {base_ram_addr[10]}]
set_property PACKAGE_PIN L14 [get_ports {base_ram_addr[11]}]
set_property PACKAGE_PIN L15 [get_ports {base_ram_addr[12]}]
set_property PACKAGE_PIN K15 [get_ports {base_ram_addr[13]}]
set_property PACKAGE_PIN J14 [get_ports {base_ram_addr[14]}]
set_property PACKAGE_PIN M24 [get_ports {base_ram_addr[15]}]
set_property PACKAGE_PIN N17 [get_ports {base_ram_addr[16]}]
set_property PACKAGE_PIN N23 [get_ports {base_ram_addr[17]}]
set_property PACKAGE_PIN N24 [get_ports {base_ram_addr[18]}]
set_property PACKAGE_PIN P23 [get_ports {base_ram_addr[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {base_ram_be_n[*]}]
set_property PACKAGE_PIN M26 [get_ports {base_ram_be_n[0]}]
set_property PACKAGE_PIN L25 [get_ports {base_ram_be_n[1]}]
set_property PACKAGE_PIN D26 [get_ports {base_ram_be_n[2]}]
set_property PACKAGE_PIN D25 [get_ports {base_ram_be_n[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {base_ram_data[*]}]
set_property PACKAGE_PIN M22 [get_ports {base_ram_data[0]}]
set_property PACKAGE_PIN N14 [get_ports {base_ram_data[1]}]
set_property PACKAGE_PIN N22 [get_ports {base_ram_data[2]}]
set_property PACKAGE_PIN R20 [get_ports {base_ram_data[3]}]
set_property PACKAGE_PIN M25 [get_ports {base_ram_data[4]}]
set_property PACKAGE_PIN N26 [get_ports {base_ram_data[5]}]
set_property PACKAGE_PIN P26 [get_ports {base_ram_data[6]}]
set_property PACKAGE_PIN P25 [get_ports {base_ram_data[7]}]
set_property PACKAGE_PIN J23 [get_ports {base_ram_data[8]}]
set_property PACKAGE_PIN J18 [get_ports {base_ram_data[9]}]
set_property PACKAGE_PIN E26 [get_ports {base_ram_data[10]}]
set_property PACKAGE_PIN H21 [get_ports {base_ram_data[11]}]
set_property PACKAGE_PIN H22 [get_ports {base_ram_data[12]}]
set_property PACKAGE_PIN H18 [get_ports {base_ram_data[13]}]
set_property PACKAGE_PIN G22 [get_ports {base_ram_data[14]}]
set_property PACKAGE_PIN J16 [get_ports {base_ram_data[15]}]
set_property PACKAGE_PIN N19 [get_ports {base_ram_data[16]}]
set_property PACKAGE_PIN P18 [get_ports {base_ram_data[17]}]
set_property PACKAGE_PIN P19 [get_ports {base_ram_data[18]}]
set_property PACKAGE_PIN R18 [get_ports {base_ram_data[19]}]
set_property PACKAGE_PIN K20 [get_ports {base_ram_data[20]}]
set_property PACKAGE_PIN M19 [get_ports {base_ram_data[21]}]
set_property PACKAGE_PIN L22 [get_ports {base_ram_data[22]}]
set_property PACKAGE_PIN M21 [get_ports {base_ram_data[23]}]
set_property PACKAGE_PIN K26 [get_ports {base_ram_data[24]}]
set_property PACKAGE_PIN K25 [get_ports {base_ram_data[25]}]
set_property PACKAGE_PIN J26 [get_ports {base_ram_data[26]}]
set_property PACKAGE_PIN J25 [get_ports {base_ram_data[27]}]
set_property PACKAGE_PIN H26 [get_ports {base_ram_data[28]}]
set_property PACKAGE_PIN G26 [get_ports {base_ram_data[29]}]
set_property PACKAGE_PIN G25 [get_ports {base_ram_data[30]}]
set_property PACKAGE_PIN F25 [get_ports {base_ram_data[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports en1]
set_property PACKAGE_PIN K18 [get_ports en1]
set_property IOSTANDARD LVCMOS33 [get_ports oe1]
set_property PACKAGE_PIN K16 [get_ports oe1]
set_property IOSTANDARD LVCMOS33 [get_ports we1]
set_property PACKAGE_PIN P24 [get_ports we1]

set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_addr[*]}]
set_property PACKAGE_PIN Y21 [get_ports {ext_ram_addr[0]}]
set_property PACKAGE_PIN Y26 [get_ports {ext_ram_addr[1]}]
set_property PACKAGE_PIN AA25 [get_ports {ext_ram_addr[2]}]
set_property PACKAGE_PIN Y22 [get_ports {ext_ram_addr[3]}]
set_property PACKAGE_PIN Y23 [get_ports {ext_ram_addr[4]}]
set_property PACKAGE_PIN T18 [get_ports {ext_ram_addr[5]}]
set_property PACKAGE_PIN T23 [get_ports {ext_ram_addr[6]}]
set_property PACKAGE_PIN T24 [get_ports {ext_ram_addr[7]}]
set_property PACKAGE_PIN U19 [get_ports {ext_ram_addr[8]}]
set_property PACKAGE_PIN V24 [get_ports {ext_ram_addr[9]}]
set_property PACKAGE_PIN W26 [get_ports {ext_ram_addr[10]}]
set_property PACKAGE_PIN W24 [get_ports {ext_ram_addr[11]}]
set_property PACKAGE_PIN Y25 [get_ports {ext_ram_addr[12]}]
set_property PACKAGE_PIN W23 [get_ports {ext_ram_addr[13]}]
set_property PACKAGE_PIN W21 [get_ports {ext_ram_addr[14]}]
set_property PACKAGE_PIN V14 [get_ports {ext_ram_addr[15]}]
set_property PACKAGE_PIN U14 [get_ports {ext_ram_addr[16]}]
set_property PACKAGE_PIN T14 [get_ports {ext_ram_addr[17]}]
set_property PACKAGE_PIN U15 [get_ports {ext_ram_addr[18]}]
set_property PACKAGE_PIN T15 [get_ports {ext_ram_addr[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_be_n[*]}]
set_property PACKAGE_PIN U26 [get_ports {ext_ram_be_n[0]}]
set_property PACKAGE_PIN T25 [get_ports {ext_ram_be_n[1]}]
set_property PACKAGE_PIN R17 [get_ports {ext_ram_be_n[2]}]
set_property PACKAGE_PIN R21 [get_ports {ext_ram_be_n[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ext_ram_data[*]}]
set_property PACKAGE_PIN W20 [get_ports {ext_ram_data[0]}]
set_property PACKAGE_PIN W19 [get_ports {ext_ram_data[1]}]
set_property PACKAGE_PIN V19 [get_ports {ext_ram_data[2]}]
set_property PACKAGE_PIN W18 [get_ports {ext_ram_data[3]}]
set_property PACKAGE_PIN V18 [get_ports {ext_ram_data[4]}]
set_property PACKAGE_PIN T17 [get_ports {ext_ram_data[5]}]
set_property PACKAGE_PIN V16 [get_ports {ext_ram_data[6]}]
set_property PACKAGE_PIN V17 [get_ports {ext_ram_data[7]}]
set_property PACKAGE_PIN V22 [get_ports {ext_ram_data[8]}]
set_property PACKAGE_PIN W25 [get_ports {ext_ram_data[9]}]
set_property PACKAGE_PIN V23 [get_ports {ext_ram_data[10]}]
set_property PACKAGE_PIN V21 [get_ports {ext_ram_data[11]}]
set_property PACKAGE_PIN U22 [get_ports {ext_ram_data[12]}]
set_property PACKAGE_PIN V26 [get_ports {ext_ram_data[13]}]
set_property PACKAGE_PIN U21 [get_ports {ext_ram_data[14]}]
set_property PACKAGE_PIN U25 [get_ports {ext_ram_data[15]}]
set_property PACKAGE_PIN AC24 [get_ports {ext_ram_data[16]}]
set_property PACKAGE_PIN AC26 [get_ports {ext_ram_data[17]}]
set_property PACKAGE_PIN AB25 [get_ports {ext_ram_data[18]}]
set_property PACKAGE_PIN AB24 [get_ports {ext_ram_data[19]}]
set_property PACKAGE_PIN AA22 [get_ports {ext_ram_data[20]}]
set_property PACKAGE_PIN AA24 [get_ports {ext_ram_data[21]}]
set_property PACKAGE_PIN AB26 [get_ports {ext_ram_data[22]}]
set_property PACKAGE_PIN AA23 [get_ports {ext_ram_data[23]}]
set_property PACKAGE_PIN R25 [get_ports {ext_ram_data[24]}]
set_property PACKAGE_PIN R23 [get_ports {ext_ram_data[25]}]
set_property PACKAGE_PIN R26 [get_ports {ext_ram_data[26]}]
set_property PACKAGE_PIN U20 [get_ports {ext_ram_data[27]}]
set_property PACKAGE_PIN T22 [get_ports {ext_ram_data[28]}]
set_property PACKAGE_PIN R22 [get_ports {ext_ram_data[29]}]
set_property PACKAGE_PIN T20 [get_ports {ext_ram_data[30]}]
set_property PACKAGE_PIN R14 [get_ports {ext_ram_data[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports en2]
set_property PACKAGE_PIN Y20 [get_ports en2]
set_property IOSTANDARD LVCMOS33 [get_ports oe2]
set_property PACKAGE_PIN U24 [get_ports oe2]
set_property IOSTANDARD LVCMOS33 [get_ports we2]
set_property PACKAGE_PIN U16 [get_ports we2]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]



