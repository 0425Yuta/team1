module ALU(
	output [15:0] address_ram,
	output [15:0] address_rom,
	input clock,
	input [15:0] data_ram,
	input [15:0] data_rom
);

	logic[15:0] PC = 15'b0;
	logic[15:0] FP = 15'b0;
	logic[15:0] SP = 15'b0;
	logic[15:0] FPSUB = 15'b0;
	logic[15:0] JMPSUB = 15'b0;
	logic[15:0] RETVAL = 15'b0;
	
	enum bit [15:0] {
		IGN   = 16'h0000,
		IMM   = 16'h0001,  
		STOM  = 16'h0002,
		LOADM = 16'h0003,
		STOL  = 16'h0004,
		LOADL = 16'h0005,
		JMP   = 16'h0006,
		BRA   = 16'h0007,
		BEC   = 16'h0008,
		CALL  = 16'h0009,
		RET   = 16'h000a,
		ADD   = 16'h000b,
		SUB   = 16'h000c,
		MUL   = 16'h000d,
		DIV   = 16'h000e,
		MOD   = 16'h000f,
		GRET  = 16'h0010,
		LESS  = 16'h0011,
		EQ    = 16'h0012,
		NEQ   = 16'h0013,
		AND   = 16'h0014,
		OR    = 16'h0015,
		XOR   = 16'h0016,
		NOT   = 16'h0017
	} INSTRUCTION;
	
	always @( posedge clock ) begin
		address_rom <= PC;
	end

endmodule

