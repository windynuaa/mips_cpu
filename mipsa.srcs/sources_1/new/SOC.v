`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/28 22:17:32
// Design Name: 
// Module Name: SOC
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




module SOC(
    input clk,
    input rst,
    output [3:0] gpios
    );
    
wire [31:0]data;
wire [31:0]addr;
wire re;
(* keep_hierarchy = "yes" *)
  mips_tpo cpu(
       .clk(clk),
       .rst(rst),
       .rom_data(data),
       .rom_addr(addr),
       .rom_re(re),
       .gpios(gpios)
   );
 (* keep_hierarchy = "yes" *)
   rom roms(
        .re(re),
       .addr(addr),
       .data(data)
   );
endmodule
