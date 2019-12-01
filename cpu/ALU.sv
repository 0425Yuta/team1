module ALU(
	output logic [15:0] address_ram,
	output logic [15:0] address_rom,
	input  logic clock,
	output logic [15:0] data_ram,
	input  logic [15:0] q_ram,
	input  logic [15:0] q_rom
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
	
	enum bit [2:0] {
		READY,
		PICKING_2ND_ARG,
		LOOKING_OPERAND
	} STATE;
	
	logic [2:0] state = READY;
	logic [15:0] opcode = 15'b0;
	
	assign address_rom = PC;
	
	// q_ram normaly holds top of stack presented PC.
	
	logic [15:0] arg1 = 15'b0;
	logic [15:0] arg2 = 15'b0;
	
	always_ff @( posedge clock ) begin
		case ( state )
			READY: begin
				opcode <= q_rom;
				case ( q_rom )
					IGN: begin
						state <= READY;
						SP <= SP - 15'b1;
						PC <= PC + 15'b1;
					end
					IMM: begin
						state <= LOOKING_OPERAND;
						PC <= PC + 15'b1;
					end
				endcase
			end
			LOOKING_OPERAND:
				case ( opcode )
					IMM: begin
						state <= READY;
						address_ram <= SP + 15'b1;
						data_ram <= q_rom;
						PC <= 15'b1;
					end
				endcase
		endcase
	end

endmodule

