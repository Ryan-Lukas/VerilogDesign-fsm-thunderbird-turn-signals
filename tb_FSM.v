`timescale 1ns/1ps

module tb_FSM;
	reg [2:0] Input;
	reg en, clr, clk;
	reg [18:0] counter =0;
	reg [2:0] inside = 0;
	wire [5:0] Output;
	
	
	FSM UUT(.Input(Input),.en(en),.clr(clr),.clk(clk),.Output(Output));
	
	initial begin
		
		//declaring initial values
		clk = 1'b0;
		clr = 1'b0;#10
		Input = 3'b000;
		clr = 1'b1;#10
		en = 1'b1;
		
//testing the right ligt input 	
Input = 3'b001;
for(inside = 0; inside <7; inside= inside +1)begin
	clk = ~clk;
	#10;
	clk = ~clk;
	#10;
	
	if(Output == 6'b000000 || Output == 6'b000100 || Output == 6'b000110 || Output == 6'b000111)
		$display("%b",Output);
	else
		$display("error");
end

#100;
//testing left light input 
Input = 3'b100;
for(inside = 0; inside <7; inside= inside +1)begin
	clk = ~clk;
	#10;
	clk = ~clk;
	#10;
	
	if(Output == 6'b001000 || Output == 6'b011000 || Output == 6'b111000 || Output == 6'b000000)
		$display("%b",Output);
	else
		$display("error");
end

#100;
//testing haz light input
Input = 3'b010;
for(inside = 0; inside <7; inside= inside +1)begin
	clk = ~clk;
	#10;
	clk = ~clk;
	#10;
	
	if(Output == 6'b000000 || Output == 6'b111111)
		$display("%b",Output);
	else
		$display("error");
end

#100;
//testing no input 
Input = 3'b000;
for(inside = 0; inside <7; inside= inside +1)begin
	clk = ~clk;
	#10;
	clk = ~clk;
	#10;
	
	if(Output == 6'b000000)
		$display("%b",Output);
	else
		$display("error");
end

#100;
//testing to make sure it is still haz light if all three are on
Input = 3'b111;
for(inside = 0; inside <7; inside= inside +1)begin
	clk = ~clk;
	#10;
	clk = ~clk;
	#10;
	
	if(Output == 6'b000000 || Output == 6'b111111)
		$display("%b",Output);
	else
		$display("error");
end

		
		
		
		

		
		
		
	
	
	
	end
	
endmodule

	
	
	
