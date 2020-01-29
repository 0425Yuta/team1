module VGA #(
	parameter [15:0]  WIDTH  = 16'd640,
	parameter [15:0]  HEIGHT = 16'd480,
	parameter [15:0]  VGA_REGION = 16'h2000
)(
	input wire clock,
	input wire [15:0] q,
	output wire [15:0] vga_addr,
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

	wire wren = 
		x >= HSYNC_INTERVAL + H_WAIT_START &&
		x < HSYNC_INTERVAL + H_WAIT_START + WIDTH &&
		y >= VSYNC_INTERVAL + V_WAIT_START &&
		y < VSYNC_INTERVAL + V_WAIT_START + HEIGHT;

	assign VGA_R = q[3:0] & {wren, wren, wren, wren};
	assign VGA_G = q[7:3] & {wren, wren, wren, wren};
	assign VGA_B = q[11:4] & {wren, wren, wren, wren};

	localparam [15:0] PIXEL_HEIGHT = 16'd16;
	localparam [15:0] PIXEL_WIDTH  = 16'd16;
	localparam [15:0] MEM_WIDTH = HEIGHT / PIXEL_HEIGHT;
	localparam [15:0] MEM_HEIGHT = WIDTH / PIXEL_WIDTH;

	reg [15:0] vga_x = 16'h2;
	reg [15:0] vga_y = 16'h0;
	reg [15:0] mem_x = 16'h0;
	reg [15:0] mem_y = 16'h0;
	reg [15:0] addr = 16'h0;
	assign vga_addr = addr;

	always_ff @(posedge clock) begin
		if (
			x + 16'h2 >= HSYNC_INTERVAL + H_WAIT_START &&
			x + 16'h2 <  HSYNC_INTERVAL + H_WAIT_START + WIDTH &&
			y >= VSYNC_INTERVAL + V_WAIT_START &&
			y <  VSYNC_INTERVAL + V_WAIT_START + HEIGHT
		) begin
			if ( vga_x >= PIXEL_WIDTH-1 && vga_y >= PIXEL_HEIGHT-1 && mem_x >= MEM_WIDTH-1 && mem_y >= MEM_HEIGHT-1 ) begin
				vga_x <= 16'h0;
				mem_x <= 16'h0;
				vga_y <= 16'h0;
				mem_y <= 16'h0;
				addr <= 16'h0;
			end
			else if ( vga_x >= PIXEL_WIDTH-1 && mem_x >= MEM_WIDTH-1 && vga_y >= PIXEL_HEIGHT-1 ) begin
				vga_x <= 16'h0;
				mem_x <= 16'h0;
				vga_y <= 16'h0;
				mem_y <= mem_y + 16'h1;
				addr <= addr + 16'h1;
			end
			else if ( vga_x >= PIXEL_WIDTH-1 && mem_x >= MEM_WIDTH-1 ) begin
				vga_x <= 16'h0;
				mem_x <= 16'h0;
				vga_y <= vga_y + 16'h1;
				addr <= addr - (MEM_WIDTH - 16'h1);
			end
			else if ( vga_x >= PIXEL_WIDTH-1 ) begin
				vga_x <= 16'h0;
				mem_x <= mem_x + 16'h1;
				addr <= addr + 16'h1;
			end
			else begin
				vga_x <= vga_x + 16'h1;
			end
		end
	end

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
endmodule
