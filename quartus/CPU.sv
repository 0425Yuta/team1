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

	PLL pll(.inclk0(CLK1_50), .c0(clock_cpu), .c1(clock_vga));

	always @(posedge clock_cpu) begin
		LED[0] <= ~LED[0];
	end

	always @(posedge clock_vga) begin
		LED[1] <= ~LED[1];
	end

endmodule

`default_nettype wire
