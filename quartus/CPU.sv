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
	output wire [3:0] VGA_B,

	output wire [15:0] OUT1,
	output wire [15:0] OUT2,
	output wire [15:0] OUT3,
	output wire [15:0] OUT4,
	output wire [15:0] OUT5,
	output wire [15:0] OUT6,

  output wire [15:0] SEG1,
  output wire [15:0] SEG2
);
	wire clock_cpu;
	wire clock_vga;

	reg[15:0] address_cpu, address_vga, q_cpu, q_vga, data_cpu, data_vga;
	reg[15:0] address_rom, q_rom;
	wire wren_cpu;
	reg wren_vga;
	PLL pll(.inclk0(CLK1_50), .c0(clock_cpu), .c1(clock_vga));
	RAM ram(
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
	VGA vga(
		.q(q_vga),
		.clock(clock_vga),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.HS(VGA_HS),
		.VS(VGA_VS)
	);
	
	ALU alu(
		.clock(clock_cpu),
		.address_ram(address_cpu),
		.q_ram(q_cpu),
		.data_ram(data_cpu),
		.wren_ram(wren_cpu),
		.address_rom(address_rom),
		.out1(OUT1),
		.out2(OUT2),
		.out3(OUT3),
		.out4(OUT4),
		.out5(OUT5),
		.out6(OUT6),
    .SEG1(SEG1),
    .SEG2(SEG2),
		.q_rom(q_rom));

endmodule

`default_nettype wire
