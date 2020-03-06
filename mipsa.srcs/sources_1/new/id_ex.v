`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2020 01:51:20 PM
// Design Name: 
// Module Name: id_ex
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


module id_ex(
    input rst,    
    input clk,
    
    input [7:0] aluop_i,
    input [2:0] alusel_i,
    input [31:0] op1_i,
    input [31:0] op2_i,
    input [4:0] regw_addr_i,
    input regw_i,
    input [5:0] stall,
    output reg [7:0] aluop_o,
    output reg [2:0] alusel_o,
    output reg [31:0] op1_o,
    output reg [31:0] op2_o,
    output reg [4:0] regw_addr_o,
    output reg regw_o
    );
    
always@(posedge clk)
begin
    if(!rst) begin
        aluop_o <=6'b0;
        alusel_o<=3'b0;
        op1_o<=1'b0;
        op2_o<=1'b0;
        regw_addr_o<=6'b0;
        regw_o<=1'b0;
    end
    else begin
         if(stall[3]==0) begin
           if(stall[2])begin
               aluop_o <=6'b0;
               alusel_o<=3'b0;
               op1_o<=1'b0;
               op2_o<=1'b0;
               regw_addr_o<=6'b0;
               regw_o<=1'b0;
           end
           else begin
               aluop_o <=aluop_i;
               alusel_o<=alusel_i;
               op1_o<=op1_i;
               op2_o<=op2_i;
               regw_addr_o<=regw_addr_i;
               regw_o<=regw_i;
           end
       end
    end
end
    
endmodule
