module CPU (
	input  CLK1_50,
	input  [1:0] KEY,
	output LED[9:0],
	// TODO: investigate 'VGA_?[?] is stuck at GND'
	output [3:0] VGA_R,
	output [3:0] VGA_G,
	output [3:0] VGA_B,
	output VGA_HS,
	output VGA_VS
);

	wire [15:0]  address_ram;
	wire [15:0]  address_vram;
	wire [15:0]  address_rom;
	wire clock_ram;
	wire clock_vram;
	wire [15:0]  data_ram;
	wire [15:0]  data_vram;
	wire [15:0]  data_rom;
	wire [15:0]  q_ram;
	wire [15:0]  q_vram;

	reg clock_cpu = 1'b1;
	reg clock_vga = 1'b1;
	wire clear = KEY[0];

	PLL_CPU pll_cpu(.refclk(CLK1_50), .rst(clear), .outclk_0(clock_cpu));
	PLL_VGA pll_vga(.refclk(CLK1_50), .rst(clear), .outclk_0(clock_vga));
	
	assign clock_ram  = clock_cpu;
	assign clock_vram = clock_vga;

	RAM ram (
		.address_a(address_ram),
		.clock_a(clock_ram),
		.data_a(data_ram),
		.q_a(q_ram),
		.address_b(address_vram),
		.clock_b(clock_vram),
		.data_b(data_vram),
		.q_b(q_vram));

	ROM rom (
		.address(address_rom),
		.clock(clock_cpu),
		.q(data_rom));
	
	VGA vga(
		.clock(clock_vga),
		.clear(clear),
		.addr(address_vram),
		.data(data_vram),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS));
		
	ALU alu (
		.clock(clock_cpu),
		.address_ram(address_ram),
		.address_rom(address_rom),
		.data_ram(data_ram),
		.data_rom(data_rom)
	);
endmodule
