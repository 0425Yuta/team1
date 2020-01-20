`default_nettype none

module CPU(
	output wire LEDR[9:0],
	input  wire SW[9:0],
	input  wire CLK1_50,
	output wire VGA_VS,
	output wire VGA_HS,
	output wire [3:0] VGA_R,
	output wire [3:0] VGA_G,
	output wire [3:0] VGA_B
);
	wire clock_cpu;
	wire clock_vga;

	reg LED[9:0] = '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };
	assign LEDR[9:0] = LED[9:0];

	wire address_cpu, address_vga, q_cpu, q_vga, wren_cpu, wren_vga, data_cpu, data_vga;

	PLL pll(.inclk0(CLK1_50), .c0(clock_cpu), .c1(clock_vga));
	RAM ram(
		.address_a(address_cpu),
		.wren_a(wren_cpu),
		.q_a(q_cpu),
		.data_a(data_vga),
		.address_b(address_vga),
		.wren_b(wren_vga),
		.q_b(q_vga),
		.data_b(data_vga));

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

	always @(posedge clock_cpu) begin
		LED[0] <= ~LED[0];
	end

	always @(posedge clock_vga) begin
		LED[1] <= ~LED[1];
	end

endmodule

`default_nettype wire
