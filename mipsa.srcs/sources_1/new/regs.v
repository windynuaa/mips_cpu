`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2020 01:47:37 PM
// Design Name: 
// Module Name: regs
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


module regs(
    input rst,
    input clk,
    //read reg1
    input [4:0] reg1_addr_i,
    input reg1_re,
    //read reg2
    input [4:0] reg2_addr_i,
    input reg2_re,
    //write reg
    input [4:0] reg_addr_i,
    input [31:0] reg_data_i,
    input reg_we,
    //output
    output reg[31:0] reg1_data_o,
    output reg[31:0] reg2_data_o,
    //test
    output [3:0]gpios
    );
    
reg [31:0]reg_map[32:0];
assign gpios=reg_map[1][3:0];
always@(*)
begin
    if(!reg1_re) begin
        reg1_data_o<=32'b0;
    end
    else if(reg1_addr_i==5'b0) begin
        reg1_data_o<=32'b0;
    end
    else if(reg1_addr_i==reg_addr_i) begin
        reg1_data_o<=reg_data_i;
    end
    else  begin
        reg1_data_o<=reg_map[reg1_addr_i];
    end
end

always@(*)
begin
    if(!reg2_re) begin
        reg2_data_o<=32'b0;
    end
    else if(reg2_addr_i==5'b0) begin
        reg2_data_o<=32'b0;
    end
    else if(reg2_addr_i==reg_addr_i) begin
        reg2_data_o<=reg_data_i;
    end
    else  begin
        reg2_data_o<=reg_map[reg2_addr_i];
    end
end

always@(posedge clk)
begin
    if(reg_we) begin
       reg_map[reg_addr_i]<=reg_data_i;
    end
end
endmodule
