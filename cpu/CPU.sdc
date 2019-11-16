create_clock -name CLK1_50 -period 20 [get_ports {CLK1_50}]
derive_clock_uncertainty
set_input_delay -clock { CLK1_50 } 1 [get_ports {KEY[0] KEY[1] SW[0] SW[1] SW[2] SW[3] SW[4] SW[5] SW[6] SW[7] SW[8] SW[9]}]
set_output_delay -clock { CLK1_50 } 1 [get_ports { LED[0] LED[1] LED[2] LED[3] LED[4] LED[5] LED[6] LED[7] LED[8] LED[9] VGA_B[0] VGA_B[1] VGA_B[2] VGA_B[3] VGA_G[0] VGA_G[1] VGA_G[2] VGA_G[3] VGA_HS VGA_R[0] VGA_R[1] VGA_R[2] VGA_R[3] VGA_VS}]
