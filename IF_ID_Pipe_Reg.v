//0713216

`timescale 1ns / 1ps
//Subject:     CO project 4 - IF_ID_Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module IF_ID_Pipe_Reg(
    clk_i,
    rst_i,
    IF_Keep_i,
    IF_Flush_i,
    data_i,
    data_o
    );
					
parameter size = 0;

input   clk_i;		  
input   rst_i;
input   IF_Keep_i;
input   IF_Flush_i;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if(~rst_i)
        data_o <= 0;
    else if(IF_Keep_i)
        data_o <= data_o;
    else if(IF_Flush_i)
        data_o <= 0;
    else
        data_o <= data_i;
end

endmodule	