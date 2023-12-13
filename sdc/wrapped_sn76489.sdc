###############################################################################
# Created by write_sdc
# Wed Dec 13 09:20:42 2023
###############################################################################
current_design wrapped_sn76489
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 12.0000 [get_ports {wb_clk_i}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_clock_latency -source -min 4.6500 [get_clocks {clk}]
set_clock_latency -source -max 5.5700 [get_clocks {clk}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.1900 [get_ports {io_out[27]}]
set_load -pin_load 0.1900 [get_ports {io_out[26]}]
set_load -pin_load 0.1900 [get_ports {io_out[25]}]
set_load -pin_load 0.1900 [get_ports {io_out[24]}]
set_load -pin_load 0.1900 [get_ports {io_out[23]}]
set_load -pin_load 0.1900 [get_ports {io_out[22]}]
set_load -pin_load 0.1900 [get_ports {io_out[21]}]
set_load -pin_load 0.1900 [get_ports {io_out[20]}]
set_load -pin_load 0.1900 [get_ports {io_out[19]}]
set_load -pin_load 0.1900 [get_ports {io_out[18]}]
set_load -pin_load 0.1900 [get_ports {io_out[17]}]
set_load -pin_load 0.1900 [get_ports {io_out[16]}]
set_load -pin_load 0.1900 [get_ports {io_out[15]}]
set_load -pin_load 0.1900 [get_ports {io_out[14]}]
set_load -pin_load 0.1900 [get_ports {io_out[13]}]
set_load -pin_load 0.1900 [get_ports {io_out[12]}]
set_load -pin_load 0.1900 [get_ports {io_out[11]}]
set_load -pin_load 0.1900 [get_ports {io_out[10]}]
set_load -pin_load 0.1900 [get_ports {io_out[9]}]
set_load -pin_load 0.1900 [get_ports {io_out[8]}]
set_load -pin_load 0.1900 [get_ports {io_out[7]}]
set_load -pin_load 0.1900 [get_ports {io_out[6]}]
set_load -pin_load 0.1900 [get_ports {io_out[5]}]
set_load -pin_load 0.1900 [get_ports {io_out[4]}]
set_load -pin_load 0.1900 [get_ports {io_out[3]}]
set_load -pin_load 0.1900 [get_ports {io_out[2]}]
set_load -pin_load 0.1900 [get_ports {io_out[1]}]
set_load -pin_load 0.1900 [get_ports {io_out[0]}]
set_input_transition 0.6100 [get_ports {wb_clk_i}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 3.0000 [current_design]
set_max_fanout 4.0000 [current_design]
