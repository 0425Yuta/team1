`timescale 1ns / 1ns
module testbench; 
	reg SW[9:0];
	wire LEDR[9:0];
	reg CLK1_50;
	wire [3:0] VGA_R;
	wire [3:0] VGA_G;
	wire [3:0] VGA_B;
	wire VGA_HS;
	wire VGA_VS;
	wire[15:0] OUT1;
	wire[15:0] OUT2;


	CPU DUT(
		.CLK1_50(CLK1_50),
		.SW(SW),
		.LEDR(LEDR),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.OUT1(OUT1),
		.OUT2(OUT2)
	);

	initial begin
		SW[9:0] = '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0 };
	end

	initial begin
		CLK1_50 = 0;
		#5;
		forever begin
			CLK1_50 = 1;
			#5 CLK1_50 = 0;
			#5;
		end
	end

	initial #2000000
		$stop;
endmodule
