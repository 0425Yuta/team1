module CLOCK
#(
	parameter [15:0] SPLIT = 1
)
(
	input wire master,
	input wire clear,
	output reg out
);

logic[15:0] count = 15'b1;

always_ff @( posedge master or posedge clear ) begin
	if ( clear ) begin
		count <= 15'b1;
	end
	else if ( count == SPLIT ) begin
		count <= 15'b1;
		out <= ~out;
	end
	else begin
		count <= count + 15'b1;
	end
end

endmodule
