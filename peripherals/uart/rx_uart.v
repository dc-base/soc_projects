module rx_uart(
	input i_clk,
	input i_rst,
	input [3:0] sel_baud,
	input i_Rx,
	output reg [7:0] o_Data
	);
	integer baud_rate;
	integer hold_len;
	integer sample;
	//parameter baud_rate = 9600; //bits per second, must be same on Tx and Rx 
	//parameter hold_len = 1000000/baud_rate; //clocks the bits are valid for. Default 100mHz i_clk
	//parameter hold_len = 5;
	//parameter sample = (hold_len - 1) /2;
	parameter clk_freq = 1000000; //Need to know internal clock frequency to configure sample time 
	
	parameter IDLE = 0;
	parameter START = 1;
	parameter DATA = 2;
	parameter PARITY = 3;
	parameter STOP = 4;
	reg [7:0] temp;
	reg [2:0] Rx_state;
	reg [7:0] clk_count;
	reg [3:0] data_count;
	always @(posedge i_clk) begin
		//$display("State = %3b", Rx_state);
		if (i_rst) begin
			case (Rx_state)
				IDLE: begin
					clk_count <= 0;
					if (~i_Rx) begin //Check for Rx pulldown to start
						//$display("[%0t] Start bit recieved", $time);
						Rx_state <= START;
						o_Data = 0;
						clk_count <= 1;
						end
					else begin
						Rx_state <= IDLE;
					end
				end
				START: begin
					if (clk_count == sample) begin //check in the middle of the signal
						if(i_Rx) begin	
							Rx_state <= IDLE;
							//$display("%b i_Rx", i_Rx);
							//$display("[%0t] Sample = %d Return to Idle", $time, sample);
						end
					end
					else if (clk_count == hold_len) begin //Finish start bit period
						//$display("Moving to DATA recieve");
						Rx_state <= DATA;
						clk_count = 1;
						data_count = 0;
					end
					else begin
						Rx_state <= START;
					end
					clk_count <= clk_count + 1;
				end
				DATA: begin
					if(data_count == 8) begin //data frame completed
						Rx_state <= STOP;
						clk_count = 1;
						o_Data = temp;
						$display("Done recieving");
						//$display("%7b", o_Data);
						end
					else if (clk_count == hold_len) begin
						clk_count = 0;
						//$display("One bit complete");
						end
					else if(clk_count == sample) begin
						//$display("sampling: %b", i_Rx);
						//o_Data[7] = i_Rx; //LSB received first, MSB recieved last
						temp[7] = i_Rx; //LSB received first, MSB recieved last
						if(data_count < 7) begin
							temp  = temp >> 1; //RSH to make room for next data
						end
						data_count = data_count + 1;
						end
					else begin
						Rx_state <= DATA;
					end
					clk_count = clk_count + 1;
				end
				STOP: begin
					if (clk_count == sample) begin //check in the middle of the signal
						if(~i_Rx) begin	
							//TODO error handler
							//$display("%b i_Rx", i_Rx);
							//display("[%0t] Sample = %d Return to Idle", $time, sample);
						end
					end
					else if (clk_count == hold_len) begin //Finish start bit period
						//$display("STOP bit recieved");
						//$display("Return to IDLE");
						Rx_state <= IDLE;
						clk_count = 0;
						data_count = 0;
					end
					else begin
						Rx_state <= STOP;
					end
					clk_count <= clk_count + 1;
				end
				default: Rx_state <= IDLE;
			endcase
		end
	end
	always @(negedge i_rst) begin
		$display("[%0t] Resetting..", $time);
		case (sel_baud) 
			4'b0000: baud_rate = 9600;
			4'b0001: baud_rate = 110;
			4'b0010: baud_rate = 300;
			4'b0011: baud_rate = 600;
			4'b0100: baud_rate = 1200;
			4'b0101: baud_rate = 2400;
			4'b0110: baud_rate = 4800;
			4'b0111: baud_rate = 14400;
			4'b1000: baud_rate = 19200;
			4'b1001: baud_rate = 38400;
			4'b1010: baud_rate = 57600;
			4'b1011: baud_rate = 115200;
			4'b1100: baud_rate = 128000;
			4'b1101: baud_rate = 256000;
			default: baud_rate = 9600;
		endcase
		hold_len = clk_freq / baud_rate;
		sample = hold_len / 2;
		$display("Internal Clock frequency is %d", clk_freq);
		$display("Baud rate is %d", baud_rate);
		$display("Sampling at %d", sample);
		Rx_state <= IDLE;
	end 
endmodule
