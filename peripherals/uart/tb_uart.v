`timescale 1ns / 1 ns

module main;
reg i_clk;
reg i_rst;
reg i_Rx;
reg [3:0] sel_baud;
wire [7:0] o_Data;


parameter clk_rate = 1000000;
parameter baud_rate = 9600;
//parameter hold_len = 5000;
parameter hold_len = clk_rate/baud_rate*1000;


rx_uart test(i_clk, i_rst, sel_baud, i_Rx, o_Data);
//100mHz, 1000ns period
always #500 i_clk = ~i_clk; 


reg [7:0] clks;
reg active;
reg [95:0] result;
reg [7:0] t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12;
initial begin
	$dumpfile("dump.vcd");
	$dumpvars(0, main);
end
initial begin
	clks = 0;
	active = 0;
	i_clk = 0;
	i_rst = 0;
	i_Rx = 1;
	sel_baud = 0;
	#1000
	i_rst = 1;
	#100000000000000000000
	$finish;
end

task drive(input val);
	begin
		//$display("[%0t] Driving %0b", $time, val);
		i_Rx = val;
		#(hold_len);
	end
endtask

task stop;
	begin
		drive(1);
		//$display("Sending STOP bit");
	end
endtask

task start;
	begin
		drive(0);
		//$display("Sending START bit");
	end
endtask
task sendByte(input [7:0] c);
	begin
		//$display("Sending: %c", c);
		start();
		for(integer i = 0; i < 8; i=i+1) begin
			//$display("Sending bit");
			drive(c[i]);
		end
		stop();
		$display("Recieved: %c", o_Data);
	end
endtask

initial begin
	#1000
	active = 1;
	sendByte("A");
	sendByte("B");
	sendByte("C");
	sendByte("D");
	$finish;
end

always @(posedge i_clk) begin
	if(active) begin
		clks = clks + 1;
	end
end

	
endmodule
	
	
