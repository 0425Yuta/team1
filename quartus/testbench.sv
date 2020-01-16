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
	wire[15:0] PC;
	wire[15:0] STATE;
	wire[15:0] OPCODE;
	wire[15:0] ROM;
	wire[15:0] SP;
	wire[15:0] ADDR;


	CPU DUT(
		.CLK1_50(CLK1_50),
		.SW(SW),
		.LEDR(LEDR),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.OUT1(PC),
		.OUT2(STATE),
		.OUT3(OPCODE),
		.OUT4(ROM),
		.OUT5(SP),
		.OUT6(ADDR)
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

	initial #2000
		$stop;
endmodule
