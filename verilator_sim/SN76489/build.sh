#!/bin/bash

export RTL_DIR=$PWD/../../verilog/rtl/SN76489
set -e

#TRACE_FLAGS="--trace-depth 3 --trace -DTRACE_ON -CFLAGS '-DTRACE_ON'"
verilator -DBENCH -Wno-fatal --timing --top-module tb -cc -exe ${TRACE_FLAGS} bench.cpp ./tb.v ./DAC7611.v ${RTL_DIR}/attenuation.v ${RTL_DIR}/spi_dac_i.v ${RTL_DIR}/noise.v ${RTL_DIR}/pwm.v ${RTL_DIR}/signal_edge.v ${RTL_DIR}/tone.v ${RTL_DIR}/tt_um_rejunity_sn76489.v ${RTL_DIR}/wrapped_sn76489.v
cd obj_dir
make -f Vtb.mk
cd ..
