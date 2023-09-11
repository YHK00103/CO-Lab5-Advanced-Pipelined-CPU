//0713216

module Comparator(
    src1_i,
	src2_i,
    instruction_i,
	compare_o
	);
     
//I/O ports
input  [32-1:0]   src1_i;
input  [32-1:0]	 src2_i;
input  [6-1:0]     instruction_i;
output          	 compare_o;

//Internal Signals
wire    	 compare_o;

//Parameter

//beq <= 000 100
//bne <= 000 101
//bge <= 000 001
//bgt <= 000 111
    
//Main function
 assign compare_o = ((instruction_i == 6'b000100) && (src1_i == src2_i)) ? 1'b1 :                                                   //beq
                                  ((instruction_i == 6'b000101) && (src1_i != src2_i)) ? 1'b1 :                                                    //bne
                                  ((instruction_i == 6'b000111) && (src1_i > src2_i)) ? 1'b1 :                                                      //bgt
                                  ((instruction_i == 6'b000001) && ((src1_i > src2_i) || (src1_i == src2_i))) ? 1'b1 : 1'b0;          //bge

endmodule





                    
                    