/*
 * This is the interface to the external DAC (DAC7611)
 *
 * Outputs LE, CLK and DATA signals for the SPI link
*/

`default_nettype none

module spi_dac_i_2(
	input [11:0] sample_in,
	
	input clk,
	input rst,
	
	output reg spi_le,
	output reg spi_clk,
	output reg spi_dat,
	input sample_ready
);

reg [11:0] spi_dat_buff;
reg [5:0] counter;

always @(posedge clk) begin
	if(rst) begin
		spi_le <= 1;
		spi_clk <= 0;
		spi_dat <= 0;
		counter <= 0;
		spi_dat_buff <= 0;
	end else begin
		//DAC7611 mode
		if(counter[4] && counter[3]) begin
			//Load next sample & reset counter
			spi_dat_buff <= sample_in;
			if(sample_ready) counter <= 0;
			spi_clk <= 0;
			//Pulse LEb
			spi_le <= 0;
		end else begin
			spi_le <= 1;
			counter <= counter + 1;
			if(counter[0]) begin
				//Clock in current bit
				spi_clk <= 1;
			end else begin
				//Shift out next bit
				spi_dat <= spi_dat_buff[11];
				spi_dat_buff <= {spi_dat_buff[10:0], 1'b0};
				spi_clk <= 0;
			end
		end
	end
end

endmodule
