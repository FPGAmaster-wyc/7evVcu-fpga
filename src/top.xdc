#****************************************RS422****************************************#
##dp A89
set_property -dict {PACKAGE_PIN L10 IOSTANDARD LVCMOS18} [get_ports UART_0_0_txd]
#set_property -dict {PACKAGE_PIN F31 IOSTANDARD LVCMOS18} [get_ports UART_0_0_txd]
##dp A70
set_property -dict {PACKAGE_PIN M10 IOSTANDARD LVCMOS18} [get_ports UART_0_0_rxd]
#set_property -dict {PACKAGE_PIN F32 IOSTANDARD LVCMOS18} [get_ports UART_0_0_rxd]

#50M
set_property PACKAGE_PIN L8 [get_ports GCLK]
set_property IOSTANDARD LVCMOS18 [get_ports GCLK]
create_clock -period 20.000 -name GCLK [get_ports GCLK]

set_property PACKAGE_PIN T8 [get_ports MGT117_P]
create_clock -period 6.400 -name MGT117_P [get_nets MGT117_P]

set_property PACKAGE_PIN N2 [get_ports {QSFP1_RX_P[0]}]
set_property PACKAGE_PIN L2 [get_ports {QSFP1_RX_P[1]}]
set_property PACKAGE_PIN J2 [get_ports {QSFP1_RX_P[2]}]
set_property PACKAGE_PIN G2 [get_ports {QSFP1_RX_P[3]}]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets GCLK_IBUF_inst/O]

#LED1
set_property PACKAGE_PIN J7 [get_ports led]
set_property IOSTANDARD LVCMOS18 [get_ports led]

##########################################################################
#paru pda   lvds_p1
set_property -dict {PACKAGE_PIN J25 IOSTANDARD LVDS} [get_ports {lvds_p1[0]}]
set_property -dict {PACKAGE_PIN J24 IOSTANDARD LVDS} [get_ports {lvds_p1[1]}]
set_property -dict {PACKAGE_PIN G25 IOSTANDARD LVDS} [get_ports {lvds_p1[2]}]
set_property -dict {PACKAGE_PIN L23 IOSTANDARD LVDS} [get_ports {lvds_p1[3]}]
set_property -dict {PACKAGE_PIN E24 IOSTANDARD LVDS} [get_ports {lvds_p1[4]}]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVDS} [get_ports {lvds_p1[5]}]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVDS} [get_ports {lvds_p1[6]}]
set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVDS} [get_ports {lvds_p1[7]}]
set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVDS} [get_ports {lvds_p1[8]}]
set_property -dict {PACKAGE_PIN C21 IOSTANDARD LVDS} [get_ports {lvds_p1[9]}]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVDS} [get_ports {lvds_p1[10]}]
set_property -dict {PACKAGE_PIN K22 IOSTANDARD LVDS} [get_ports {lvds_p1[11]}]
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVDS} [get_ports {lvds_p1[12]}]
set_property -dict {PACKAGE_PIN H21 IOSTANDARD LVDS} [get_ports {lvds_p1[13]}]
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVDS} [get_ports {lvds_p1[14]}]
set_property -dict {PACKAGE_PIN A22 IOSTANDARD LVDS} [get_ports {lvds_p1[15]}]
set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVDS} [get_ports {lvds_p1[16]}]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVDS} [get_ports {lvds_p1[17]}]
set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVDS} [get_ports {lvds_p1[18]}]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVDS} [get_ports {lvds_p1[19]}]

#PARU_FRAMP_0
set_property -dict {PACKAGE_PIN F23 IOSTANDARD LVDS} [get_ports {lvds_p1[20]}]

#PARU_CLKP_0
set_property -dict {PACKAGE_PIN F22 IOSTANDARD LVDS} [get_ports clk_p11]

#set_property -dict {PACKAGE_PIN AP14 IOSTANDARD LVDS} [get_ports {PARU_FRAMP_0}]
#set_property -dict {PACKAGE_PIN AN16 IOSTANDARD LVDS} [get_ports {PARU_FRAMP_1}]

