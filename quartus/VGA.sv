module VGA #(
	parameter [15:0]  WIDTH  = 16'd640,
	parameter [15:0]  HEIGHT = 16'd480
)(
	input wire clock,
	input wire [15:0] q,
	output wire VS,
	output wire HS,
	output wire [3:0] VGA_R,
	output wire [3:0] VGA_G,
	output wire [3:0] VGA_B
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

	reg[3:0] R = 4'b0000;
	reg[3:0] G = 4'b0000;
	reg[3:0] B = 4'b0000;

	wire wren = 
		x >= HSYNC_INTERVAL + H_WAIT_START &&
		x < HSYNC_INTERVAL + H_WAIT_START + WIDTH &&
		y >= VSYNC_INTERVAL + V_WAIT_START &&
		y < VSYNC_INTERVAL + V_WAIT_START + HEIGHT;

	assign VGA_R = R & {wren, wren, wren, wren};
	assign VGA_G = G & {wren, wren, wren, wren};
	assign VGA_B = B & {wren, wren, wren, wren};

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
		if (R == 4'b1111)
			R <= 4'b0000;
		else
			R <= R + 4'b0001;
		if (G == 4'b1111)
			G <= 4'b0000;
		else
			G <= G + 4'b0001;
		if (B == 4'b1111)
			B <= 4'b0000;
		else
			B <= B + 4'b0001;
	end
endmodule
