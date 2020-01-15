module ALU(
	input  wire clock,
	output wire[15:0] address_ram,
	input  wire[15:0] q_ram,
	output wire[15:0] data_ram,
	output wire[15:0] address_rom,
	input  wire[15:0] q_rom,
	
	output wire[15:0] out1,
	output wire[15:0] out2,
	output wire[15:0] out3,
	output wire[15:0] out4
);

reg[15:0] pc = 16'b0;
assign address_rom = pc;

enum bit[15:0] {
	NOP = 16'h18
} OPCODE;

enum {
	INIT,
	FETCH,
	READY
} STATE;

reg[15:0] opcode = NOP;
reg[15:0] state = INIT;

reg[15:0] o1;
reg[15:0] o2;
reg[15:0] o3;
reg[15:0] o4;
assign out1 = o1;
assign out2 = o2;
assign out3 = o3;
assign out4 = o4;

always_ff @( posedge clock ) begin
	o1 <= pc;
	o2 <= state;
	o3 <= opcode;
	o4 <= q_rom;
end

always_ff @( posedge clock ) begin
	if ( opcode == NOP ) begin
		case ( state )
			INIT: begin
				state <= FETCH;
			end
			FETCH: begin
				state <= READY;
			end
			READY: begin
				opcode <= q_rom;
				pc <= pc + 16'b1;
				state <= FETCH;
			end
		endcase
	end
end

endmodule
