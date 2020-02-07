`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2020 12:33:50 PM
// Design Name: 
// Module Name: id
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

module id(
    input clk,
    input rst,
    input [31:0]inst_addr_i,
    input [31:0]inst_i,
    input [31:0]reg1_i,
    input [31:0]reg2_i,
    //to solve data correlation
    input reg_ex_we,
    input reg_mem_we,
    input [31:0]reg_ex_i,
    input [31:0]reg_mem_i,
    input [4:0] reg_ex_addr_i,
    input [4:0] reg_mem_addr_i,
    ///
    output reg[4:0] reg1_addr_o,
    output reg[4:0] reg2_addr_o,
    output reg reg1_re,
    output reg reg2_re,
    
    
    output reg [7:0] aluop,
    output reg [2:0] alusel,
    
    output reg [31:0] op1,
    output reg [31:0] op2,
    
    output reg[4:0] regw_addr_o,
    output reg regw,
    
    output reg cmd_vaild
    );
reg [31:0]imm;
wire [5:0]opr = inst_i[31:26];
wire [5:0]opr2 = inst_i[10:6];
wire [5:0]opr3 = inst_i[5:0];
wire [5:0]opr4 = inst_i[20:16];

wire [5:0]rs=inst_i[25:21];
wire [5:0]rt=inst_i[20:16];
wire [5:0]rd=inst_i[15:11];



always@(*) begin
    if(!rst) begin
        reg1_addr_o<= 0;
        reg2_addr_o <= 0;
        reg1_re <= 0;
        reg2_re<= 0;
        aluop<= 0;
        alusel<= 0;
        regw_addr_o<= 0;
        regw <= 0;
        cmd_vaild<=0;
    end
    else begin
        reg1_addr_o <= inst_i[25:21];
        reg2_addr_o <= inst_i[20:16];
        reg1_re <= 0;
        reg2_re <= 0;
        aluop  <= 0;
        alusel <= 0;
        regw_addr_o <= 0;
        regw <= 0;    
        imm <=0;
        case(opr) 
            `EXEC_ORI:begin
                reg1_re <= 1'b1;
                reg2_re <= 1'b0;
                cmd_vaild <= 1'b1;
                imm <= {16'h0,inst_i[15:0]};
                aluop <= `EXEC_OP_OR;
                alusel <= `EXEC_RES_LOGIC;
                regw_addr_o <= inst_i[20:16];
                regw <= 1'b1;
            end
            `EXEC_ANDI:begin
                reg1_re <= 1'b1;
                reg2_re <= 1'b0;
                cmd_vaild <= 1'b1;
                imm <= {16'h0,inst_i[15:0]};
                aluop <= `EXEC_OP_AND;
                alusel <= `EXEC_RES_LOGIC;
                regw_addr_o <= inst_i[20:16];
                regw <= 1'b1;
            end
            `EXEC_XORI:begin
                reg1_re <= 1'b1;
                reg2_re <= 1'b0;
                imm <= {16'h0,inst_i[15:0]};
                aluop <= `EXEC_OP_XOR;
                alusel <= `EXEC_RES_LOGIC;
                regw_addr_o <= inst_i[20:16];
                regw <= 1'b1;
                cmd_vaild <= 1'b1;
            end
            `EXEC_LUI:begin
                reg1_re <= 1'b1;
                reg2_re <= 1'b0;
                imm <= {inst_i[15:0],16'h0};
                aluop <= `EXEC_OP_OR;
                alusel <= `EXEC_RES_LOGIC;
                regw_addr_o <= inst_i[20:16];
                regw <= 1'b1;
                cmd_vaild <= 1'b1;
            end
            `EXEC_XORI:begin
                reg1_re <= 1'b1;
                reg2_re <= 1'b0;
                imm <= {16'h0,inst_i[15:0]};
                aluop <= `EXEC_OP_OR;
                alusel <= `EXEC_RES_LOGIC;
                regw_addr_o <= inst_i[20:16];
                regw <= 1'b1;
                cmd_vaild <= 1'b1;
            end
            `EXEC_ADDI:begin
                reg1_re <= 1'b1;
                reg2_re <= 1'b0;
                imm <= {{16{inst_i[15]}},inst_i[15:0]};// sign bit extend
                regw_addr_o <= inst_i[20:16];
                aluop <= `EXEC_OP_ADD;
                alusel <= `EXEC_RES_ARITH;
                regw <= 1'b1;
                cmd_vaild <= 1'b1;
            end
            `EXEC_ADDIU:begin
                reg1_re <= 1'b1;
                reg2_re <= 1'b0;
                imm <= {{16{inst_i[15]}},inst_i[15:0]};// sign bit extend
                regw_addr_o <= inst_i[20:16];
                aluop <= `EXEC_OP_ADDU;
                alusel <= `EXEC_RES_ARITH;
                regw <= 1'b1;
                cmd_vaild <= 1'b1;
            end
            `EXEC_SLTI:begin
                reg1_re <= 1'b1;
                reg2_re <= 1'b0;
                imm <= {{16{inst_i[15]}},inst_i[15:0]};// sign bit extend
                regw_addr_o <= inst_i[20:16];
                aluop <= `EXEC_OP_SLT;
                alusel <= `EXEC_RES_ARITH;
                regw <= 1'b1;
                cmd_vaild <= 1'b1;
            end
            `EXEC_SLTIU:begin
                reg1_re <= 1'b1;
                reg2_re <= 1'b0;
                imm <= {{16{inst_i[15]}},inst_i[15:0]};// sign bit extend
                regw_addr_o <= inst_i[20:16];
                aluop <= `EXEC_OP_SLTU;
                alusel <= `EXEC_RES_ARITH;
                regw <= 1'b1;
                cmd_vaild <= 1'b1;
            end
            `EXEC_SPECIAL:begin
                regw_addr_o <= inst_i[15:11];
                case(opr3)
                `EXEC_XOR:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_XOR;
                    alusel <= `EXEC_RES_LOGIC;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==0;
                end
                `EXEC_OR:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_OR;
                    alusel <= `EXEC_RES_LOGIC;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==0;
                end
                `EXEC_AND:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_AND;
                    alusel <= `EXEC_RES_LOGIC;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==0;
                end
                `EXEC_NOR:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_NOR;
                    alusel <= `EXEC_RES_LOGIC;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==0;
                end
                //////////////////////////shift cmd/////////////////////////////////
                `EXEC_SLLV:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_SLL;
                    alusel <= `EXEC_RES_SHIFT;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==0;
                end
                `EXEC_SRLV:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_SRL;
                    alusel <= `EXEC_RES_SHIFT;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==0;
                end
                `EXEC_SRAV:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_SRA;
                    alusel <= `EXEC_RES_SHIFT;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==0;
                end
                `EXEC_SYNC:begin
                    reg1_re <= 1'b0;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_NOP;
                    alusel <= `EXEC_RES_SHIFT;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==0;
                end   
                //////////////////////////move cmd/////////////////////////
                `EXEC_MOVN:begin //movn rd,rs,rt rd-<rs rt!=0
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_MOVE;
                    alusel <= `EXEC_RES_MOVE;
                    regw_addr_o <= inst_i[15:11];
                    regw <= reg2_i !=0 ;
                    cmd_vaild <= opr2==0;
                end
                `EXEC_MOVZ:begin//movn rd,rs,rt rd-<rs rt==0
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_MOVE;
                    alusel <= `EXEC_RES_MOVE;
                    regw_addr_o <= inst_i[15:11];
                    regw <= reg2_i ==0 ;
                    cmd_vaild <= opr2==0;
                end
                `EXEC_MFHI:begin //mfhi rd rd-<hi
                    reg1_re <= 1'b0;
                    reg2_re <= 1'b0;
                    aluop <= `EXEC_OP_MFTHI;
                    alusel <= `EXEC_RES_MOVE;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==0;
                end 
                `EXEC_MFLO:begin//mflo rd rd-<lo
                    reg1_re <= 1'b0;
                    reg2_re <= 1'b0;
                    aluop <= `EXEC_OP_MFTLO;
                    alusel <= `EXEC_RES_MOVE;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==0;
                end 
                `EXEC_MTHI:begin//mthi rd hi-<rd
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b0;
                    aluop <= `EXEC_OP_MFTHI;
                    alusel <= `EXEC_RES_MOVE;
                    regw <= 1'b0;
                    cmd_vaild <= opr2==0;
                end 
                `EXEC_MTLO:begin//mtlo rd lo-<rd
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b0;
                    aluop <= `EXEC_OP_MFTLO;
                    alusel <= `EXEC_RES_MOVE;
                    regw <= 1'b0;
                    cmd_vaild <= opr2==0;
                end                               
                ////////////arIth cmd//////////////////////////////////      
                `EXEC_ADD:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_ADD;
                    alusel <= `EXEC_RES_ARITH;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==6'b0;
                end
                `EXEC_ADDU:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_ADDU;
                    alusel <= `EXEC_RES_ARITH;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==6'b0;
                end
                `EXEC_SUB:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_SUB;
                    alusel <= `EXEC_RES_ARITH;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==6'b0;
                end
                `EXEC_SUBU:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_SUBU;
                    alusel <= `EXEC_RES_ARITH;
                    regw_addr_o <= inst_i[15:11];
                    regw <= 1'b1;
                    cmd_vaild <= opr2==6'b0;
                end
                `EXEC_SLT:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_SLT;
                    alusel <= `EXEC_RES_ARITH;
                    regw <= 1'b1;
                    cmd_vaild <= opr2==6'b0;
                end
                `EXEC_SLTU:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b1;
                    aluop <= `EXEC_OP_SLTU;
                    alusel <= `EXEC_RES_ARITH;
                    regw <= 1'b1;
                    cmd_vaild <= opr2==6'b0;
                end                                                                               
                endcase//case op3
            end // exec_special:
            `EXEC_SPECIAL2:begin
                case(opr3)
                `EXEC_CLZ:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b0;
                    imm <= 0;
                    aluop <= `EXEC_OP_CLZ;
                    alusel <= `EXEC_RES_ARITH;
                    regw_addr_o <= rd;
                    regw <= 1'b1;
                    cmd_vaild <= opr2==6'b0;
                end
                `EXEC_CLO:begin
                    reg1_re <= 1'b1;
                    reg2_re <= 1'b0;
                    imm <= 32'h1234abcd;
                    aluop <= `EXEC_OP_CLZ;
                    alusel <= `EXEC_RES_ARITH;
                    regw_addr_o <= rd;
                    regw <= 1'b1;
                    cmd_vaild <= opr2==6'b0;
                end
                endcase// CASE OP3                 
            end// EXEC SPECIAL2                   
        endcase//case op
        
        if(inst_i[31:21]==11'b0) begin
            case(opr3) 
            `EXEC_SLL:begin
                reg1_re <= 1'b0;
                reg2_re <= 1'b1;
                imm <= {16'h0,inst_i[10:6]};
                aluop <= `EXEC_OP_SLL;
                alusel <= `EXEC_RES_SHIFT;
                regw_addr_o <= inst_i[15:11];
                regw <= 1'b1;
                cmd_vaild <= 1;
            end
            `EXEC_SRL:begin
                reg1_re <= 1'b0;
                reg2_re <= 1'b1;
                imm <= {16'h0,inst_i[10:6]};
                aluop <= `EXEC_OP_SRL;
                alusel <= `EXEC_RES_SHIFT;
                regw_addr_o <= inst_i[15:11];
                regw <= 1'b1;
                cmd_vaild <= 1;            
            end
            `EXEC_SRA:begin
                reg1_re <= 1'b0;
                reg2_re <= 1'b1;
                imm <= {16'h0,inst_i[10:6]};
                aluop <= `EXEC_OP_SRA;
                alusel <= `EXEC_RES_SHIFT;
                regw_addr_o <= inst_i[15:11];
                regw <= 1'b1;
                cmd_vaild <= 1;                        
            end
            endcase
        end
    end //else rst
end //always



//op1 data mux
always@(*)
begin
    if(!rst) begin
        op1 <= 32'b0;
    end
    else if((reg1_re==1'b1)&&reg_ex_we&&(reg_ex_addr_i==reg1_addr_o)) begin
        op1 <= reg_ex_i;
    end
    else if((reg1_re==1'b1)&&reg_mem_we&&(reg_mem_addr_i==reg1_addr_o)) begin
        op1 <= reg_mem_i;
    end
    else if(reg1_re==1'b1)begin
        op1 <= reg1_i;
    end
    else if(reg1_re==1'b0) begin
        op1 <= imm;
    end
    else begin
        op1 <= 32'b0;
    end
end
//op2 mux
always@(*)
begin
    if(!rst) begin
        op2 <= 32'b0;
    end
    else if((reg2_re==1'b1)&&reg_ex_we&&(reg_ex_addr_i==reg2_addr_o)) begin
        op2 <= reg_ex_i;
    end
    else if((reg2_re==1'b1)&&reg_mem_we&&(reg_mem_addr_i==reg2_addr_o)) begin
        op2 <= reg_mem_i;
    end
    else if(reg2_re==1'b1)begin
        op2 <= reg2_i;
    end
    else if(reg2_re==1'b0) begin
        op2 <= imm;
    end
    else begin
        op2 <= 32'b0;
    end
end

endmodule
