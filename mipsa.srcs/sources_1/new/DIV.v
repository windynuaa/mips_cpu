`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2020 05:23:32 PM
// Design Name: 
// Module Name: DIV
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


module DIV(
    input clk,
    input rst,
    input sig,
    input [31:0] op1_i,
    input [31:0] op2_i,
    input start_i,
    input annul_i,
    output reg [63:0] result_o,
    output reg ready_o
    );

reg [5:0]i;
reg [31:0]op1;
reg [31:0]op2;
reg [31:0]temp;
reg [31:0]s;
reg [31:0]y;
reg [5:0]state;// 00 
wire [31:0]zoo=temp-op2;
wire zero=zoo[31];
`define FREE        6'b001101
`define START        6'b100111
`define ZERO         6'b100101
`define END        6'b100110
`define CACL        6'b100111
/*
always@(posedge clk)
begin
    if(!rst)begin
    
    end
    else begin
        case(state)
        `FREE:begin
            if(start_i&&(!annul_i))begin
                state<=(op2_i==32'b0)?`ZERO:`CACL;
                op1=sig&&op1_i[31]?~op1_i+1:op1_i;
                op2=sig&&op2_i[31]?~op2_i+1:op2_i;
                i<=6'b0;
                temp<=32'b0;
            end
        end
        `ZERO:begin
            ready_o<=1'b1;
            result_o<=64'b0;
            state<=`END;
        end
        `CACL:begin
            if(i>6'd32)begin
                state<=`END;
            end
            else if(annul_i)begin
                state<=`FREE;
            end
            else begin
                temp<={temp[31:1],op1[31]};
                if(zero)
            
            
            end
        end
        endcase
    end
    
end
*/
/*
always@(posedge )
    if(!rst)begin
        result_o=64'b0;
        ready_o=1'b0;
    end
    else if(start_i)begin
        op1=op1_i;
        op2=op2_i;
        for(i=0;i<32;i=i+1) begin
            if(op1>=op2)begin
                op1=op1-op2;
                s=s+1;
            end
            else if(op1==0)begin
                y=0;
            end
            else begin
                y=op1;
                i=32;
            end
        end    
        result_o={s,y};
        ready_o=1;
    end
*/
endmodule
