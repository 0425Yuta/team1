
module ROM (
	clk,
	reset,
	avs_writedata,
	avs_burstcount,
	avs_readdata,
	avs_address,
	avs_waitrequest,
	avs_write,
	avs_read,
	avs_byteenable,
	avs_readdatavalid);	

	input		clk;
	input		reset;
	input	[31:0]	avs_writedata;
	input	[2:0]	avs_burstcount;
	output	[31:0]	avs_readdata;
	input	[15:0]	avs_address;
	output		avs_waitrequest;
	input		avs_write;
	input		avs_read;
	input	[3:0]	avs_byteenable;
	output		avs_readdatavalid;
endmodule
