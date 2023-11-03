module DAC7611(
	input clk,
	input dat1,
	input dat2,
	input leb,
	input rst_b
);

reg [11:0] serial_buff_1;
reg [11:0] serial_buff_2;
reg [11:0] sample_latch_1;
reg [11:0] sample_latch_2;
wire [11:0] sample_1 = leb ? sample_latch_1 : serial_buff_1;
wire [11:0] sample_2 = leb ? sample_latch_2 : serial_buff_2;

reg sample_clock;

always #18.14 sample_clock <= (sample_clock === 1'b0);

integer sample_count;
integer fhandle;
initial begin
	sample_clock = 1'b0;
`ifndef IVERILOG
	fhandle = $fopen("samples.bin", "w");
	$fwrite(fhandle, "bbbb");
	$fflush();
	$fclose(fhandle);
`endif
	sample_count = 0;
end

always @(posedge clk or negedge rst_b) begin
	if(rst_b) begin
		serial_buff_1 <= {serial_buff_1[10:0], dat1};
		serial_buff_2 <= {serial_buff_2[10:0], dat2};
	end else begin
		serial_buff_1 <= 12'h000;
		serial_buff_2 <= 12'h000;
	end
end

always @(posedge leb or negedge rst_b) begin
	if(rst_b) begin
		sample_latch_1 <= serial_buff_1;
		sample_latch_2 <= serial_buff_2;
	end else begin
		sample_latch_1 <= 12'h000;
		sample_latch_2 <= 12'h000;
	end
end

always @(posedge sample_clock) begin
`ifndef IVERILOG
	fhandle = $fopen("samples.bin", "a+b");
	$fwrite(fhandle, "%u", sample_latch_1);
	$fwrite(fhandle, "%u", sample_latch_2);
	$fflush();
	$fclose(fhandle);
`endif
	sample_count <= sample_count + 1;
end

endmodule
