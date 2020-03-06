`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2020 12:31:41 PM
// Design Name: 
// Module Name: if_id
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


module if_id(
    input clk,
    input rst,
    input [31:0] inst_addr_i,
    input [31:0] inst_i,
    input [5:0] stall,
    output reg [31:0] inst_addr_o,
    output reg [31:0]  inst_o
    );
    
always@(posedge clk)
begin
    if (!rst) begin
        inst_addr_o <= 32'b0;
        inst_o <= 32'b0;
    end
    else begin
        if(stall[2]==0) begin
            if(stall[1])begin
                inst_addr_o <= 32'b0;
                inst_o <= 32'b0;
            end
            else begin
                inst_addr_o <= inst_addr_i;
                inst_o <= inst_i;
            end
        end
    end
end    
endmodule
