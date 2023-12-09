###############################################################################
# Created by write_sdc
# Fri Dec  8 14:50:03 2023
###############################################################################
current_design tholin_avalonsemi_tbb1143
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 60.0000 
set_clock_uncertainty 0.2500 clk
set_clock_latency -source -min 4.6500 [get_clocks {clk}]
set_clock_latency -source -max 5.5700 [get_clocks {clk}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.1900 [get_ports {io_out[4]}]
set_load -pin_load 0.1900 [get_ports {io_out[3]}]
set_load -pin_load 0.1900 [get_ports {io_out[2]}]
set_load -pin_load 0.1900 [get_ports {io_out[1]}]
set_load -pin_load 0.1900 [get_ports {io_out[0]}]
set_input_transition -min 0.0500 [get_ports {io_in[5]}]
set_input_transition -max 0.3800 [get_ports {io_in[5]}]
set_input_transition -min 0.0500 [get_ports {io_in[4]}]
set_input_transition -max 0.3800 [get_ports {io_in[4]}]
set_input_transition -min 0.0500 [get_ports {io_in[3]}]
set_input_transition -max 0.3800 [get_ports {io_in[3]}]
set_input_transition -min 0.0500 [get_ports {io_in[2]}]
set_input_transition -max 0.3800 [get_ports {io_in[2]}]
set_input_transition -min 0.0500 [get_ports {io_in[1]}]
set_input_transition -max 0.3800 [get_ports {io_in[1]}]
set_input_transition -min 0.0500 [get_ports {io_in[0]}]
set_input_transition -max 0.3800 [get_ports {io_in[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 3.0000 [current_design]
set_max_fanout 4.0000 [current_design]
