module sprites_extra_store (
	input clk,
	input ce,

	input reset,

	input save_x,
	input [7:0] xpos,

	input tile_save,
	input [7:0] tile0_in,
	input [7:0] tile1_in,
	input [3:0] index_in,
	input [2:0] cgb_pal_in,
	input pal_in,
	input prio_in,

	output x_match,

	output [7:0] tile0_o,
	output [7:0] tile1_o,
	output [2:0] cgb_pal_o,
	output [3:0] index_o,
	output pal_o,
	output prio_o
);

reg [7:0] x;
reg [7:0] tile0;
reg [7:0] tile1;
reg [2:0] cgb_pal;
reg [3:0] index;
reg pal;
reg prio;

always @(posedge clk) begin
	if (ce) begin
		if (reset) begin
			x <= 8'hFF;
			tile0 <= 8'd0;
			tile1 <= 8'd0;
		end else begin
			if (save_x) begin
				x <= xpos;
			end

			if (tile_save) begin
				tile0   <= tile0_in;
				tile1   <= tile1_in;
				pal     <= pal_in;
				prio    <= prio_in;
				cgb_pal <= cgb_pal_in;
				index   <= index_in;
			end
		end
	end
end

assign x_match = (xpos == x);

// karabas: 0 instead of Z when not matching, the parent ORs the stores (no internal tristates for XST)
assign tile0_o   = x_match ? tile0   : 8'h00;
assign tile1_o   = x_match ? tile1   : 8'h00;
assign pal_o     = x_match ? pal     : 1'b0;
assign prio_o    = x_match ? prio    : 1'b0;
assign cgb_pal_o = x_match ? cgb_pal : 3'h0;
assign index_o   = x_match ? index   : 4'h0;

endmodule