#set_property -dict {PACKAGE_PIN AP15 IOSTANDARD LVDS} [get_ports {clk_p11}]



##########################################################################
#PALU PDA   lvds_p2
set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVDS} [get_ports {lvds_p2[0]}]
set_property -dict {PACKAGE_PIN AC18 IOSTANDARD LVDS} [get_ports {lvds_p2[1]}]
set_property -dict {PACKAGE_PIN AE18 IOSTANDARD LVDS} [get_ports {lvds_p2[2]}]
set_property -dict {PACKAGE_PIN AG19 IOSTANDARD LVDS} [get_ports {lvds_p2[3]}]
set_property -dict {PACKAGE_PIN AJ19 IOSTANDARD LVDS} [get_ports {lvds_p2[4]}]
set_property -dict {PACKAGE_PIN AM21 IOSTANDARD LVDS} [get_ports {lvds_p2[5]}]
set_property -dict {PACKAGE_PIN AP21 IOSTANDARD LVDS} [get_ports {lvds_p2[6]}]
set_property -dict {PACKAGE_PIN AN22 IOSTANDARD LVDS} [get_ports {lvds_p2[7]}]
set_property -dict {PACKAGE_PIN AM23 IOSTANDARD LVDS} [get_ports {lvds_p2[8]}]
set_property -dict {PACKAGE_PIN AL22 IOSTANDARD LVDS} [get_ports {lvds_p2[9]}]
set_property -dict {PACKAGE_PIN AA19 IOSTANDARD LVDS} [get_ports {lvds_p2[10]}]
set_property -dict {PACKAGE_PIN AB19 IOSTANDARD LVDS} [get_ports {lvds_p2[11]}]
set_property -dict {PACKAGE_PIN AM19 IOSTANDARD LVDS} [get_ports {lvds_p2[12]}]
set_property -dict {PACKAGE_PIN AP19 IOSTANDARD LVDS} [get_ports {lvds_p2[13]}]
set_property -dict {PACKAGE_PIN AL20 IOSTANDARD LVDS} [get_ports {lvds_p2[14]}]
set_property -dict {PACKAGE_PIN AK22 IOSTANDARD LVDS} [get_ports {lvds_p2[15]}]
set_property -dict {PACKAGE_PIN AF21 IOSTANDARD LVDS} [get_ports {lvds_p2[16]}]
set_property -dict {PACKAGE_PIN AE23 IOSTANDARD LVDS} [get_ports {lvds_p2[17]}]
set_property -dict {PACKAGE_PIN AF23 IOSTANDARD LVDS} [get_ports {lvds_p2[18]}]
set_property -dict {PACKAGE_PIN AD20 IOSTANDARD LVDS} [get_ports {lvds_p2[19]}]

#PALU_FRAMP_0
set_property -dict {PACKAGE_PIN AJ20 IOSTANDARD LVDS} [get_ports {lvds_p2[20]}]

#PALU_CLKP-0
set_property -dict {PACKAGE_PIN AJ21 IOSTANDARD LVDS} [get_ports clk_p21]

#set_property -dict {PACKAGE_PIN AP20 IOSTANDARD LVDS} [get_ports {PALU_FRAMP_0}]
#set_property -dict {PACKAGE_PIN AN17 IOSTANDARD LVDS} [get_ports {PALU_FRAMP_1}]

#set_property -dict {PACKAGE_PIN AP19 IOSTANDARD LVDS} [get_ports {clk_p21}]



