module CTL(
	input  wire SW[9:0],
	input  wire KEY[1:0],
	output wire LED[9:0],

	input  wire clock,
	output wire[15:0] address_ram,
	output wire[15:0] q_ram,
	output wire[15:0] data_ram
);
endmodule
