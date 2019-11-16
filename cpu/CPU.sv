module CPU(
	input wire CLK1_50,
	output wire [3:0] VGA_R,
	output wire [3:0] VGA_G,
	output wire [3:0] VGA_B,
	output wire VGA_HS,
	output wire VGA_VS
);
	wire	[15:0]  address_a;
	wire	[15:0]  address_b;
	wire	clock_a;
	wire	clock_b;
	wire	[15:0]  data_a;
	wire	[15:0]  data_b;
	wire	wren_a;
	wire	wren_b;
	wire	[15:0]  q_a;
	wire	[15:0]  q_b;
	ram main(.address_a, .address_b, .clock_a, .clock_b, .data_a, .data_b, .wren_a, .wren_b, .q_a, .q_b);
	
	VGA vga(
		.clock(CLK1_50),
		.clear(0),
		.addr(address_b),
		.mem_clock(CLK1_50),
		.data(q_b),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS));
endmodule