##########################################################################
#PAR        lvds_p3
set_property -dict {PACKAGE_PIN AP10 IOSTANDARD LVDS} [get_ports {lvds_p3[0]}]
set_property -dict {PACKAGE_PIN AN9 IOSTANDARD LVDS} [get_ports {lvds_p3[1]}]
set_property -dict {PACKAGE_PIN AM9 IOSTANDARD LVDS} [get_ports {lvds_p3[2]}]
set_property -dict {PACKAGE_PIN AL11 IOSTANDARD LVDS} [get_ports {lvds_p3[3]}]
set_property -dict {PACKAGE_PIN AK8 IOSTANDARD LVDS} [get_ports {lvds_p3[4]}]
set_property -dict {PACKAGE_PIN AG9 IOSTANDARD LVDS} [get_ports {lvds_p3[5]}]
set_property -dict {PACKAGE_PIN AF8 IOSTANDARD LVDS} [get_ports {lvds_p3[6]}]
set_property -dict {PACKAGE_PIN AF11 IOSTANDARD LVDS} [get_ports {lvds_p3[7]}]
set_property -dict {PACKAGE_PIN AE12 IOSTANDARD LVDS} [get_ports {lvds_p3[8]}]
set_property -dict {PACKAGE_PIN AC12 IOSTANDARD LVDS} [get_ports {lvds_p3[9]}]
set_property -dict {PACKAGE_PIN AK13 IOSTANDARD LVDS} [get_ports {lvds_p3[10]}]
set_property -dict {PACKAGE_PIN AK12 IOSTANDARD LVDS} [get_ports {lvds_p3[11]}]
set_property -dict {PACKAGE_PIN AN12 IOSTANDARD LVDS} [get_ports {lvds_p3[12]}]
set_property -dict {PACKAGE_PIN AN11 IOSTANDARD LVDS} [get_ports {lvds_p3[13]}]
set_property -dict {PACKAGE_PIN AM11 IOSTANDARD LVDS} [get_ports {lvds_p3[14]}]
set_property -dict {PACKAGE_PIN AG11 IOSTANDARD LVDS} [get_ports {lvds_p3[15]}]
set_property -dict {PACKAGE_PIN AG13 IOSTANDARD LVDS} [get_ports {lvds_p3[16]}]
set_property -dict {PACKAGE_PIN AE13 IOSTANDARD LVDS} [get_ports {lvds_p3[17]}]
set_property -dict {PACKAGE_PIN AD14 IOSTANDARD LVDS} [get_ports {lvds_p3[18]}]
set_property -dict {PACKAGE_PIN AB13 IOSTANDARD LVDS} [get_ports {lvds_p3[19]}]

#PAR_FRAMP_0
set_property -dict {PACKAGE_PIN AJ9 IOSTANDARD LVDS} [get_ports {lvds_p3[20]}]

#PAR_CLKP-0
set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVDS} [get_ports clk_p31]

#set_property -dict {PACKAGE_PIN AT8 IOSTANDARD LVDS} [get_ports {PAR_FRAMP_0}]
#set_property -dict {PACKAGE_PIN AT6 IOSTANDARD LVDS} [get_ports {PAR_FRAMP_1}]

#set_property -dict {PACKAGE_PIN AU6 IOSTANDARD LVDS} [get_ports {PAR_CLKP_1}]

