module FSM(Input,en,clr,clk,Output);
input [2:0] Input;
input en,clr,clk;
output reg [5:0] Output;
reg [3:0] state, NS;
reg [18:0] count_reg = 0;//counter for the clock divider
reg out100 = 0;//output from the clock divider to change the states

parameter [3:0] S0 = 4'b0000, S1 = 4'b0001,S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100, S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111, S8 = 4'b1000, S9 = 4'b1001, S10 = 4'b1010, S11 = 4'b1011, S12 = 4'b1100; 

//if the signal from the clock divider is active it will change the state to next state 
always@(negedge clr, posedge out100)begin 
	if(clr == 0)
		state <= S0;
	else if(en)
		state <= NS;
	end 
	
	

// clock divider that changes  50MHz clock to 100Hz
always@(posedge clk)begin
	
	if(count_reg < 499999)begin
		count_reg <= count_reg+1;
	end
	else begin
		count_reg <= 0;
		out100 <= ~out100;//once it reaches count it will set a signal to change states
	end


end

always@(state)begin 


case(state)

S0: begin//first state to set everything to 0
	Output = 6'b000000;
	NS = S1;
	end
	
	
S1: begin//state that checks to see what lights need to be on
	Output = 6'b000000;
	
	if(Input[1])
		NS = S12;
	else if(Input == 3'b001)//checks if the right signal is on
		NS = S2;
	else if(Input == 3'b100)//checks if the left signal is on
		NS = S7;
	else if(Input == 3'b101)//checks if the HAZ light is on 
		NS = S0;
	else begin
		NS = S0;
		Output = 6'b000000;
		end
	end
	
	
S2:begin 
		Output = 6'b000100;//first bit of the right signal light
		NS = S3;
	end
	
	
S3: begin //check in the state if the HAZ light has been inputed 
	Output = 6'b000100;
	if(Input[1])
		NS = S12;//go to HAZ state
	else 
		NS = S4;//go the next state check 
	end
	
	
S4: begin 
	Output = 6'b000110; //continue to change light 
	NS = S5;
	end
	
	
S5: begin
	Output = 6'b000110;//keep old value
	if(Input[1])//go to haz state
		NS = S12;
	else 
		NS = S6;
	end
	
	
S6: begin
	Output = 6'b000111;//finish the right light 
	NS = S0;
	end
	
	
S7: begin 
	Output = 6'b001000;// the start of the left light
	NS = S8;
	end
	
	
S8:begin 
	Output = 6'b001000;//keeping old value 
	if(Input[1])//check haz input 
	NS = S12;//go to haz state 
	else 
	NS = S9;
	end
	
	
S9: begin 
	Output = 6'b011000;//contineu with the left lights 
	NS = S10;
	end
	
	
S10: begin 
	Output = 6'b011000;//keep old value 
	if(Input[1])//check haz input 
	NS = S12;//go to haz state
	else 
	NS = S11;
	end
	
	
S11: begin
	Output = 6'b111000;//finish the cycle for the left light 
	NS = S0;
	end
	
	
S12: begin
	Output = 6'b111111;// haz state will keep flashing and going back to 
	NS = S0;
	end
	
	
default:begin 
	NS <= S0;
	Output <= 6'b000000;
end

endcase
	
end


endmodule


