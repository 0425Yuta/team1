module CPU(
	input wire [9:0] SW,
	input wire [1:0] KEY,
	input wire CLK1_50,
	output wire [9:0] LED,
	output wire [3:0] VGA_R,
	output wire [3:0] VGA_G,
	output wire [3:0] VGA_B,
	output wire VGA_HS,
	output wire VGA_VS,
	output wire [12:0] DRAM_ADDR,
	output wire [1:0] DRAM_BA,
	output wire DRAM_CAS_N,
	output wire DRAM_CKE,
	output wire DRAM_CLK,
	output wire DRAM_CS_N,
	input wire [15:0] DRAM_DQ,
	output wire DRAM_LDQM,
	output wire DRAM_RAS_N,
	output wire DRAM_UDQM,
	output wire DRAM_WE_N
);
endmodule
