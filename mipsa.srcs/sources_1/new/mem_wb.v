`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/28 21:37:46
// Design Name: 
// Module Name: mem_wb
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


module mem_wb(
    input clk,
    input rst,
    input   [31:0]data_i,
    input   [4:0] regw_addr_i,
    input   regw_i,
    output reg  [31:0]data_o,
    output reg  [4:0] regw_addr_o,
    output reg  regw_o,
    //HILO
    input  hiw_i,
    input  low_i,
    input [31:0] hi_i,
    input [31:0] lo_i,
    output reg  [31:0]hi_o,
    output reg  [31:0]lo_o,
    output reg  hiw_o,
    output reg  low_o
    //
    
    );
    
always@(posedge clk)
    begin
        if(!rst)begin
            data_o <= 32'b0;
            regw_addr_o <= 5'b0;
            regw_o <= 1'b0;
            hi_o <= 32'b0;
            lo_o <= 32'b0;
            hiw_o <=1'b0;
            low_o <=1'b0;
        end
        else begin
            data_o <= data_i;
            regw_addr_o <= regw_addr_i;
            regw_o <= regw_i;
            hi_o <= hi_i;
            lo_o <= lo_i;
            hiw_o <=hiw_i;
            low_o <=low_i;
        end
    end
    endmodule