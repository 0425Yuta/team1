`default_nettype none

module CPU(
	output wire LEDR[9:0],
	input  wire SW[9:0],
	input  wire CLK1_50
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

	always @(posedge clock_cpu) begin
		LED[0] <= ~LED[0];
	end

	always @(posedge clock_vga) begin
		LED[1] <= ~LED[1];
	end

endmodule

`default_nettype wire
