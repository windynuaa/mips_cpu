`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/28 17:43:51
// Design Name: 
// Module Name: mips_sim
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


module mips_sim(

    );
reg clk=0;
reg rst=0;
wire [31:0]data;
wire [31:0]addr;
wire re;

initial
begin
    clk=0;
    rst=0;
    #100;
    rst=1;
    forever #50 clk=~clk;
end

 mips_tpo cpu(
    .clk(clk),
    .rst(rst),
    .rom_data(data),
    .rom_addr(addr),
    .rom_re(re)
);
rom roms(
     .re(re),
    .addr(addr),
    .data(data)
);
    
endmodule
