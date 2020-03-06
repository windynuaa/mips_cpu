`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: none
// Engineer: windy liu
// 
// Create Date: 02/07/2020 11:04:31 AM
// Design Name: mipscpu
// Module Name: CTRL
// Project Name: 
// Target Devices: arty a7-35
// Tool Versions: 
// Description: 
// pipeline control
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// stall{5:0}={  wb_stall`    [5]
//               mem_stall,   [4]
//               ex _stall,    [3]
//               id _stall,    [2]
//               if_stall,    [1]
//               pc_stall     [0]
//             }
//
// if(stall[a]==0 and stall[a+1]!=0)
// then stage a+1 input equal to 0

//////////////////////////////////////////////////////////////////////////////////


module CTRL(
    input stall_req_ex,
    input stall_req_id,
    input rst,
    output reg [5:0] stall
    );
    
    
always@(*)
begin
    if(!rst) begin
        stall<=6'b0;
    end
    else begin
        if(stall_req_ex)begin
            stall<=6'b001111;
        end
        else if (stall_req_id) begin
            stall<=6'b000111;
        end
        else begin
            stall<=6'b000000;
        end
    end

end
endmodule
