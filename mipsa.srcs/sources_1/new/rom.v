`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2020 02:45:42 PM
// Design Name: 
// Module Name: rom
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


module rom(
    input re,
    input [31:0] addr,
    output[31:0] data
    );
reg [31:0]data_out=0;
reg [31:0]datas[31:0];

initial
begin
    datas[1]=32'h2001ffff;
    datas[2]=32'h20017fff;
    datas[3]=32'h00010c00;
    datas[4]=32'h00211020;
    datas[5]=32'h00211821;
    datas[6]=32'h28240000;
    datas[7]=32'h2c25aaaa;
    datas[8]=32'h340100ff;
    datas[9]=32'h2002ff00;
    datas[10]=32'h70431821;
    datas[11]=32'h70242020;
    /*
    datas[10]=32'h3821000f;
    datas[11]=32'h3821000f;
    datas[12]=32'h3821000f;
    datas[13]=32'h3821000f;
    datas[14]=32'h3821000f;
    datas[15]=32'h3821000f;
    datas[16]=32'h30210000;
    /8*/
end

assign data=data_out;
always@(*)
begin
    if(re) begin
        //data_out <= 32'h34011100;
        data_out <= datas[addr];
    end
    else begin
        data_out <= 32'b0;
    end
end
    
    
endmodule
