module VGA #(
	parameter [15:0]  WIDTH  = 16'd640,
	parameter [15:0]  HEIGHT = 16'd480,
	parameter [15:0]  VGA_ADDR = 16'h2000
)(
	input wire clock,
	input wire [15:0] q,
	output wire [15:0] address,
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

	localparam [15:0] PX_W = 16'd40;
	localparam [15:0] PX_H = 16'd30;
	localparam [15:0] MEM_W = WIDTH / PX_W;
	localparam [15:0] MEM_H = HEIGHT / PX_H;
	
	reg [15:0] x = 16'h0;
	reg [15:0] y = 16'h0;
	reg [15:0] dx = 16'h0;
	reg [15:0] dy = 16'h0;
	reg [15:0] px_x = 16'h0;
	reg [15:0] px_y = 16'h0;
	reg [15:0] addr = 16'h0;
	assign address = addr;

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

	wire en = wren & clock;

	always_ff @(posedge en) begin
		if (dx >= PX_W && dy >= PX_H && px_x >= MEM_W && px_y >= MEM_H) begin
			dx <= 16'd0;
			dy <= 16'd0;
			px_y <= 16'd0;
			px_x <= 16'd0;
		end
		else if (dx >= PX_W && dy >= PX_H && px_x >= MEM_W ) begin
			px_y <= px_y + 16'd1;
			dy <= 16'd0;
			px_x <= 16'd0;
			dx <= 16'd0;
		end
		else if (dx >= PX_W && px_x >= MEM_W ) begin
			dx <= 16'd0;
			px_x <= 16'd0;
			dy <= dy + 16'd1;
		end
		else if (dx >= PX_W ) begin
			dx <= 16'd0;
			px_x <= px_x + 16'd1;
		end
		else begin
			dx <= dx + 16'd1;
		end
	end

	always_ff @(posedge en) begin
		addr <= {px_y[11:0], px_x[3:0]};
		R <= q[3:0];
		G <= q[7:4];
		B <= q[11:8];
	end
endmodule
