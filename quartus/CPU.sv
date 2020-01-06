`default_nettype none

module CPU(
	output wire LEDR[9:0],
	input  wire SW[9:0],
	input  wire KEY[1:0],
	input  wire CLK1_50,
	output wire VGA_VS,
	output wire VGA_HS,
	output wire [3:0] VGA_R,
	output wire [3:0] VGA_G,
	output wire [3:0] VGA_B
);
	wire clock_cpu;
	wire clock_vga;

	wire[15:0] address_cpu, address_vga, q_cpu, q_vga, data_cpu, data_vga;
	wire[15:0] address_rom, q_rom;
	wire wren_cpu, wren_vga;
PLL pll(.inclk0(CLK1_50), .c0(clock_cpu), .c1(clock_vga)); RAM ram(
		.clock_a(clock_cpu),
		.clock_b(clock_vga),
		.address_a(address_cpu),
		.wren_a(wren_cpu),
		.q_a(q_cpu),
		.data_a(data_vga),
		.address_b(address_vga),
		.wren_b(wren_vga),
		.q_b(q_vga),
		.data_b(data_vga));

	ROM rom(
		.clock(clock_cpu),
		.address(address_rom),
		.q(q_rom));

	// DEBUG
	VGA
	vga(
		.q(q_vga),
		.clock(clock_vga),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.HS(VGA_HS),
		.VS(VGA_VS)
	);
	
	reg[8:0] clock_count = 8'd0;
	wire clock_alu = clock_cpu & (clock_count >= 8'd4);
	wire clock_ctl = clock_cpu & (clock_count < 8'd4);
	
	ALU alu(
		.clock(clock_alu),
		.address_ram(address_cpu),
		.q_ram(q_cpu),
		.data_ram(data_cpu),
		.address_rom(address_rom),
		.q_rom(q_rom));

	CTL ctl(
		.LED(LEDR),
		.SW(SW),
		.KEY(KEY),
		.clock(clock_ctl),
		.address_ram(address_cpu),
		.q_ram(q_cpu),
		.data_ram(data_cpu));

endmodule

`default_nettype wire
