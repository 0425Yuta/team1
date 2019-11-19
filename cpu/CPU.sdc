create_clock -name CLK1_50 -period 20 [get_ports {CLK1_50}]
derive_clock_uncertainty
set_input_delay -clock { CLK1_50 } 1 [get_ports { KEY[0] KEY[1] }]
set_output_delay -clock { CLK1_50 } 1 [get_ports { VGA_B[0] VGA_B[1] VGA_B[2] VGA_B[3] VGA_G[0] VGA_G[1] VGA_G[2] VGA_G[3] VGA_HS VGA_R[0] VGA_R[1] VGA_R[2] VGA_R[3] VGA_VS}]
derive_pll_clocks -create_base_clocks
