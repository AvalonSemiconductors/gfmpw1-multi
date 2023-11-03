module DAC7611(
	input clk,
	input dat,
	input leb,
	input rst_b
);

reg [11:0] serial_buff;
reg [11:0] sample_latch;
wire [11:0] sample = leb ? sample_latch : serial_buff;

reg sample_clock;

always #9.07 sample_clock <= (sample_clock === 1'b0);

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
		serial_buff <= {serial_buff[10:0], dat};
	end else begin
		serial_buff <= 12'h000;
	end
end

always @(posedge leb or negedge rst_b) begin
	if(rst_b) begin
		sample_latch <= serial_buff;
	end else begin
		sample_latch <= 12'h000;
	end
end

always @(posedge sample_clock) begin
`ifndef IVERILOG
	fhandle = $fopen("samples.bin", "a+b");
	$fwrite(fhandle, "%u", sample_latch);
	$fflush();
	$fclose(fhandle);
`endif
	sample_count <= sample_count + 1;
end

endmodule
