# Clock and Reset Constraints
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

# Reset Button
set_property PACKAGE_PIN T18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# GPIO Switch Constraints
set_property PACKAGE_PIN P17 [get_ports up_btn]
set_property PACKAGE_PIN M17 [get_ports down_btn]
set_property PACKAGE_PIN M18 [get_ports left_btn]
set_property PACKAGE_PIN P18 [get_ports right_btn]
set_property PACKAGE_PIN N17 [get_ports select_btn]
set_property IOSTANDARD LVCMOS33 [get_ports {up_btn down_btn left_btn right_btn select_btn}]

# VGA Output Constraints
set_property PACKAGE_PIN N19 [get_ports hsync]
set_property PACKAGE_PIN P19 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports {hsync vsync}]

# VGA Color Channel Constraints
set_property PACKAGE_PIN T20 [get_ports {red[0]}]
set_property PACKAGE_PIN R20 [get_ports {red[1]}]
set_property PACKAGE_PIN N20 [get_ports {red[2]}]
set_property PACKAGE_PIN P20 [get_ports {red[3]}]
set_property PACKAGE_PIN U20 [get_ports {green[0]}]
set_property PACKAGE_PIN V20 [get_ports {green[1]}]
set_property PACKAGE_PIN W20 [get_ports {green[2]}]
set_property PACKAGE_PIN Y20 [get_ports {green[3]}]
set_property PACKAGE_PIN AB20 [get_ports {blue[0]}]
set_property PACKAGE_PIN AA20 [get_ports {blue[1]}]
set_property PACKAGE_PIN Y19 [get_ports {blue[2]}]
set_property PACKAGE_PIN W19 [get_ports {blue[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {red[*] green[*] blue[*]}]

# 7-Segment Display Constraints
set_property PACKAGE_PIN W4 [get_ports {seg_display[0]}]
set_property PACKAGE_PIN V4 [get_ports {seg_display[1]}]
set_property PACKAGE_PIN U4 [get_ports {seg_display[2]}]
set_property PACKAGE_PIN U2 [get_ports {seg_display[3]}]
set_property PACKAGE_PIN W2 [get_ports {seg_display[4]}]
set_property PACKAGE_PIN V2 [get_ports {seg_display[5]}]
set_property PACKAGE_PIN U1 [get_ports {seg_display[6]}]
set_property PACKAGE_PIN U3 [get_ports {seg_select[0]}]
set_property PACKAGE_PIN V1 [get_ports {seg_select[1]}]
set_property PACKAGE_PIN W1 [get_ports {seg_select[2]}]
set_property PACKAGE_PIN Y1 [get_ports {seg_select[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_display[*] seg_select[*]}]

# UART Constraints
set_property PACKAGE_PIN D4 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]

# Timing and Optimization Constraints
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
