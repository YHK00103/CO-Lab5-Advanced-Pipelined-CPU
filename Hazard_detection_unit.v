//0713216

//Subject:     CO project 2 - Hazard_detection_unit
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Hazard_detection_unit(
    Branch_i,
    Compare_i,
    ID_EX_MemRead_i,
    ID_EX_Rt_i,
    IF_ID_Rs_i,
    IF_ID_Rt_i,
	PC_Keep_o,
    IF_Flush_o,
    IF_Keep_o,
    ID_Flush_o
	);
     
//I/O ports 
input           Branch_i;
input           Compare_i;
input           ID_EX_MemRead_i;
input  [5-1:0]  ID_EX_Rt_i;
input  [5-1:0]  IF_ID_Rs_i;
input  [5-1:0]  IF_ID_Rt_i;


output   PC_Keep_o;
output   IF_Flush_o;
output   IF_Keep_o;
output   ID_Flush_o;

//Internal Signals
wire   PC_Keep_o;
wire   IF_Flush_o;
wire   IF_Keep_o;
wire   ID_Flush_o;

//Parameter
    
//Main function
//Control hazard
assign IF_Flush_o = ((Branch_i == 1'b1) && (Compare_i == 1'b1)) ? 1'b1 : 1'b0;

//Load-use hazard
assign IF_Keep_o = ((ID_EX_MemRead_i == 1'b1) && ((ID_EX_Rt_i == IF_ID_Rs_i) || (ID_EX_Rt_i == IF_ID_Rt_i))) ? 1'b1 : 1'b0;
assign PC_Keep_o = ((ID_EX_MemRead_i == 1'b1) && ((ID_EX_Rt_i == IF_ID_Rs_i) || (ID_EX_Rt_i == IF_ID_Rt_i))) ? 1'b1 : 1'b0;
assign ID_Flush_o = ((ID_EX_MemRead_i == 1'b1) && ((ID_EX_Rt_i == IF_ID_Rs_i) || (ID_EX_Rt_i == IF_ID_Rt_i))) ? 1'b1 : 1'b0;

endmodule





                    
                    