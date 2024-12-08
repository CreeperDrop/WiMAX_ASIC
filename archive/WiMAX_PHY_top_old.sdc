create_clock -name clk_ref -period 20.0 [get_ports clk_ref]
#create_generated_clock -name clk_100 -source clk_ref -multiply_by 2 [get_ports PLL_inst|outclk_1]
#create_generated_clock -name clk_50  -source clk_ref -multiply_by 1 [get_ports PLL_inst|outclk_0]
derive_pll_clocks