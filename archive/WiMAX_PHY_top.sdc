## Generated SDC file "WiMAX_PHY.out.sdc"

## Copyright (C) 2023 Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors. Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 22.1std.2 Build 922 07/20/2023 SC Lite Edition"

## DATE    "Thu Nov 28 20:57:15 2024"

##
## DEVICE  "5CEBA4F23C7"
##


#**********************
# Time Information
#**********************

set_time_format -unit ns -decimal_places 3



#**********************
# Create Clock
#**********************

# 50 MHz Reference Clock
create_clock -name {clk_ref} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk_ref}]



#**********************
# Create Generated Clocks
#**********************

# Generated Clock 50 MHz (output clock from PLL)
create_generated_clock -name {clk_50mhz} -source [get_pins {PLL_inst|pll_50_100_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin}] -duty_cycle 50/1 -multiply_by 1 -divide_by 1 -master_clock {clk_ref} [get_pins {PLL_inst|pll_50_100_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}] 

# Generated Clock 100 MHz (output clock from PLL)
create_generated_clock -name {clk_100mhz} -source [get_pins {PLL_inst|pll_50_100_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin}] -duty_cycle 50/1 -multiply_by 2 -divide_by 1 -master_clock {clk_ref} [get_pins {PLL_inst|pll_50_100_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] 



#**********************
# Set Clock Latency (Optional, if known latency is specified)
#**********************

# Example (if latency was known):
# set_clock_latency -latency 0.050 -from [get_clocks clk_50mhz]



#**********************
# Set Clock Uncertainty
#**********************

# Setup and hold uncertainties for 50 MHz and 100 MHz clocks
set_clock_uncertainty -rise_from [get_clocks clk_50mhz] -rise_to [get_clocks clk_50mhz] -setup 0.080
set_clock_uncertainty -rise_from [get_clocks clk_50mhz] -rise_to [get_clocks clk_50mhz] -hold 0.060

set_clock_uncertainty -rise_from [get_clocks clk_100mhz] -rise_to [get_clocks clk_100mhz] -setup 0.080
set_clock_uncertainty -rise_from [get_clocks clk_100mhz] -rise_to [get_clocks clk_100mhz] -hold 0.060


# Optional: Repeat for fall-to and other combinations if needed
# set_clock_uncertainty -fall_from [get_clocks clk_50mhz] -fall_to [get_clocks clk_50mhz] -setup 0.080
# set_clock_uncertainty -fall_from [get_clocks clk_50mhz] -fall_to [get_clocks clk_50mhz] -hold 0.060
# set_clock_uncertainty -fall_from [get_clocks clk_100mhz] -fall_to [get_clocks clk_100mhz] -setup 0.080
# set_clock_uncertainty -fall_from [get_clocks clk_100mhz] -fall_to [get_clocks clk_100mhz] -hold 0.060