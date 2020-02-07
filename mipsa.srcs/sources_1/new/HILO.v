`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2020 04:33:54 PM
// Design Name: 
// Module Name: HILO
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


module HILO(
    input rst,
    input clk,
    input hi_we,
    input [31:0] hi_i,
    inout [31:0] hi_o,
    input lo_we,
    input [31:0] lo_i,
    output [31:0] lo_o
    );
    
reg [31:0] HI=0;
reg [31:0] LO=0;

assign lo_o=LO;
assign hi_o=HI;

always@(posedge clk)
begin
    if(!rst) begin
        HI<=32'b0;
    end
    else begin
        if(hi_we) begin
        HI<=hi_i;
        end
    end
end
always@(posedge clk)
begin
    if(!rst) begin
        LO<=32'b0;
    end
    else begin
        if(lo_we) begin
        LO<=lo_i;
        end
    end
end    
    
    
endmodule
