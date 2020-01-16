module ALU(
	input  wire clock,
	output wire[15:0] address_ram,
	input  wire[15:0] q_ram,
	output wire wren_ram,
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
reg[15:0] addr = 16'h0000;
assign address_ram = addr;
reg[15:0] data = 16'h0000;
assign data_ram = data;
reg[15:0] sp = 16'h0000;
reg wren = 0;
assign wren_ram = wren;

enum bit[15:0] {
	NOP = 16'h18,
	JMP = 16'h06,
	IMM = 16'h01
} OPCODE;

enum bit[15:0] {
	INIT,
	WAIT_FETCHING,
	FETCH,
	READY,
	FETCH_OPERAND,
	ERROR = 16'hffff
} STATE;

reg[15:0] opcode = NOP;
reg[15:0] state = INIT;

reg[15:0] pc_dump;
reg[15:0] state_dump;
reg[15:0] opcode_dump;
reg[15:0] rom_dump;
assign out1 = pc_dump;
assign out2 = state_dump;
assign out3 = opcode_dump;
assign out4 = rom_dump;

always_ff @( posedge clock ) begin
	pc_dump <= pc;
	state_dump <= state;
	opcode_dump <= opcode;
	rom_dump <= q_rom;
end

always_ff @( posedge clock ) begin
	if ( state == ERROR ) begin
	end
	if ( state == INIT ) begin
		pc <= 16'b0;
		state <= FETCH;
		wren <= 0;
	end
	else if ( state == WAIT_FETCHING) begin
		pc <= pc + 16'b1;
		state <= FETCH;
		wren <= 0;
	end
	else if ( state == FETCH ) begin
		state <= READY;
		wren <= 0;
	end
	else begin
		if ( state == READY ) begin
			opcode = q_rom;
		end
		case ( opcode )
			NOP: begin
				if ( state == READY ) begin
					state <= WAIT_FETCHING;
				end
			end
			JMP: begin
				if ( state == READY ) begin
					state <= FETCH_OPERAND;
				end
				else if ( state == FETCH_OPERAND ) begin
					pc <= q_rom;
					state <= WAIT_FETCHING;
				end
			end
			IMM: begin
				if ( state == READY ) begin
					state <= FETCH_OPERAND;
					addr <= sp;
					sp <= sp + 16'b1;
				end
				else if ( state == FETCH_OPERAND ) begin
					state <= FETCH;
					pc <= pc + 16'b1;
					data <= q_rom;
					wren <= 1;
				end
			end
			default: begin
				state <= ERROR;
			end
		endcase
	end
end

endmodule