##########################################################################
#PAL        lvds_p4
set_property -dict {PACKAGE_PIN AK18 IOSTANDARD LVDS} [get_ports {lvds_p4[0]}]
set_property -dict {PACKAGE_PIN AM18 IOSTANDARD LVDS} [get_ports {lvds_p4[1]}]
set_property -dict {PACKAGE_PIN AP18 IOSTANDARD LVDS} [get_ports {lvds_p4[2]}]
set_property -dict {PACKAGE_PIN AE17 IOSTANDARD LVDS} [get_ports {lvds_p4[3]}]
set_property -dict {PACKAGE_PIN AN17 IOSTANDARD LVDS} [get_ports {lvds_p4[4]}]
set_property -dict {PACKAGE_PIN AN13 IOSTANDARD LVDS} [get_ports {lvds_p4[5]}]
set_property -dict {PACKAGE_PIN AM14 IOSTANDARD LVDS} [get_ports {lvds_p4[6]}]
set_property -dict {PACKAGE_PIN AH14 IOSTANDARD LVDS} [get_ports {lvds_p4[7]}]
set_property -dict {PACKAGE_PIN AG15 IOSTANDARD LVDS} [get_ports {lvds_p4[8]}]
set_property -dict {PACKAGE_PIN AA14 IOSTANDARD LVDS} [get_ports {lvds_p4[9]}]
set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVDS} [get_ports {lvds_p4[10]}]
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVDS} [get_ports {lvds_p4[11]}]
set_property -dict {PACKAGE_PIN AC17 IOSTANDARD LVDS} [get_ports {lvds_p4[12]}]
set_property -dict {PACKAGE_PIN AD17 IOSTANDARD LVDS} [get_ports {lvds_p4[13]}]
set_property -dict {PACKAGE_PIN AD15 IOSTANDARD LVDS} [get_ports {lvds_p4[14]}]
set_property -dict {PACKAGE_PIN AF16 IOSTANDARD LVDS} [get_ports {lvds_p4[15]}]
set_property -dict {PACKAGE_PIN AP16 IOSTANDARD LVDS} [get_ports {lvds_p4[16]}]
set_property -dict {PACKAGE_PIN AM16 IOSTANDARD LVDS} [get_ports {lvds_p4[17]}]
set_property -dict {PACKAGE_PIN AL16 IOSTANDARD LVDS} [get_ports {lvds_p4[18]}]
set_property -dict {PACKAGE_PIN AK15 IOSTANDARD LVDS} [get_ports {lvds_p4[19]}]

#PAL_FRAMP_0
set_property -dict {PACKAGE_PIN AJ17 IOSTANDARD LVDS} [get_ports {lvds_p4[20]}]

#PAL_CLKP-0
set_property -dict {PACKAGE_PIN AJ16 IOSTANDARD LVDS} [get_ports clk_p41]

#set_property -dict {PACKAGE_PIN AN22 IOSTANDARD LVDS} [get_ports {PAL_FRAMP_0}]
#set_property -dict {PACKAGE_PIN AP25 IOSTANDARD LVDS} [get_ports {PAL_FRAMP_1}]

#set_property -dict {PACKAGE_PIN AP24 IOSTANDARD LVDS} [get_ports {PAL_CLKP_1}]


set_property IOSTANDARD LVDS [get_ports lvds_p*]
set_property IOSTANDARD LVDS [get_ports clk_p*]

##########################################################################
#spi
#paru
set_property PACKAGE_PIN A5 [get_ports cs1]

#PALU
set_property PACKAGE_PIN B5 [get_ports cs2]

#PAR
set_property PACKAGE_PIN D6 [get_ports cs3]

#PAL
set_property PACKAGE_PIN D5 [get_ports cs4]

set_property IOSTANDARD LVCMOS33 [get_ports cs*]

#J26
set_property PACKAGE_PIN C4 [get_ports clk_spi]
set_property IOSTANDARD LVCMOS33 [get_ports clk_spi]

set_property PACKAGE_PIN D4 [get_ports mosi]
set_property IOSTANDARD LVCMOS33 [get_ports mosi]

set_property PACKAGE_PIN F4 [get_ports PDLU_EN]
set_property IOSTANDARD LVCMOS33 [get_ports PDLU_EN]

set_property PACKAGE_PIN B4 [get_ports PDLU_pixel_RSTN]
set_property IOSTANDARD LVCMOS33 [get_ports PDLU_pixel_RSTN]

set_property PACKAGE_PIN F5 [get_ports PDLU_RSTN]
set_property IOSTANDARD LVCMOS33 [get_ports PDLU_RSTN]

set_property PACKAGE_PIN E4 [get_ports PDRU_Mclk_20M]
set_property IOSTANDARD LVCMOS33 [get_ports PDRU_Mclk_20M]

