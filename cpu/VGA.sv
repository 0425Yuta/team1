module VGA
#(
	parameter[15:0] HEIGHT = 480,
	parameter[15:0] WIDTH = 640,
	parameter[15:0] PIXEL_WIDTH = 20;
	parameter[15:0] PIXEL_HEIGHT = 20;
	// available memory areaset_output_delay -clock { CLK1_50 } 1 [get_ports { VGA_B[0] VGA_B[1] VGA_B[2] VGA_B[3] VGA_G[0] VGA_G[1] VGA_G[2] VGA_G[3] VGA_HS VGA_R[0] VGA_R[1] VGA_R[2] VGA_R[3] VGA_VS}]
	parameter[15:0] MEM_HEIGHT = 24,
	parameter[15:0] MEM_WIDTH = 32,
	// address offset
	parameter[15:0] MEM_ADDR_OFFSET = 0,
	// unit is pixel clock cycle
	parameter[15:0] HSYNC_WIDTH = 96,
	parameter[15:0] H_BACK_PORCH = 48,
	parameter[15:0] H_FRONT_PORCH = 16,
	// unit is lines
	parameter[15:0] VSYNC_HEIGHT = 2,
	parameter[15:0] V_BACK_PORCH = 33,
	parameter[15:0] V_FRONT_PORCH = 10
)
(
	// must be 25 MHz
	input clock,
	input clear,
	
	output [15:0] addr = MEM_ADDR_OFFSET,
	input  [15:0] data,

	output [3:0] VGA_R,
	output [3:0] VGA_G,
	output [3:0] VGA_B,
	
	output VGA_HS,
	output VGA_VS
);
	localparam [15:0] WIDTH_TOTAL = HSYNC_WIDTH + H_BACK_PORCH + WIDTH + H_FRONT_PORCH;
	localparam [15:0] HEIGHT_TOTAL = VSYNC_HEIGHT + V_BACK_PORCH + HEIGHT + V_FRONT_PORCH;
	localparam [15:0] H_AVAILABLE_BEGIN = HSYNC_WIDTH + H_BACK_PORCH;
	localparam [15:0] V_AVAILABLE_BEGIN = VSYNC_HEIGHT + V_BACK_PORCH;
	localparam [15:0] H_AVAILABLE_END = H_AVAILABLE_BEGIN + WIDTH;
	localparam [15:0] V_AVAILABLE_END = V_AVAILABLE_BEGIN + HEIGHT;
	
	always_comb begin
		if ( x < HSYNC_WIDTH || x >= H_AVAILABLE_END ) begin
			VGA_HS <= 0;
		end
		else begin
			VGA_HS <= 1;
		end
			
		if ( y < VSYNC_HEIGHT || y >= V_AVAILABLE_END) begin
			VGA_VS <= 0;
		end
		else begin
			VGA_VS <= 1;
		end
	end

	logic select_l = 0;
	logic [15:0] x = 15'b0;
	logic [15:0] y = 15'b0;
	logic [15:0] x_count = 15'b0;
	logic [15:0] x_mem_count = 15'b0;
	logic [15:0] y_count = 15'b0;
	logic [15:0] y_mem_count = 15'b0;

	always_ff @( negedge clock ) begin
		if ( x >= H_AVAILABLE_BEGIN && x < H_AVAILABLE_END && y >= V_AVAILABLE_BEGIN && y < V_AVAILABLE_END ) begin
			if ( !select_l ) begin
				VGA_R <= { data[ 9: 8], 1'b0 };
				VGA_G <= { data[11:10], 1'b0 };
				VGA_B <= { data[13:12], 1'b0 };
			end
			else begin
				VGA_R <= { data[ 1: 0], 1'b0 };
				VGA_G <= { data[ 3: 2], 1'b0 };
				VGA_B <= { data[ 5: 4], 1'b0 };
			end
			
			// go origin
			if ( y_mem_count == MEM_HEIGHT && x_mem_count == MEM_WIDTH && x_count == PIXEL_WIDTH && y_count == PIXEL_HEIGHT ) begin
				addr <= MEM_ADDR_OFFSET;
				y_count <= 15'b0;
				y_mem_count <= 15'b0;
				x_count <= 15'b0;
				x_mem_count <= 15'b0;
			end
			// go next line on memory.
			else if ( x_mem_count == MEM_WIDTH && x_count == PIXEL_WIDTH && y_count == PIXEL_HEIGHT ) begin
				addr <= addr + 15'b1;
				y_count <= 15'b0;
				x_count <= 15'b0;
				x_mem_count <= 15'b0;
			end
			// repeat line
			else if ( x_mem_count == MEM_WIDTH && x_count == PIXEL_WIDTH ) begin
				addr <= addr - MEM_WIDTH;
				x_mem_count <= 15'b0;
				x_count <= 15'b0;
				y_count <= y_count + 15'b1;
			end
			// go next pixel on memory
			else if ( x_count == PIXEL_WIDTH ) begin
				if ( !select_l ) begin
					addr <= addr + 15'b1;
				end
				select_l <= !select_l;
				x_count <= 15'b0;
			end
			// update display cursor, but don't update memory cursor.
			else begin
				x_count <= x_count + 15'b1;
			end
			x <= x + 15'b1;

			if ( clear ) begin
				x <= 15'b0;
				y <= 15'b0;
				addr <= 15'b0;
			end
		end
		else begin
			if ( x == WIDTH_TOTAL && y == HEIGHT_TOTAL ) begin
				x <= 15'b0;
				y <= 15'b0;
			end
			else if ( x == WIDTH_TOTAL ) begin
				x <= 15'b0;
				y <= y + 15'b1;
			end
			else begin
				x <= x + 15'b1;
			end

			if ( clear ) begin
				x <= 15'b0;
				y <= 15'b0;
				addr <= 15'b0;
			end
		end
	end
endmodule
