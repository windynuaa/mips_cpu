`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2020 12:29:01 PM
// Design Name: 
// Module Name: pc
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


module pc(
    input clk,
    input rst,
    input [5:0] stall,
    output [31:0] inst_addr_o,
    output re
    );

reg [31:0]pc_reg=0;
reg re_reg=0;
assign re=re_reg;
assign inst_addr_o=pc_reg;
always@(posedge clk)
begin 
    if(!rst) begin
    pc_reg <= 32'b0;
    re_reg <= 0;
    end 
    else begin
        re_reg <= 1;
        if(stall[0]==0)begin
            pc_reg <= pc_reg + 4;
        end
    end
  

end
    
endmodule