####################################################################################
# Constraints from file : 'xpm_cdc_gray.tcl'
####################################################################################
create_clock -period 2.000 -name clk_p11 -waveform {0.000 1.000} [get_ports clk_p11]
create_clock -period 2.000 -name clk_p21 -waveform {0.000 1.000} [get_ports clk_p21]
create_clock -period 2.000 -name clk_p31 -waveform {0.000 1.000} [get_ports clk_p31]
create_clock -period 2.000 -name clk_p41 -waveform {0.000 1.000} [get_ports clk_p41]

##################
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT5]]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT4]] -to [get_clocks clk_p11]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT4]] -to [get_clocks clk_p21]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT4]] -to [get_clocks clk_p31]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT4]] -to [get_clocks clk_p41]
set_false_path -from [get_clocks clk_p11] -to [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT5]]
set_false_path -from [get_clocks clk_p21] -to [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT5]]
set_false_path -from [get_clocks clk_p31] -to [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT4]]
set_false_path -from [get_clocks clk_p41] -to [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT5]]

set_false_path -from [get_clocks clk_p11] -to [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT4]]
set_false_path -from [get_clocks clk_p21] -to [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT4]]
set_false_path -from [get_clocks clk_p41] -to [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT4]]
set_false_path -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT5]]
set_false_path -from [get_clocks -of_objects [get_pins aurora_64b66b_0_i/inst/clock_module_i/ultrascale_tx_userclk_1/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O]] -to [get_clocks GCLK]
set_false_path -from [get_clocks -of_objects [get_pins aurora_64b66b_0_i/inst/clock_module_i/ultrascale_tx_userclk_1/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O]] -to [get_clocks clk_p11]
set_false_path -from [get_clocks -of_objects [get_pins aurora_64b66b_0_i/inst/clock_module_i/ultrascale_tx_userclk_1/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O]] -to [get_clocks clk_p21]
set_false_path -from [get_clocks -of_objects [get_pins aurora_64b66b_0_i/inst/clock_module_i/ultrascale_tx_userclk_1/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O]] -to [get_clocks clk_p31]
set_false_path -from [get_clocks -of_objects [get_pins aurora_64b66b_0_i/inst/clock_module_i/ultrascale_tx_userclk_1/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O]] -to [get_clocks clk_p41]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT4]]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks clk_p11]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks clk_p21]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks clk_p31]
set_false_path -from [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT1]] -to [get_clocks clk_p41]
set_false_path -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins clk_wiz_1_inst/inst/mmcme4_adv_inst/CLKOUT5]]








###################


set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[20]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[20]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[19]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[19]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[18]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[18]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[17]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[17]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[16]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[16]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[15]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[15]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[14]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[14]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[13]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[13]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[12]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[12]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[11]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[11]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[10]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[10]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[9]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[9]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[8]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[8]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[7]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[7]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[6]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[6]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[5]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[5]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[4]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[4]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[3]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[3]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[2]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[2]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[1]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[1]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p4[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_n4[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[20]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[19]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[18]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[17]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[16]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[15]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[14]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[13]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[12]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[11]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[10]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[9]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[8]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[7]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[6]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[5]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[4]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[3]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[2]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[1]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p3[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[20]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[19]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[18]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[17]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[16]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[15]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[14]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[13]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[12]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[11]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[10]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[9]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[8]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[7]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[6]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[5]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[4]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[3]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[2]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[1]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p2[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[20]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[19]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[18]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[17]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[16]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[15]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[14]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[13]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[12]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[11]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[10]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[9]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[8]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[7]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[6]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[5]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[4]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[3]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[2]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[1]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports {lvds_p1[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports clk_p21]
set_property DIFF_TERM_ADV TERM_100 [get_ports clk_p31]
set_property DIFF_TERM_ADV TERM_100 [get_ports clk_p41]
set_property DIFF_TERM_ADV TERM_100 [get_ports clk_p11]
set_property DIFF_TERM_ADV TERM_100 [get_ports clk_n11]



set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets GCLK]
