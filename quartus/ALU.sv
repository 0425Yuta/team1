module ALU(
	input  wire clock,
	output wire[15:0] address_ram,
	input  wire[15:0] q_ram,
	output wire wren_ram,
	output wire[15:0] data_ram,
	output wire[15:0] address_rom,
	input  wire[15:0] q_rom,

  output wire[15:0] SEG1,
  output wire[15:0] SEG2,
	
	output wire[15:0] out1,
	output wire[15:0] out2,
	output wire[15:0] out3,
	output wire[15:0] out4,
	output wire[15:0] out5,
	output wire[15:0] out6
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

typedef enum bit[15:0] {
	NOP = 16'h0000,
	JMP = 16'h1000,
	IMM = 16'h0002,
	ADD = 16'h2000,
	SUB = 16'h2001
} OPCODE;
OPCODE opcode = NOP;

enum bit[15:0] {
	INIT,
	WAIT_FETCHING,
	FETCH,
	READY,
	FETCH_OPERAND,
	WAIT_FETCHING_OPERAND,
	WAIT_FETCHING_OPERAND2,
	WAIT_FETCHING_STACK,
	FETCH_STACK1,
	FETCH_STACK2,
	ERROR = 16'hffff
} state = INIT;

reg[15:0] seg1;
reg[15:0] seg2;
assign SEG1 = seg1;
assign SEG2 = seg2;

reg[15:0] pc_dump;
reg[15:0] state_dump;
reg[15:0] opcode_dump;
reg[15:0] rom_dump;
reg[15:0] sp_dump;
reg[15:0] addr_dump;
assign out1 = pc_dump;
assign out2 = state_dump;
assign out3 = opcode_dump;
assign out4 = rom_dump;
assign out5 = sp_dump;
assign out6 = addr_dump;

always_ff @( posedge clock ) begin
	pc_dump <= pc;
	state_dump <= state;
	opcode_dump <= opcode;
	rom_dump <= q_rom;
	sp_dump <= sp;
	addr_dump <= addr;
end

reg[15:0] arg1;
reg[15:0] arg2;

always_ff @( posedge clock ) begin
	case ( state )
		ERROR: begin
		end
		INIT: begin
			pc <= 16'b0;
			state <= FETCH;
			wren <= 0;
		end
		WAIT_FETCHING: begin
			state <= FETCH;
		end
		FETCH: begin
			state <= READY;
			wren <= 0;
		end
		default: begin
			if ( state == READY ) begin
				opcode = OPCODE'(q_rom);
			end
			case ( opcode )
				NOP: begin
					case ( state )
						READY: begin
							pc <= pc + 16'b1;
							state <= WAIT_FETCHING;
						end
					endcase
				end
				JMP: begin
					case ( state )
						READY: begin
							pc <= pc + 16'b1;
							state <= WAIT_FETCHING_OPERAND;
						end
						WAIT_FETCHING_OPERAND: begin
							state <= WAIT_FETCHING_OPERAND2;
						end
						WAIT_FETCHING_OPERAND2: begin
							state <= FETCH_OPERAND;
						end
						FETCH_OPERAND: begin
							pc <= q_rom;
							state <= WAIT_FETCHING;
						end
					endcase
				end
				IMM: begin
					case ( state )
						READY: begin
							state <= WAIT_FETCHING_OPERAND;
							pc <= pc + 16'b1;
						end
						WAIT_FETCHING_OPERAND: begin
							state <= WAIT_FETCHING_OPERAND2;
						end
						WAIT_FETCHING_OPERAND2: begin
							state <= FETCH_OPERAND;
						end
						FETCH_OPERAND: begin
							state <= WAIT_FETCHING;
							pc <= pc + 16'b1;
							sp <= sp + 16'b1;
							addr <= sp;
							data <= q_rom;
							wren <= 1;
						end
					endcase
				end
				ADD, SUB: begin
					case ( state )
						READY: begin
							addr <= sp - 16'h1;
							wren <= 0;
							state <= WAIT_FETCHING_STACK;
						end
						WAIT_FETCHING_STACK: begin
							state <= FETCH_STACK1;
							addr <= sp - 16'h2;
						end
						FETCH_STACK1: begin
							state <= FETCH_STACK2;
							arg1 <= q_ram;
						end
						FETCH_STACK2: begin
							sp <= sp - 16'h1;
							pc <= pc + 16'b1;
							addr <= sp - 16'h2;
							case ( opcode )
								ADD: begin
									data <= arg1 + q_ram;
									seg1 <= arg1 + q_ram;
								end
								SUB: begin
									data <= arg1 - q_ram;
									seg1 <= arg1 - q_ram;
								end
							endcase
							wren <= 1;
							state <= WAIT_FETCHING;
						end
					endcase
				end
				default: begin
					state <= ERROR;
				end
			endcase
		end
	endcase
end

endmodule
