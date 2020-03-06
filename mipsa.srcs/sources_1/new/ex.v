`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2020 01:50:57 PM
// Design Name: 
// Module Name: ex
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"

module ex(
    input clk,
    input rst,
    input [7:0] aluop_i,
    input [2:0] alusel_i,
    input [31:0] op1_i,
    input [31:0] op2_i,
    input [4:0] regw_addr_i,
    input regw_i,
    
    //REG HI LO///////////
    input [31:0] hi_i,
    input [31:0] lo_i,
    output reg  [31:0]hi_o,
    output reg  [31:0]lo_o,
    output reg  hiw_o,
    output reg  low_o,
    //    data coe
    input hiw_mem_i,
    input [31:0] hi_mem_i,
    input low_mem_i,
    input [31:0] lo_mem_i,
    input hiw_wb_i,
    input [31:0] hi_wb_i,
    input low_wb_i,
    input [31:0] lo_wb_i,
    ////////////////////
    input  [63:0]mul_temp_i,
    input  [16:0]cmd_loop_cnt_i,
    output reg [63:0]mul_temp_o,
    output reg [16:0]cmd_loop_cnt_o,
    ////
    output reg  [31:0]res,
    output reg  [4:0] regw_addr_o,
    output reg  regw_o,
    output reg stall_req_ex
    //
    //output reg start_div_o,
    //input [63:0]div_res_i
    );
//temp exec data
wire [31:0]HI_DATA;
wire [31:0]LO_DATA;

assign HI_DATA = hiw_mem_i? hi_mem_i:hiw_wb_i?hi_wb_i:hi_i;
assign LO_DATA = low_mem_i? lo_mem_i:low_wb_i?lo_wb_i:lo_i;


//result data type
reg [31:0] logicdata;
reg [31:0] shiftdata;
reg [31:0] movedata;
reg [31:0] arithdata;
reg [63:0] multidata;
reg [63:0] divdata;
///
// for design safety
// a specific datatype should be changed by only one block 
//
//STALL REQ LIST//////////////////
reg stall_req_mul;
always@(*)
begin
    if(!rst) begin
        stall_req_ex   <=  0;
    end
    else begin
        stall_req_ex   <=  stall_req_mul;
    end
end
//logicdata///////////////////////
always@(*)
begin
    if(!rst) begin
        logicdata<=32'b0;
    end
    else begin
        case(aluop_i)
            `EXEC_OP_OR: begin
                logicdata <= op1_i|op2_i;
            end
            `EXEC_OP_AND: begin
                logicdata <= op1_i&op2_i;
            end
            `EXEC_OP_XOR: begin
                logicdata <= op1_i^op2_i;
            end
            `EXEC_OP_NOR: begin
                logicdata <= ~(op1_i|op2_i);
            end
            default: begin
                logicdata <= 32'b0;
            end
        endcase
    end
end
//DIV TEST/////////////////////////////
always@(*)
begin
    if(!rst)begin
    divdata<=32'b0;
    end
    else begin
        case(aluop_i)
        `EXEC_OP_SLL: begin
           //start_div_o<=1;
           divdata <= {op1_i/op2_i,op1_i%op2_i};
        end
        default: begin
            shiftdata <= 32'b0;
        end
        endcase
    end
