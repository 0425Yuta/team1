`timescale 1ns / 1ns
module testbench; 
	reg SW[9:0];
	wire LEDR[9:0];
	reg CLK1_50;

	CPU DUT(.CLK1_50(CLK1_50), .SW(SW), .LEDR(LEDR));

	initial begin
		SW[9:0] = '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };
	end

	initial begin
		CLK1_50 = 0;
		#50;
		repeat(30) begin
			CLK1_50 = 1;
			#50 CLK1_50 = 0;
			#50;
		end
	end

	initial #2000
		$stop;
endmodule
