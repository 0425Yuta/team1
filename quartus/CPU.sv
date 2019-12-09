`default_nettype none

module CPU(
	output logic LEDR[9:0],
	input  logic SW[9:0],
	input  wire CLK1_50
);

	assign LEDR[0] = SW[0];
	
	wire clock_cpu;
	wire clock_vga;
	
	PLL pll(.inclk0(CLK1_50), .c0(clock_cpu), .c1(clock_vga)); 

endmodule

`default_nettype wire
