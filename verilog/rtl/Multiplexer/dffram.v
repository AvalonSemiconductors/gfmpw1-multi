`default_nettype none

module dffram(
	input CLK,
	input CEN,
	input GWEN,
	input [7:0] WEN,
	input [5:0] A,
	input [7:0] D,
	output [7:0] Q
);

reg [7:0] data [63:0];

wire [7:0] data_at = data[A];
assign Q = data_at;

always @(posedge CLK) begin
	if(!CEN && !GWEN) begin
		data[A] <= (WEN & data_at) | ((~WEN) & D);
	end
end

endmodule
