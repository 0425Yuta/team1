module ALU(
	input  wire clock,
	output wire[15:0] address_ram,
	input  wire[15:0] q_ram,
	output wire[15:0] data_ram,
	output wire[15:0] address_rom,
	input  wire[15:0] q_rom,
	
	output wire[15:0] out1,
	output wire[15:0] out2
);

reg[15:0] pc = 16'b0;
assign address_rom = pc;

enum {
	NOP
} OPCODE;

enum {
	READY
} STATE;

reg[15:0] opcode = NOP;
reg[15:0] state = READY;

reg[15:0] o1;
reg[15:0] o2;
assign out1 = o1;
assign out2 = o2;

always_ff @( posedge clock ) begin
	o1 <= pc;
	o2 <= state;
end

always_ff @( posedge clock ) begin
	if ( opcode == NOP ) begin
		case ( state )
			READY: begin
				opcode <= q_rom;
				pc <= pc + 16'b1;
			end
		endcase
	end
end

endmodule
