`timescale 1ns / 1 ns

module main;
reg i_clk;
reg i_rst;
reg i_Rx;
wire [7:0] o_Data;


parameter clk_rate = 1000000;
parameter baud_rate = 9600;
parameter hold_len = 5000;
//parameter hold_len = clk_rate/baud_rate;


rx_uart test(i_clk, i_Rx, i_rst, o_Data);
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
	#1000
	i_rst = 1;
	#100000000000000000000
	$finish;
end

//task drive0;
//	$display("[%0t] Driving 0", $time);
//	i_Rx = 0;
//	#9000
//endtask
//task drive1;
//	begin
//	$display("[%0t] Driving 1", $time);
//	i_Rx = 1;
//	#(hold_len)
//	end
//endtask

initial begin
	#1000
	active = 1;
	//H
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	$display("Output is: [%c]", o_Data);
	t0=o_Data;
	i_Rx = 1; //STOP
	#(hold_len)
	//e
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1; //STOP
	#(hold_len)
	$display("Output is: [%c]", o_Data);
	t1=o_Data;
	//l
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1; //STOP
	#(hold_len)
	$display("Output is: [%c]", o_Data);
	t2=o_Data;
	//l
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1; //STOP
	#(hold_len)
	$display("Output is: [%c]", o_Data);
	t3=o_Data;
	//o
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1; //STOP
	#(hold_len)
	$display("Output is: [%c]", o_Data);
	t4=o_Data;


	//space
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1; //STOP
	#(hold_len)
	$display("Output is: [%c]", o_Data);
	t5=o_Data;
	//W
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1; //STOP
	#(hold_len)
	$display("Output is: [%c]", o_Data);
	t6=o_Data;
	//o
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1; //STOP
	#(hold_len)
	$display("Output is: [%c]", o_Data);
	t7=o_Data;
	//r
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1; //STOP
	#(hold_len)
	$display("Output is: [%c]", o_Data);
	t8=o_Data;
	//l
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1; //STOP
	#(hold_len)
	$display("Output is: [%c]", o_Data);
	t9=o_Data;
	//d
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1; //STOP
	#(hold_len)
	$display("Output is: [%c]", o_Data);
	t10=o_Data;
	//!
	i_Rx = 0; //Start bit
	#(hold_len)
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 0;
	#(hold_len);
	i_Rx = 1; //STOP
	#(hold_len)
	$display("Output is: [%c]", o_Data);
	t11=o_Data;
	result = {t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11};
	$display("%s", result);
	$finish;
end

always @(posedge i_clk) begin
	if(active) begin
		clks = clks + 1;
	end
end

	
endmodule
	
	
