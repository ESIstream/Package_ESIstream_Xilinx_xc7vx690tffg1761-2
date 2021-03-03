###############################################################################
# User Configuration
###############################################################################

###############################################################################
# IOs constraints
###############################################################################

# 156.25 MHz
create_clock -period 6.400 -name clk_mgtref -waveform {0.000 3.200} [get_ports sso_p]
set_property PACKAGE_PIN G10 [get_ports sso_p]
set_property PACKAGE_PIN G9 [get_ports sso_n]


set_property PACKAGE_PIN H7 [get_ports {rxn[0]}]
set_property PACKAGE_PIN H8 [get_ports {rxp[0]}]
set_property PACKAGE_PIN J1 [get_ports {txn[0]}]
set_property PACKAGE_PIN J2 [get_ports {txp[0]}]
set_property PACKAGE_PIN G5 [get_ports {rxn[1]}]
set_property PACKAGE_PIN G6 [get_ports {rxp[1]}]
set_property PACKAGE_PIN H3 [get_ports {txn[1]}]
set_property PACKAGE_PIN H4 [get_ports {txp[1]}]
set_property PACKAGE_PIN F7 [get_ports {rxn[2]}]
set_property PACKAGE_PIN F8 [get_ports {rxp[2]}]
set_property PACKAGE_PIN G1 [get_ports {txn[2]}]
set_property PACKAGE_PIN G2 [get_ports {txp[2]}]
set_property PACKAGE_PIN E5 [get_ports {rxn[3]}]
set_property PACKAGE_PIN E6 [get_ports {rxp[3]}]
set_property PACKAGE_PIN F3 [get_ports {txn[3]}]
set_property PACKAGE_PIN F4 [get_ports {txp[3]}]
set_property PACKAGE_PIN D7 [get_ports {rxn[4]}]
set_property PACKAGE_PIN D8 [get_ports {rxp[4]}]
set_property PACKAGE_PIN E1 [get_ports {txn[4]}]
set_property PACKAGE_PIN E2 [get_ports {txp[4]}]
set_property PACKAGE_PIN C5 [get_ports {rxn[5]}]
set_property PACKAGE_PIN C6 [get_ports {rxp[5]}]
set_property PACKAGE_PIN D3 [get_ports {txn[5]}]
set_property PACKAGE_PIN D4 [get_ports {txp[5]}]
set_property PACKAGE_PIN B7 [get_ports {rxn[6]}]
set_property PACKAGE_PIN B8 [get_ports {rxp[6]}]
set_property PACKAGE_PIN C1 [get_ports {txn[6]}]
set_property PACKAGE_PIN C2 [get_ports {txp[6]}]
set_property PACKAGE_PIN A5 [get_ports {rxn[7]}]
set_property PACKAGE_PIN A6 [get_ports {rxp[7]}]
set_property PACKAGE_PIN B3 [get_ports {txn[7]}]
set_property PACKAGE_PIN B4 [get_ports {txp[7]}]

# PL system clock:
set_property PACKAGE_PIN H19 [get_ports SYSCLK_P]
set_property PACKAGE_PIN G18 [get_ports SYSCLK_N]
set_property IOSTANDARD DIFF_SSTL15_DCI [get_ports SYSCLK_P]
set_property IOSTANDARD DIFF_SSTL15_DCI [get_ports SYSCLK_N]

create_clock -period 5.000 -name SYSCLK_P [get_ports SYSCLK_P]

set_property IOSTANDARD LVCMOS18 [get_ports {GPIO_LED[*]}]
set_property PACKAGE_PIN AM39 [get_ports {GPIO_LED[0]}]
set_property PACKAGE_PIN AN39 [get_ports {GPIO_LED[1]}]
set_property PACKAGE_PIN AR37 [get_ports {GPIO_LED[2]}]
set_property PACKAGE_PIN AT37 [get_ports {GPIO_LED[3]}]
set_property PACKAGE_PIN AR35 [get_ports {GPIO_LED[4]}]
set_property PACKAGE_PIN AP41 [get_ports {GPIO_LED[5]}]
set_property PACKAGE_PIN AP42 [get_ports {GPIO_LED[6]}]
set_property PACKAGE_PIN AU39 [get_ports {GPIO_LED[7]}]

