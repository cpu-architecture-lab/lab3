set_global_assignment -entity "PLL_clk" -library "lib_PLL_clk" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_clk" -library "lib_PLL_clk" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "PLL_clk" -library "lib_PLL_clk" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_clk" -name SPD_FILE [file join $::quartus(sip_path) "PLL_clk.spd"]

set_global_assignment -library "lib_PLL_clk" -name MISC_FILE [file join $::quartus(sip_path) "PLL_clk_sim/PLL_clk.vho"]
