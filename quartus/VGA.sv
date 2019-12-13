module VGA #(
	parameter [15:0]  WIDTH  = 16'd640,
	parameter [15:0]  HEIGHT = 16'd480
)(
	input wire clock,
	input wire [15:0] q,
	output wire VS,
	output wire HS,
	output logic [2:0] VGA_R,
	output logic [2:0] VGA_G,
	output logic [2:0] VGA_B
);
	localparam [15:0] H_WAIT_NEWLINE = 15'd16;
	localparam [15:0] HSYNC_INTERVAL = 15'd96;
	localparam [15:0] H_WAIT_START = 15'd48;

	localparam [15:0] V_WAIT_NEWSCREEN = 15'd10;
	localparam [15:0] VSYNC_INTERVAL = 15'd2;
	localparam [15:0] V_WAIT_START = 15'd33;
	
	reg [15:0] x = 16'h0;
	reg [15:0] y = 16'h0;

	assign HS = x >= HSYNC_INTERVAL;
	assign VS = y >= VSYNC_INTERVAL;

	localparam [15:0] H_TOTAL = H_WAIT_START + H_WAIT_NEWLINE   + WIDTH  + HSYNC_INTERVAL;
	localparam [15:0] V_TOTAL = V_WAIT_START + V_WAIT_NEWSCREEN + HEIGHT + VSYNC_INTERVAL;

	always_ff @(posedge clock) begin
		if (x >= H_TOTAL && y >= V_TOTAL) begin
			x <= 16'd0;
			y <= 16'd0;
		end
		else if (x >= H_TOTAL) begin
			x <= 16'd0;
			y <= y + 16'd1;
		end
		else begin
			x <= x + 16'd1;
		end
	end

	always_ff @(posedge clock) begin
		if (VGA_R == 3'b111)
			VGA_R <= 3'b000;
		else
			VGA_R <= VGA_R + 3'b001;
		if (VGA_G == 3'b111)
			VGA_G <= 3'b000;
		else
			VGA_G <= VGA_G + 3'b001;
		if (VGA_B == 3'b111)
			VGA_B <= 3'b000;
		else
			VGA_B <= VGA_B + 3'b001;
	end
endmodule