set_property IOSTANDARD LVCMOS18 [get_ports UART_RX]
set_property IOSTANDARD LVCMOS18 [get_ports UART_TX]
set_property PACKAGE_PIN AU36 [get_ports UART_RX]
set_property PACKAGE_PIN AU33 [get_ports UART_TX]
#set_property PACKAGE_PIN AT32 [get_ports UART_RTS]
#set_property PACKAGE_PIN AR34 [get_ports UART_CTS]

set_property IOSTANDARD LVCMOS18 [get_ports {GPIO_DIP_SW[*]}]
set_property PACKAGE_PIN AV30 [get_ports {GPIO_DIP_SW[0]}]
set_property PACKAGE_PIN AY33 [get_ports {GPIO_DIP_SW[1]}]
set_property PACKAGE_PIN BA31 [get_ports {GPIO_DIP_SW[2]}]
set_property PACKAGE_PIN BA32 [get_ports {GPIO_DIP_SW[3]}]
#set_property PACKAGE_PIN AW30 [get_ports {GPIO_DIP_SW[4]}]
#set_property PACKAGE_PIN AY30 [get_ports {GPIO_DIP_SW[5]}]
#set_property PACKAGE_PIN BA30 [get_ports {GPIO_DIP_SW[6]}]
#set_property PACKAGE_PIN BB31 [get_ports {GPIO_DIP_SW[7]}]

set_property IOSTANDARD LVCMOS18 [get_ports GPIO_SW_N]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_SW_S]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_SW_C]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_SW_W]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_SW_E]
set_property PACKAGE_PIN AR40 [get_ports GPIO_SW_N]
set_property PACKAGE_PIN AP40 [get_ports GPIO_SW_S]
set_property PACKAGE_PIN AV39 [get_ports GPIO_SW_C]
set_property PACKAGE_PIN AW40 [get_ports GPIO_SW_W]
set_property PACKAGE_PIN AU38 [get_ports GPIO_SW_E]

