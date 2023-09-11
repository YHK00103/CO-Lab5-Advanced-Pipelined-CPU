//0713216

//Subject:     CO project 2 - Forwarding_unit
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/17
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
     
module Forwarding_unit(
    instruction_i,
    IF_ID_Rs_i,
    IF_ID_Rt_i,
    ID_EX_RegWrite_i,
    ID_EX_Rs_i,
    ID_EX_Rt_i,
    ID_EX_Rd_i,
    EX_MEM_RegWrite_i,
    EX_MEM_Rd_i,    
	MEM_WB_RegWrite_i,
    MEM_WB_Rd_i,
	Forward_A_o,
    Forward_B_o,
    Forward_C_o,
    Forward_D_o
	);
     
//I/O ports
input  [6-1:0]  instruction_i;
input  [5-1:0]  IF_ID_Rs_i;
input  [5-1:0]  IF_ID_Rt_i;
input  [1-1:0]  ID_EX_RegWrite_i;
input  [5-1:0]  ID_EX_Rs_i;
input  [5-1:0]  ID_EX_Rt_i;
input  [5-1:0]  ID_EX_Rd_i;
input  [1-1:0]  EX_MEM_RegWrite_i;
input  [5-1:0]  EX_MEM_Rd_i;
input  [1-1:0]  MEM_WB_RegWrite_i;
input  [5-1:0]  MEM_WB_Rd_i;

output [2-1:0]  Forward_A_o;
output [2-1:0]  Forward_B_o;
output [2-1:0]  Forward_C_o;
output [2-1:0]  Forward_D_o;


//Internal Signals
wire [2-1:0]  Forward_A_o;
wire [2-1:0]  Forward_B_o;
wire [2-1:0]  Forward_C_o;
wire [2-1:0]  Forward_D_o;

//Parameter
//beq <= 000 100
//bne <= 000 101
//bge <= 000 001
//bgt <= 000 111
    
//Main function
//EX hazard
//MEM hazard
assign Forward_A_o = ((EX_MEM_RegWrite_i == 1'b1) && (EX_MEM_Rd_i != 5'd0) && (EX_MEM_Rd_i == ID_EX_Rs_i)) ? 2'b10 :                                       //data come form MEM                      
                     ((MEM_WB_RegWrite_i == 1'b1) && (MEM_WB_Rd_i != 5'd0)                                                                                 //data come from WB
                     && ~((EX_MEM_RegWrite_i == 1'b1) && (EX_MEM_Rd_i != 1'b0) && (EX_MEM_Rd_i == ID_EX_Rs_i))
                     && (MEM_WB_Rd_i == ID_EX_Rs_i)) ? 2'b01 : 2'b00;

assign Forward_B_o = ((EX_MEM_RegWrite_i == 1'b1) && (EX_MEM_Rd_i != 5'd0) && (EX_MEM_Rd_i == ID_EX_Rt_i)) ? 2'b10 :                                       //data come from MEM 
                     ((MEM_WB_RegWrite_i == 1'b1) && (MEM_WB_Rd_i != 5'd0) 
                     && ~((EX_MEM_RegWrite_i == 1'b1) && (EX_MEM_Rd_i != 1'b0) && (EX_MEM_Rd_i == ID_EX_Rt_i))                                            //data come from WB
                     && (MEM_WB_Rd_i == ID_EX_Rt_i)) ? 2'b01 : 2'b00;

/*                     
assign Forward_C_o = ((ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 5'd0) && (ID_EX_Rd_i == IF_ID_Rs_i)) ? 2'b10 :                                       //data come form MEM                      
                     ((EX_MEM_RegWrite_i == 1'b1) && (EX_MEM_Rd_i != 5'd0)                                                                                 //data come from WB
                     && ~((ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 1'b0) && (ID_EX_Rd_i == IF_ID_Rs_i))
                     && (EX_MEM_Rd_i == IF_ID_Rs_i)) ? 2'b01 : 2'b00;
                     
assign Forward_D_o = ((ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 5'd0) && (ID_EX_Rd_i == IF_ID_Rt_i)) ? 2'b10 :                                       //data come form MEM                      
                     ((EX_MEM_RegWrite_i == 1'b1) && (EX_MEM_Rd_i != 5'd0)                                                                                 //data come from WB
                     && ~((ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 1'b0) && (ID_EX_Rd_i == IF_ID_Rt_i))
                     && (EX_MEM_Rd_i == IF_ID_Rt_i)) ? 2'b01 : 2'b00;
*/                     
/*                     
assign Forward_C_o = ((ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 5'd0) && (ID_EX_Rd_i == ID_EX_Rs_i)) ? 2'b10 :                                       //data come form MEM                      
                     ((EX_MEM_RegWrite_i == 1'b1) && (EX_MEM_Rd_i != 5'd0)                                                                                 
                     && ~((ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 1'b0) && (ID_EX_Rd_i == IF_ID_Rs_i))
                     && (EX_MEM_Rd_i == IF_ID_Rs_i)) ? 2'b01 : 2'b00;
                     
assign Forward_D_o = ((ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 5'd0) && (ID_EX_Rd_i == ID_EX_Rt_i)) ? 2'b10 :                                       //data come form MEM                      
                     ((EX_MEM_RegWrite_i == 1'b1) && (EX_MEM_Rd_i != 5'd0)                                                                                 
                     && ~((ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 1'b0) && (ID_EX_Rd_i == IF_ID_Rt_i))
                     && (EX_MEM_Rd_i == IF_ID_Rt_i)) ? 2'b01 : 2'b00;
*/
                     
assign Forward_C_o = (((instruction_i == 6'b000100) || (instruction_i == 6'b000101) || (instruction_i == 6'b000001) || (instruction_i == 6'b000111))         //data come from EX z>> bramch
                                     && (ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 5'd0) && (ID_EX_Rd_i == IF_ID_Rs_i)) ? 2'b10 :  
                                     (((instruction_i == 6'b000100) || (instruction_i == 6'b000101) || (instruction_i == 6'b000001) || (instruction_i == 6'b000111))        //data come from MEM >> branch
                                     && (EX_MEM_RegWrite_i == 1'b1) && (EX_MEM_Rd_i != 5'd0)                                                                                 
                                     && ~((ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 1'b0) && (ID_EX_Rd_i == IF_ID_Rs_i))
                                     && (EX_MEM_Rd_i == IF_ID_Rs_i)) ? 2'b01 : 2'b00;
                     
assign Forward_D_o = (((instruction_i == 6'b000100) || (instruction_i == 6'b000101) || (instruction_i == 6'b000001) || (instruction_i == 6'b000111))         //data come from EX >> branch
                                     && (ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 5'd0) && (ID_EX_Rd_i == IF_ID_Rt_i)) ? 2'b10 :
                                     (((instruction_i == 6'b000100) || (instruction_i == 6'b000101) || (instruction_i == 6'b000001) || (instruction_i == 6'b000111))         //data come from MEM >> branch
                                     && (EX_MEM_RegWrite_i == 1'b1) && (EX_MEM_Rd_i != 5'd0)                                                                                 
                                     && ~((ID_EX_RegWrite_i == 1'b1) && (ID_EX_Rd_i != 1'b0) && (ID_EX_Rd_i == IF_ID_Rt_i))
                                     && (EX_MEM_Rd_i == IF_ID_Rt_i)) ? 2'b01 : 2'b00;

endmodule   
          
          