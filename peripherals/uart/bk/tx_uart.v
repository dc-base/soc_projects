module tx_uart(
	input i_clk,
	output o_Tx,
	input i_rst,
	input reg [7:0] Data,
	input start,
	);
	parameter baud_rate = 9600; //bits per second, must be same on Tx and Rx 
	//parameter hold_len = 1000000/baud_rate; //clocks the bits are valid for. Default 100mHz i_clk
	parameter hold_len = 5;
	parameter sample = (hold_len - 1) /2;
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
			case (Tx_state)
				IDLE: begin
					clk_count <= 0;
					if (start) begin //From controller, data is valid and ready
						$display("[Tx] Sending start bit");
						Tx_state <= START;
						temp = Data; //Store data locally, so controller can prepare next byte
						clk_count = 1;
						end
					else begin
						Tx_state <= IDLE;
					end
				end
				START: begin
					if (clk_count == hold_len) begin //Hold start bit for sample period
						$display("Moving to DATA send");
						Tx_state <= DATA;
						clk_count = 1;
						data_count = 0;
					end
					else begin
						Tx_state <= START;
					end
					clk_count <= clk_count + 1;
				end
				DATA: begin
					if(data_count == 8) begin //data frame completed
						Tx_state <= STOP;
						clk_count = 1;
						o_Tx <= 1; //Sending stop bit
						//$display("Done transmitting");
						//$display("%7b", o_Data);
						end
					else if (clk_count == hold_len) begin
						clk_count = 0;
						o_Tx <= temp[7];
						temp <= temp >> 1;
						data_count = data_count + 1;
						end
					else begin
						Tx_state <= DATA;
					end
					clk_count = clk_count + 1;
				end
				STOP: begin
					if (clk_count == hold_len) begin //Finish start bit period
						$display("STOP bit recieved");
						//$display("Return to IDLE");
						Tx_state <= IDLE;
						clk_count = 0;
						data_count = 0;
					end
					else begin
						Tx_state <= STOP;
					end
					clk_count <= clk_count + 1;
				end
				default: Tx_state <= IDLE;
			endcase
		end
	end
	always @(negedge i_rst) begin
		$display("[%0t] Resetting..", $time);
		Tx_state <= IDLE;
	end 
endmodule