set_false_path -from [get_clocks clk_mgtref] -to [get_clocks clk_out1_clk_wiz_0]
set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks clk_mgtref]
# RX
set_false_path -from [get_clocks clkout0] -to [get_clocks clk_out1_clk_wiz_0]
set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks clkout0]
# TX
set_false_path -from [get_clocks clkout0_1] -to [get_clocks clk_out1_clk_wiz_0]
set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks clkout0_1]
# ILA
set_false_path -from [get_clocks clkout0_1] -to [get_clocks clkout0]
set_false_path -from [get_clocks clkout0] -to [get_clocks clkout0_1]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 4 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/gth_txrx_8lanes_64b_1/U0/gt_usrclk_source/rxoutclk_mmcm1_i/GT0_RXUSRCLK2_OUT]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 12 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {data_out_12b[2][0][0]} {data_out_12b[2][0][1]} {data_out_12b[2][0][2]} {data_out_12b[2][0][3]} {data_out_12b[2][0][4]} {data_out_12b[2][0][5]} {data_out_12b[2][0][6]} {data_out_12b[2][0][7]} {data_out_12b[2][0][8]} {data_out_12b[2][0][9]} {data_out_12b[2][0][10]} {data_out_12b[2][0][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 12 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {data_out_12b[4][2][0]} {data_out_12b[4][2][1]} {data_out_12b[4][2][2]} {data_out_12b[4][2][3]} {data_out_12b[4][2][4]} {data_out_12b[4][2][5]} {data_out_12b[4][2][6]} {data_out_12b[4][2][7]} {data_out_12b[4][2][8]} {data_out_12b[4][2][9]} {data_out_12b[4][2][10]} {data_out_12b[4][2][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 12 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {data_out_12b[2][1][0]} {data_out_12b[2][1][1]} {data_out_12b[2][1][2]} {data_out_12b[2][1][3]} {data_out_12b[2][1][4]} {data_out_12b[2][1][5]} {data_out_12b[2][1][6]} {data_out_12b[2][1][7]} {data_out_12b[2][1][8]} {data_out_12b[2][1][9]} {data_out_12b[2][1][10]} {data_out_12b[2][1][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 12 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {data_out_12b[7][2][0]} {data_out_12b[7][2][1]} {data_out_12b[7][2][2]} {data_out_12b[7][2][3]} {data_out_12b[7][2][4]} {data_out_12b[7][2][5]} {data_out_12b[7][2][6]} {data_out_12b[7][2][7]} {data_out_12b[7][2][8]} {data_out_12b[7][2][9]} {data_out_12b[7][2][10]} {data_out_12b[7][2][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 12 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {data_out_12b[5][3][0]} {data_out_12b[5][3][1]} {data_out_12b[5][3][2]} {data_out_12b[5][3][3]} {data_out_12b[5][3][4]} {data_out_12b[5][3][5]} {data_out_12b[5][3][6]} {data_out_12b[5][3][7]} {data_out_12b[5][3][8]} {data_out_12b[5][3][9]} {data_out_12b[5][3][10]} {data_out_12b[5][3][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 12 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {data_out_12b[4][3][0]} {data_out_12b[4][3][1]} {data_out_12b[4][3][2]} {data_out_12b[4][3][3]} {data_out_12b[4][3][4]} {data_out_12b[4][3][5]} {data_out_12b[4][3][6]} {data_out_12b[4][3][7]} {data_out_12b[4][3][8]} {data_out_12b[4][3][9]} {data_out_12b[4][3][10]} {data_out_12b[4][3][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 12 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {data_out_12b[2][3][0]} {data_out_12b[2][3][1]} {data_out_12b[2][3][2]} {data_out_12b[2][3][3]} {data_out_12b[2][3][4]} {data_out_12b[2][3][5]} {data_out_12b[2][3][6]} {data_out_12b[2][3][7]} {data_out_12b[2][3][8]} {data_out_12b[2][3][9]} {data_out_12b[2][3][10]} {data_out_12b[2][3][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 12 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {data_out_12b[5][1][0]} {data_out_12b[5][1][1]} {data_out_12b[5][1][2]} {data_out_12b[5][1][3]} {data_out_12b[5][1][4]} {data_out_12b[5][1][5]} {data_out_12b[5][1][6]} {data_out_12b[5][1][7]} {data_out_12b[5][1][8]} {data_out_12b[5][1][9]} {data_out_12b[5][1][10]} {data_out_12b[5][1][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 12 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {data_out_12b[2][2][0]} {data_out_12b[2][2][1]} {data_out_12b[2][2][2]} {data_out_12b[2][2][3]} {data_out_12b[2][2][4]} {data_out_12b[2][2][5]} {data_out_12b[2][2][6]} {data_out_12b[2][2][7]} {data_out_12b[2][2][8]} {data_out_12b[2][2][9]} {data_out_12b[2][2][10]} {data_out_12b[2][2][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 12 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {data_out_12b[0][0][0]} {data_out_12b[0][0][1]} {data_out_12b[0][0][2]} {data_out_12b[0][0][3]} {data_out_12b[0][0][4]} {data_out_12b[0][0][5]} {data_out_12b[0][0][6]} {data_out_12b[0][0][7]} {data_out_12b[0][0][8]} {data_out_12b[0][0][9]} {data_out_12b[0][0][10]} {data_out_12b[0][0][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 12 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {data_out_12b[3][0][0]} {data_out_12b[3][0][1]} {data_out_12b[3][0][2]} {data_out_12b[3][0][3]} {data_out_12b[3][0][4]} {data_out_12b[3][0][5]} {data_out_12b[3][0][6]} {data_out_12b[3][0][7]} {data_out_12b[3][0][8]} {data_out_12b[3][0][9]} {data_out_12b[3][0][10]} {data_out_12b[3][0][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 12 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {data_out_12b[6][1][0]} {data_out_12b[6][1][1]} {data_out_12b[6][1][2]} {data_out_12b[6][1][3]} {data_out_12b[6][1][4]} {data_out_12b[6][1][5]} {data_out_12b[6][1][6]} {data_out_12b[6][1][7]} {data_out_12b[6][1][8]} {data_out_12b[6][1][9]} {data_out_12b[6][1][10]} {data_out_12b[6][1][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 12 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {data_out_12b[6][3][0]} {data_out_12b[6][3][1]} {data_out_12b[6][3][2]} {data_out_12b[6][3][3]} {data_out_12b[6][3][4]} {data_out_12b[6][3][5]} {data_out_12b[6][3][6]} {data_out_12b[6][3][7]} {data_out_12b[6][3][8]} {data_out_12b[6][3][9]} {data_out_12b[6][3][10]} {data_out_12b[6][3][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 12 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {data_out_12b[7][3][0]} {data_out_12b[7][3][1]} {data_out_12b[7][3][2]} {data_out_12b[7][3][3]} {data_out_12b[7][3][4]} {data_out_12b[7][3][5]} {data_out_12b[7][3][6]} {data_out_12b[7][3][7]} {data_out_12b[7][3][8]} {data_out_12b[7][3][9]} {data_out_12b[7][3][10]} {data_out_12b[7][3][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 12 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {data_out_12b[3][1][0]} {data_out_12b[3][1][1]} {data_out_12b[3][1][2]} {data_out_12b[3][1][3]} {data_out_12b[3][1][4]} {data_out_12b[3][1][5]} {data_out_12b[3][1][6]} {data_out_12b[3][1][7]} {data_out_12b[3][1][8]} {data_out_12b[3][1][9]} {data_out_12b[3][1][10]} {data_out_12b[3][1][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 12 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {data_out_12b[7][0][0]} {data_out_12b[7][0][1]} {data_out_12b[7][0][2]} {data_out_12b[7][0][3]} {data_out_12b[7][0][4]} {data_out_12b[7][0][5]} {data_out_12b[7][0][6]} {data_out_12b[7][0][7]} {data_out_12b[7][0][8]} {data_out_12b[7][0][9]} {data_out_12b[7][0][10]} {data_out_12b[7][0][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 12 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {data_out_12b[1][3][0]} {data_out_12b[1][3][1]} {data_out_12b[1][3][2]} {data_out_12b[1][3][3]} {data_out_12b[1][3][4]} {data_out_12b[1][3][5]} {data_out_12b[1][3][6]} {data_out_12b[1][3][7]} {data_out_12b[1][3][8]} {data_out_12b[1][3][9]} {data_out_12b[1][3][10]} {data_out_12b[1][3][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 12 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {data_out_12b[1][1][0]} {data_out_12b[1][1][1]} {data_out_12b[1][1][2]} {data_out_12b[1][1][3]} {data_out_12b[1][1][4]} {data_out_12b[1][1][5]} {data_out_12b[1][1][6]} {data_out_12b[1][1][7]} {data_out_12b[1][1][8]} {data_out_12b[1][1][9]} {data_out_12b[1][1][10]} {data_out_12b[1][1][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 12 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {data_out_12b[1][0][0]} {data_out_12b[1][0][1]} {data_out_12b[1][0][2]} {data_out_12b[1][0][3]} {data_out_12b[1][0][4]} {data_out_12b[1][0][5]} {data_out_12b[1][0][6]} {data_out_12b[1][0][7]} {data_out_12b[1][0][8]} {data_out_12b[1][0][9]} {data_out_12b[1][0][10]} {data_out_12b[1][0][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 12 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {data_out_12b[6][2][0]} {data_out_12b[6][2][1]} {data_out_12b[6][2][2]} {data_out_12b[6][2][3]} {data_out_12b[6][2][4]} {data_out_12b[6][2][5]} {data_out_12b[6][2][6]} {data_out_12b[6][2][7]} {data_out_12b[6][2][8]} {data_out_12b[6][2][9]} {data_out_12b[6][2][10]} {data_out_12b[6][2][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 12 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {data_out_12b[0][1][0]} {data_out_12b[0][1][1]} {data_out_12b[0][1][2]} {data_out_12b[0][1][3]} {data_out_12b[0][1][4]} {data_out_12b[0][1][5]} {data_out_12b[0][1][6]} {data_out_12b[0][1][7]} {data_out_12b[0][1][8]} {data_out_12b[0][1][9]} {data_out_12b[0][1][10]} {data_out_12b[0][1][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 12 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {data_out_12b[0][2][0]} {data_out_12b[0][2][1]} {data_out_12b[0][2][2]} {data_out_12b[0][2][3]} {data_out_12b[0][2][4]} {data_out_12b[0][2][5]} {data_out_12b[0][2][6]} {data_out_12b[0][2][7]} {data_out_12b[0][2][8]} {data_out_12b[0][2][9]} {data_out_12b[0][2][10]} {data_out_12b[0][2][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 12 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {data_out_12b[1][2][0]} {data_out_12b[1][2][1]} {data_out_12b[1][2][2]} {data_out_12b[1][2][3]} {data_out_12b[1][2][4]} {data_out_12b[1][2][5]} {data_out_12b[1][2][6]} {data_out_12b[1][2][7]} {data_out_12b[1][2][8]} {data_out_12b[1][2][9]} {data_out_12b[1][2][10]} {data_out_12b[1][2][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 12 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {data_out_12b[3][3][0]} {data_out_12b[3][3][1]} {data_out_12b[3][3][2]} {data_out_12b[3][3][3]} {data_out_12b[3][3][4]} {data_out_12b[3][3][5]} {data_out_12b[3][3][6]} {data_out_12b[3][3][7]} {data_out_12b[3][3][8]} {data_out_12b[3][3][9]} {data_out_12b[3][3][10]} {data_out_12b[3][3][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 12 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {data_out_12b[0][3][0]} {data_out_12b[0][3][1]} {data_out_12b[0][3][2]} {data_out_12b[0][3][3]} {data_out_12b[0][3][4]} {data_out_12b[0][3][5]} {data_out_12b[0][3][6]} {data_out_12b[0][3][7]} {data_out_12b[0][3][8]} {data_out_12b[0][3][9]} {data_out_12b[0][3][10]} {data_out_12b[0][3][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 12 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {data_out_12b[3][2][0]} {data_out_12b[3][2][1]} {data_out_12b[3][2][2]} {data_out_12b[3][2][3]} {data_out_12b[3][2][4]} {data_out_12b[3][2][5]} {data_out_12b[3][2][6]} {data_out_12b[3][2][7]} {data_out_12b[3][2][8]} {data_out_12b[3][2][9]} {data_out_12b[3][2][10]} {data_out_12b[3][2][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 12 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {data_out_12b[5][0][0]} {data_out_12b[5][0][1]} {data_out_12b[5][0][2]} {data_out_12b[5][0][3]} {data_out_12b[5][0][4]} {data_out_12b[5][0][5]} {data_out_12b[5][0][6]} {data_out_12b[5][0][7]} {data_out_12b[5][0][8]} {data_out_12b[5][0][9]} {data_out_12b[5][0][10]} {data_out_12b[5][0][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 12 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {data_out_12b[7][1][0]} {data_out_12b[7][1][1]} {data_out_12b[7][1][2]} {data_out_12b[7][1][3]} {data_out_12b[7][1][4]} {data_out_12b[7][1][5]} {data_out_12b[7][1][6]} {data_out_12b[7][1][7]} {data_out_12b[7][1][8]} {data_out_12b[7][1][9]} {data_out_12b[7][1][10]} {data_out_12b[7][1][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 12 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {data_out_12b[4][1][0]} {data_out_12b[4][1][1]} {data_out_12b[4][1][2]} {data_out_12b[4][1][3]} {data_out_12b[4][1][4]} {data_out_12b[4][1][5]} {data_out_12b[4][1][6]} {data_out_12b[4][1][7]} {data_out_12b[4][1][8]} {data_out_12b[4][1][9]} {data_out_12b[4][1][10]} {data_out_12b[4][1][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 12 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {data_out_12b[6][0][0]} {data_out_12b[6][0][1]} {data_out_12b[6][0][2]} {data_out_12b[6][0][3]} {data_out_12b[6][0][4]} {data_out_12b[6][0][5]} {data_out_12b[6][0][6]} {data_out_12b[6][0][7]} {data_out_12b[6][0][8]} {data_out_12b[6][0][9]} {data_out_12b[6][0][10]} {data_out_12b[6][0][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 12 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {data_out_12b[4][0][0]} {data_out_12b[4][0][1]} {data_out_12b[4][0][2]} {data_out_12b[4][0][3]} {data_out_12b[4][0][4]} {data_out_12b[4][0][5]} {data_out_12b[4][0][6]} {data_out_12b[4][0][7]} {data_out_12b[4][0][8]} {data_out_12b[4][0][9]} {data_out_12b[4][0][10]} {data_out_12b[4][0][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 12 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {data_out_12b[5][2][0]} {data_out_12b[5][2][1]} {data_out_12b[5][2][2]} {data_out_12b[5][2][3]} {data_out_12b[5][2][4]} {data_out_12b[5][2][5]} {data_out_12b[5][2][6]} {data_out_12b[5][2][7]} {data_out_12b[5][2][8]} {data_out_12b[5][2][9]} {data_out_12b[5][2][10]} {data_out_12b[5][2][11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 8 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {valid_out[0]} {valid_out[1]} {valid_out[2]} {valid_out[3]} {valid_out[4]} {valid_out[5]} {valid_out[6]} {valid_out[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list be_status]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list cb_status]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list rx_lanes_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list rx_sync_in]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 4 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list gen_esistream_hdl.tx_rx_esistream_with_xcvr_1/tx_rx_xcvr_wrapper_1/gth_txrx_8lanes_64b_1/U0/gt_usrclk_source/rxoutclk_mmcm1_i/GT7_RXUSRCLK_OUT]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 1 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list rx_ip_ready]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_1_GT7_RXUSRCLK_OUT]
