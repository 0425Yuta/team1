module RAM(
);
	reg [256*256*3:0] vram;
	VGA640x480(.vram, .clock(CLK_1_50), .clear(0), .VGA_R, .VGA_G, .VGA_B, .VGA_HS, .VGA_VS);
endmodule