end
//shiftdata op/////////////////////////////////////
always@(*)
begin
    if(!rst)begin
    shiftdata<=32'b0;
    end
    else begin
    case(aluop_i)
    `EXEC_OP_SLL: begin
        shiftdata <= op2_i << op1_i[4:0];
    end
    `EXEC_OP_SRL: begin
        shiftdata <= op2_i >> op1_i[4:0];
    end
    `EXEC_OP_SRA: begin
        shiftdata <=  ({32{op2_i[31]}} << (6'd32 - {1'b0,op1_i[4:0]})) | (op2_i >> op1_i[4:0]);
    end
    default: begin
        shiftdata <= 32'b0;
    end
    endcase
    end
end

///arith cmd//////////////////////////////////////////////////////////////////
//add sub
wire [31:0] op2_mux=(aluop_i==`EXEC_OP_SUB||aluop_i==`EXEC_OP_SUBU||aluop_i==`EXEC_OP_SLT||aluop_i==`EXEC_OP_SLTU)? (~op2_i)+1 : op2_i;
wire [32:0] op1_s={op1_i[31],op1_i};//double sign bit
wire [32:0] op2_s={op2_mux[31],op2_mux};//
                  
wire [31:0] clzo_data = (op2_i==32'h1234abcd)?~op1_i:op1_i;

wire [32:0]addsres= op1_s + op2_s;
wire [31:0]addures= op1_i + op2_mux;
wire compare = (addsres[31]==1&&addsres[32]==1&&addsres[30:0]!=31'b0);
wire  overflow=addsres[32]^addsres[31];//双符号位判断溢出
//mul
wire [31:0]mul_op1=(aluop_i==`EXEC_OP_MUL||aluop_i==`EXEC_OP_MULT||aluop_i==`EXEC_OP_MADD||aluop_i==`EXEC_OP_MSUB||op1_i[31])? (~op1_i)+1 : op1_i;//because neg numbers were storeed in alt code, so we should transe them to ori code first
wire [31:0]mul_op2=(aluop_i==`EXEC_OP_MUL||aluop_i==`EXEC_OP_MULT||aluop_i==`EXEC_OP_MADD||aluop_i==`EXEC_OP_MSUB||op2_i[31])? (~op2_i)+1 : op2_i;
wire mul_neg=op1_i[31]^op2_i[31]; //1 neg 0 pos
wire [63:0]mulres=mul_op1*mul_op2;

//muladsub
//
//把修改数据的操作领出来统一执行
//赋值语句哪里进行不要单独操作
//multidata block///////////////////////////////////////////////////
always@(*)
begin
    if(!rst)begin
        multidata<=64'b0;
    end
    else if((aluop_i==`EXEC_OP_MUL||aluop_i==`EXEC_OP_MULT||aluop_i==`EXEC_OP_MADD||aluop_i==`EXEC_OP_MSUB)&&mul_neg) begin
        multidata<=~mulres+1;
    end
    else begin
        multidata<=mulres;
    end
end
///stall req block///////////////////////////////////////////////////////

wire [63:0]MADDU=mul_temp_i+{hi_i,lo_i};
wire [63:0]MSUBU=(~mul_temp_i+1)+{hi_i,lo_i};

//HI LO reg block/////////////////////////////////////////////////////////
always@(*)
begin
    if(!rst)begin
        hi_o<=32'b0;
        lo_o<=32'b0;
        hiw_o<=0;
        low_o<=0;
        stall_req_mul   <=  0;
        cmd_loop_cnt_o <=  16'd0;
        mul_temp_o     <=  64'b0;
    end
    else begin
        case(aluop_i)
            `EXEC_OP_MADD, `EXEC_OP_MADDU:begin
                if(cmd_loop_cnt_i==0) begin
                    stall_req_mul   <=  1;
                    cmd_loop_cnt_o <=  16'd1;
                    mul_temp_o     <=  multidata;
                end
                else if(cmd_loop_cnt_i==16'b1) begin
                    cmd_loop_cnt_o <=  16'd2;
                    stall_req_mul   <=  0;
                    hi_o<=MADDU[63:32];
                    hiw_o<=1'b1;
                    lo_o<=MADDU[31:0];
                    low_o<=1'b1;
                end
            end
            `EXEC_OP_MSUB, `EXEC_OP_MSUBU:begin
                if(cmd_loop_cnt_i==0) begin
                    stall_req_mul   <=  1;
                    cmd_loop_cnt_o <=  16'd1;
                    mul_temp_o     <=  multidata;
                end
                else if(cmd_loop_cnt_i==16'b1) begin
                    cmd_loop_cnt_o <=  16'd2;
                    stall_req_mul   <=  0;
                    hi_o<=MSUBU[63:32];
                    hiw_o<=1'b1;
                    lo_o<=MSUBU[31:0];
                    low_o<=1'b1;
                end
            end
            `EXEC_OP_MTHI:begin
                hi_o <= op1_i;
                hiw_o <= 1'b1;
            end
            `EXEC_OP_MTLO:begin
                lo_o <= op1_i;
                low_o <=1'b1;
            end
            `EXEC_OP_MULT:begin
                hi_o<=multidata[63:32];
                lo_o<=multidata[31:0];
                hiw_o<=1;
                low_o<=1;
            end
            `EXEC_OP_MULTU:begin
                hi_o<=mulres[63:32];
                lo_o<=mulres[31:0];
                hiw_o<=1;
                low_o<=1;
            end           
            default:begin
                hi_o<=32'b0;
                lo_o<=32'b0;
                hiw_o<=0;
                low_o<=0;
                stall_req_mul   <=  0;
                cmd_loop_cnt_o <=  16'd0;
                mul_temp_o     <=  64'b0;
            end
        endcase
    end 
end

//general arithdata output//////////////////////////////////////////////////
always@(*)
begin
    if(!rst)begin
        arithdata<=32'b0;
    end
    else begin
        case(aluop_i)
            `EXEC_OP_ADD:begin
                    arithdata<=addsres;
            end
            `EXEC_OP_ADDU:begin
                    arithdata<=addures;
            end
            `EXEC_OP_SUB:begin
                    arithdata<=addsres;
            end
            `EXEC_OP_SUBU:begin
                    arithdata<=addures;
            end
            `EXEC_OP_SLT:begin
                    arithdata<=compare;
            end
            `EXEC_OP_SLTU:begin
                    arithdata<=!(addures>=0);
            end
            `EXEC_OP_CLZ:begin //looks stupid 
                    arithdata <=    clzo_data[31]?0:
                                    clzo_data[30]?1:
                                    clzo_data[29]?2:
                                    clzo_data[28]?3:
                                    clzo_data[27]?4:
                                    clzo_data[26]?5:
                                    clzo_data[25]?6:
                                    clzo_data[24]?7:
                                    clzo_data[23]?8:
                                    clzo_data[22]?9:
                                    clzo_data[21]?10:
                                    clzo_data[20]?11:
                                    clzo_data[19]?12:
                                    clzo_data[18]?13:
                                    clzo_data[17]?14:
                                    clzo_data[16]?15:
                                    clzo_data[15]?16:
                                    clzo_data[14]?17:
                                    clzo_data[13]?18:
                                    clzo_data[12]?19:
                                    clzo_data[11]?20:
                                    clzo_data[10]?21:
                                    clzo_data[9]?22:
                                    clzo_data[8]?23:
                                    clzo_data[7]?24:
                                    clzo_data[6]?25:
                                    clzo_data[5]?26:
                                    clzo_data[4]?27:
                                    clzo_data[3]?28:
                                    clzo_data[2]?29:
                                    clzo_data[1]?30:
                                    clzo_data[0]?31:32;
            end
            `EXEC_OP_MUL:begin
                    arithdata <= multidata[31:0];
            end
            default: arithdata<=32'b0;
        endcase
    end
end

//movedata output/////////////////////////////////////////////////////////
always@(*)
begin
    if(!rst)begin
        movedata<=32'b0;
    end
    else begin
    
    case(aluop_i) 
    `EXEC_OP_MOVE:begin
        movedata<=op1_i;
    end
    `EXEC_OP_MFHI:begin
        movedata<=HI_DATA;
    end
    `EXEC_OP_MFLO:begin
        movedata<=LO_DATA;
    end
    default: movedata<=32'b0;
    endcase
    end
end

////output data mux////////////////////////////////////////////////////////////////
always@(*)
begin
    if(!rst) begin
        res<= 32'b0;
    end
    else begin
        regw_o<=((aluop_i==`EXEC_OP_SUB||aluop_i==`EXEC_OP_ADD)&&(overflow))?1'b0:regw_i;
        regw_addr_o <= regw_addr_i;
        case (alusel_i)
            `EXEC_RES_LOGIC: begin
                res<= logicdata;
            end
            `EXEC_RES_SHIFT: begin
                res<= shiftdata;
            end
            `EXEC_RES_MOVE: begin
                res<= movedata;
            end
            `EXEC_RES_ARITH: begin
                res<= arithdata;
            end
            default:begin
                res<= 32'b0;               
            end
        endcase
    end
end
endmodule
