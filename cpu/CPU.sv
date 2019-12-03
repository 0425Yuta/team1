`default_nettype none

module CPU(
	output logic LEDR[9:0],
	input  logic SW[9:0]
);

	assign LEDR[0] = SW[0];

endmodule

`default_nettype wire