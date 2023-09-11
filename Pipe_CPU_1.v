//0713216

`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire  [31:0] MUX1_out;
wire  [31:0] PC_out;
wire  [63:0] IF_ID_in;

/**** ID stage ****/
wire [63:0]   IF_ID_out;
wire [119:0] ID_EX_in;
wire [8:0]     MUX2_out;
wire [8:0]     Control_out;
wire [31:0]   shifter_out;
wire [31:0]   Adder2_out;
wire [31:0]   sign_extend_out;
wire [31:0]     RS_data_out;
wire [31:0]     RT_data_out;
wire [31:0]     MUX8_out;
wire [31:0]     MUX9_out;

//control signal
wire            Branch_out;
wire            IF_keep;
wire            IF_flush;
wire            PC_keep;
wire            ID_flush;


/**** EX stage ****/
wire [119:0] ID_EX_out;
wire [72:0]   EX_MEM_in;
wire [31:0]   MUX3_out;
wire [31:0]   MUX4_out;
wire [31:0]   MUX5_out;
wire [4:0]     MUX6_out;


//control signal
wire [3:0]  ALU_control_output;
wire          Compare;
wire [1:0]  Forward_A;
wire [1:0]  Forward_B;
wire [1:0]  Forward_C;
wire [1:0]  Forward_D;


/**** MEM stage ****/
wire [72:0] EX_MEM_out;
wire [70:0] MEM_WB_in;


//control signal


/**** WB stage ****/
wire [70:0] MEM_WB_out;
wire [31:0] MUX7_out;


//control signal


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux1(
	    .data0_i(IF_ID_in[63:32]),
        .data1_i(Adder2_out),
        .select_i(Branch_out & Compare),
        .data_o(MUX1_out)
);

ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i(rst_i),     
        .PC_Keep_i(PC_keep),
	    .pc_in_i(MUX1_out), 
	    .pc_out_o(PC_out)
);

Instruction_Memory IM(
		.addr_i(PC_out),  
	    .instr_o(IF_ID_in[31:0])    
);
			
Adder Adder1(               
		.src1_i(32'd4),     
	    .src2_i(PC_out),     
	    .sum_o(IF_ID_in[63:32]) 
);

		
IF_ID_Pipe_Reg #(.size(64)) IF_ID(       
	  .clk_i(clk_i),
      .rst_i(rst_i),
      .IF_Keep_i(IF_keep),
      .IF_Flush_i(IF_flush),
      .data_i(IF_ID_in),
      .data_o(IF_ID_out)
);



//Instantiate the components in ID stage
MUX_2to1 #(.size(9)) Mux2(
	    .data0_i(Control_out[8:0]),
        .data1_i(9'd0),
        .select_i(ID_flush),
        .data_o(MUX2_out[8:0])
);

Adder Adder2(               
		.src1_i(IF_ID_out[63:32]),     
	    .src2_i(shifter_out),     
	    .sum_o(Adder2_out) 
);

Shift_Left_Two_32 Shifter(
        .data_i(ID_EX_in[46:15]),
        .data_o(shifter_out)
);

Reg_File RF(
		.clk_i(clk_i),      
	    .rst_i(rst_i) , 
        .RSaddr_i(IF_ID_out[25:21]) ,  
        .RTaddr_i(IF_ID_out[20:16]) ,  
        .RDaddr_i(MEM_WB_out[4:0]) ,  
        .RDdata_i(MUX7_out)  , 
        .RegWrite_i (MEM_WB_out[70]),
        .RSdata_o(RS_data_out) ,  
        .RTdata_o(RT_data_out)  
);

Comparator Com(
        .src1_i(ID_EX_in[110:79]),
	    .src2_i(ID_EX_in[78:47]),
        .instruction_i(IF_ID_out[31:26]),
	    .compare_o(Compare)
);

Decoder Control(
        .instr_op_i(IF_ID_out[31:26]), 
        .Compare_i(Compare),
       
        .RegWrite_o(Control_out[8]),
        .MemtoReg_o(Control_out[7]),
        
        .Branch_o(Branch_out),
        .MemRead_o(Control_out[6]),
        .MemWrite_o(Control_out[5]),
         
        .ALUSrc_o(Control_out[4]), 
	    .RegDst_o(Control_out[3]),
        .ALU_op_o(Control_out[2:0])
);

Sign_Extend Sign_Extend(
         .data_i(IF_ID_out[15:0]),
        .data_o(ID_EX_in[46:15])
);	

assign ID_EX_in[119:111] = MUX2_out[8:0];
assign ID_EX_in[110:79] = MUX8_out[31:0];
assign ID_EX_in[78:47] = MUX9_out[31:0];
assign ID_EX_in[14:0] = IF_ID_out[25:11];

Pipe_Reg #(.size(120)) ID_EX(
      .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(ID_EX_in),
      .data_o(ID_EX_out)
);

Hazard_detection_unit hazard_detection_unit(
    .Branch_i(Branch_out),
    .Compare_i(Compare),
    .ID_EX_MemRead_i(ID_EX_out[117]),
    .ID_EX_Rt_i(ID_EX_out[9:5]),
    .IF_ID_Rs_i(IF_ID_out[25:21]),
    .IF_ID_Rt_i(IF_ID_out[20:16]),
	.PC_Keep_o(PC_keep),
    .IF_Flush_o(IF_flush),
    .IF_Keep_o(IF_keep),
    .ID_Flush_o(ID_flush)
);

MUX_3to1 Mux8(
        .data0_i(RS_data_out),
        .data1_i(MEM_WB_in[68:37]),
        .data2_i(EX_MEM_in[68:37]),
        .select_i(Forward_C),
        .data_o(MUX8_out[31:0])
);

MUX_3to1 Mux9(
        .data0_i(RT_data_out),
        .data1_i(MEM_WB_in[68:37]),
        .data2_i(EX_MEM_in[68:37]),
        .select_i(Forward_D),
        .data_o(MUX9_out[31:0])
);


//Instantiate the components in EX stage	   
ALU ALU(
        .src1_i(MUX3_out),
        .src2_i(MUX5_out),
        .ctrl_i(ALU_control_output),
        .result_o(EX_MEM_in[68:37])
);
		
ALU_Ctrl ALU_Control(
        .funct_i(ID_EX_out[20:15]),   
        .ALUOp_i(ID_EX_out[113:111]),   
        .ALUCtrl_o(ALU_control_output) 
);

MUX_3to1 Mux3(
        .data0_i(ID_EX_out[110:79]),
        .data1_i(MUX7_out),
        .data2_i(EX_MEM_out[68:37]),
        .select_i(Forward_A),
        .data_o(MUX3_out)
);

MUX_3to1 Mux4(
        .data0_i(ID_EX_out[78:47]),
        .data1_i(MUX7_out),
        .data2_i(EX_MEM_out[68:37]),
        .select_i(Forward_B),
        .data_o(MUX4_out)
);

MUX_2to1 #(.size(32)) Mux5(
        .data0_i(MUX4_out),
        .data1_i(ID_EX_out[46:15]),
        .select_i(ID_EX_out[115]),
        .data_o(MUX5_out)
);
		
MUX_2to1 #(.size(5)) Mux6(
        .data0_i(ID_EX_out[9:5]),
        .data1_i(ID_EX_out[4:0]),
        .select_i(ID_EX_out[114]),
        .data_o(EX_MEM_in[4:0])
);

assign EX_MEM_in[72:69] = ID_EX_out[119:116];
assign EX_MEM_in[36:5] = MUX4_out[31:0];

Pipe_Reg #(.size(73)) EX_MEM(
      .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(EX_MEM_in),
      .data_o(EX_MEM_out)
);

Forwarding_unit forwarding_unit(
    .instruction_i(IF_ID_out[31:26]),
    .IF_ID_Rs_i(IF_ID_out[25:21]),
    .IF_ID_Rt_i(IF_ID_out[20:16]),
    .ID_EX_RegWrite_i(ID_EX_out[119]),
    .ID_EX_Rs_i(ID_EX_out[14:10]),
    .ID_EX_Rt_i(ID_EX_out[9:5]),
    .ID_EX_Rd_i(EX_MEM_in[4:0]),
    .EX_MEM_RegWrite_i(EX_MEM_out[72]),
    .EX_MEM_Rd_i(EX_MEM_out[4:0]),    
    .MEM_WB_RegWrite_i(MEM_WB_out[70]),
    .MEM_WB_Rd_i(MEM_WB_out[4:0]),
    .Forward_A_o(Forward_A),
    .Forward_B_o(Forward_B),
    .Forward_C_o(Forward_C),
    .Forward_D_o(Forward_D)
);

/*
Forwarding_unit forward_unit(
     .ID_EX_Rs_i(ID_EX_out[14:10]),
     .ID_EX_Rt_i(ID_EX_out[9:5]),
     .EX_MEM_RegWrite_i(EX_MEM_out[72]),
     .EX_MEM_Rd_i(EX_MEM_out[4:0]),    
     .MEM_WB_RegWrite_i(MEM_WB_out[70]),
     .MEM_WB_Rd_i(MEM_WB_out[4:0]),
     .Forward_A_o(Forward_A),
     .Forward_B_o(Forward_B)
);
*/

//Instantiate the components in MEM stage
Data_Memory DM(
         .clk_i(clk_i), 
        .addr_i(EX_MEM_out[68:37]),
        .data_i(EX_MEM_out[36:5]),
        .MemRead_i(EX_MEM_out[70]),
        .MemWrite_i(EX_MEM_out[69]),
        .data_o(MEM_WB_in[68:37])
);

assign MEM_WB_in[70:69] = EX_MEM_out[72:71];
assign MEM_WB_in[36:5] = EX_MEM_out[68:37];
assign MEM_WB_in[4:0] = EX_MEM_out[4:0];

Pipe_Reg #(.size(71)) MEM_WB(
      .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(MEM_WB_in),
      .data_o(MEM_WB_out)
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux7(
        .data0_i(MEM_WB_out[36:5]),
        .data1_i(MEM_WB_out[68:37]),
        .select_i(MEM_WB_out[69]),
        .data_o(MUX7_out)
);

/****************************************
signal assignment
****************************************/

endmodule

