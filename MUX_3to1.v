//0713216

//Subject:     CO project 2 - MUX 321
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/17
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
     
module MUX_3to1(
               data0_i,
               data1_i,
               data2_i,
               select_i,
               data_o
               );
			
//I/O ports               
input   [32-1:0] data0_i;          
input   [32-1:0] data1_i;
input   [32-1:0] data2_i;
input   [1:0]    select_i;

output  [32-1:0] data_o; 

//Internal Signals
wire     [32-1:0] data_o;

//Main function
assign data_o = (select_i == 2'b00) ?  data0_i : 
                           (select_i == 2'b01) ? data1_i :
                           (select_i == 2'b10) ? data2_i : 32'bx;     

endmodule      
          
          