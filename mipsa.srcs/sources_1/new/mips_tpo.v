`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 1连线要注意位宽
// 2
// Create Date: 01/28/2020 11:29:44 AM
// Design Name: 
// Module Name: mips_tpo
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


module mips_tpo(
    input wire clk,
    input wire  rst,
    input wire  [31:0] rom_data,
    output wire [31:0] rom_addr,
    output wire rom_re,
    output wire [3:0]gpios
    );
 // reg [31:0]test=32'h340111aa;
 //wire [31:0]rom_data;
 //assign rom_data=test;
 wire [31:0] inst_addr_pc;
 wire [31:0] inst_addr_id;
 wire [31:0] inst_rom;
 wire [31:0]inst_ifid;
 
 wire [4:0] reg1_addr;
 wire [4:0] reg2_addr;
 wire [4:0] regw_addr;

 wire [31:0]regw_data;
 wire [31:0]reg1_data;
 wire [31:0]reg2_data;

 wire reg1_re;
 wire reg2_re;
 wire reg_we;
 
 //id out
 wire [31:0]op1_id;
 wire [31:0]op2_id;
 wire [4:0]regw_addr_o_id;
 wire regw_id;
 wire [7:0]aluop_id;
 wire [2:0]alusel_id;
 //idex0 out
 wire [31:0]op1_id_ex;
 wire [31:0]op2_id_ex;
 wire [4:0]regw_addr_o_id_ex;
 wire regw_id_ex;
 wire [7:0]aluop_id_ex;
 wire [2:0]alusel_id_ex;
 //ex0 out
 wire [4:0]regw_addr_ex0;
 wire [31:0]regw_data_ex0;
 wire reg_we_ex0;
 //exmem0 out
 wire [31:0]regw_data_ex_mem0;
 wire [4:0]regw_addr_ex_mem0;
 wire reg_we_ex_mem0; 
//mem0 out
 wire [31:0]regw_data_mem0;
 wire [4:0]regw_addr_mem0;
 wire reg_we_mem0; 
//pipeline control
wire [5:0]stall;
wire stall_req_id;
wire stall_req_ex;

assign rom_addr=inst_addr_pc;
(* keep_hierarchy = "yes" *)
 pc pc0(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .re(rom_re),
    .inst_addr_o(inst_addr_pc)
 );   
 (* keep_hierarchy = "yes" *)
if_id if_id0(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .inst_i(rom_data),
    .inst_o(inst_ifid),
    .inst_addr_i(inst_addr_pc),
    .inst_addr_o(inst_addr_id)
);



(* keep_hierarchy = "yes" *)
regs reg0(
    .clk(clk),
    .rst(rst),
    
    .reg1_addr_i(reg1_addr),
    .reg1_re(reg1_re),
    .reg2_addr_i(reg2_addr),
    .reg2_re(reg2_re),
    
    .reg_addr_i(regw_addr),
    .reg_data_i(regw_data),
    .reg_we(reg_we),
    //output
    .reg1_data_o(reg1_data),
    .reg2_data_o(reg2_data),
    //test
    .gpios(gpios)
);
(* keep_hierarchy = "yes" *)
id id0(
    .clk(clk),
    .rst(rst),
    .stall_req_id(stall_req_id),
    .inst_i(inst_ifid),
    .inst_addr_i(inst_addr_id),
    .reg1_i(reg1_data),
    .reg2_i(reg2_data),
    //
    .reg_ex_we(reg_we_ex0),
    .reg_mem_we(reg_we_mem0),
    .reg_ex_i(regw_data_ex0),
    .reg_mem_i(regw_data_mem0),
    .reg_ex_addr_i(regw_addr_ex0),
    .reg_mem_addr_i(regw_addr_mem0),
    //output
    .reg1_addr_o(reg1_addr),
    .reg1_re(reg1_re),
    .reg2_addr_o(reg2_addr),
    .reg2_re(reg2_re),
    
    .aluop(aluop_id),
    .alusel(alusel_id),
    .op1(op1_id),
    .op2(op2_id),
    .regw_addr_o(regw_addr_o_id),
    .regw(regw_id)
);

(* keep_hierarchy = "yes" *)
id_ex id_ex0(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .aluop_i(aluop_id),
    .alusel_i(alusel_id),
    .op1_i(op1_id),
    .op2_i(op2_id),
    .regw_addr_i(regw_addr_o_id),
    .regw_i(regw_id),
    
    .aluop_o(aluop_id_ex),
    .alusel_o(alusel_id_ex),
    .op1_o(op1_id_ex),
    .op2_o(op2_id_ex),
    .regw_addr_o(regw_addr_o_id_ex),
    .regw_o(regw_id_ex)

);

wire [`REG_DATA_WIDTH]hi_o_exmem;
wire [`REG_DATA_WIDTH]lo_o_exmem;
wire hiw_o_exmem;
wire low_o_exmem;
wire [`REG_DATA_WIDTH]lo_o_memwb;
wire [`REG_DATA_WIDTH]hi_o_memwb;
wire hiw_o_memwb;
wire low_o_memwb;
wire [`REG_DATA_WIDTH]lo_o_mem;
wire [`REG_DATA_WIDTH]hi_o_mem;
wire hiw_o_mem;
wire low_o_mem;
wire [`REG_DATA_WIDTH]hi_o_ex;
wire [`REG_DATA_WIDTH]lo_o_ex;
wire hiw_o_ex;
wire low_o_ex;
wire [`REG_DATA_WIDTH]hi_o_hilo;
wire [`REG_DATA_WIDTH]lo_o_hilo;

wire [`REG_DATA_WIDTH]mul_temp_o_exmem;
wire [16:0]cmd_loop_cnt_o_exmem;
wire [`REG_DATA_WIDTH]mul_temp_o_ex;
wire [16:0]cmd_loop_cnt_o_ex;


///////////////////

(* keep_hierarchy = "yes" *)
ex ex0(
    .clk(clk),
    .rst(rst),
    .stall_req_ex(stall_req_ex),
    .aluop_i(aluop_id_ex),
    .alusel_i(alusel_id_ex),
    .op1_i(op1_id_ex),
    .op2_i(op2_id_ex),
    .regw_addr_i(regw_addr_o_id_ex),
    .regw_i(regw_id_ex),
    .res(regw_data_ex0),
    .regw_addr_o(regw_addr_ex0),
    .regw_o(reg_we_ex0),
    //HILO///////
    .hi_i(hi_o_hilo),
    .lo_i(lo_o_hilo),
    .hi_o(hi_o_ex),
    .lo_o(lo_o_ex),
    .hiw_o(hiw_o_ex),
    .low_o(low_o_ex),
    //    data coe
    .hiw_mem_i(hiw_o_mem),
    .hi_mem_i(hi_o_mem),
    .low_mem_i(low_o_mem),
    .lo_mem_i(lo_o_mem),
    .hiw_wb_i(hiw_o_memwb),
    .hi_wb_i(hi_o_memwb),
    .low_wb_i(low_o_memwb),
    .lo_wb_i(lo_o_memwb),
    ////////
    .mul_temp_i(mul_temp_o_exmem),
    .cmd_loop_cnt_i(cmd_loop_cnt_o_exmem),
    .mul_temp_o(mul_temp_o_ex),
    .cmd_loop_cnt_o(cmd_loop_cnt_o_ex)
);

(* keep_hierarchy = "yes" *)
ex_mem ex_mem0(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .data_i(regw_data_ex0),
    .regw_addr_i(regw_addr_ex0),
    .regw_i(reg_we_ex0),
    .data_o(regw_data_ex_mem0),
    .regw_addr_o(regw_addr_ex_mem0),
    .regw_o(reg_we_ex_mem0),
    //wires HILO
    .hiw_i(hiw_o_ex),
    .low_i(low_o_ex),
    .hi_i(hi_o_ex),
    .lo_i(lo_o_ex),
    .hi_o(hi_o_exmem),
    .lo_o(lo_o_exmem),
    .hiw_o(hiw_o_exmem),
    .low_o(low_o_exmem),
    //madd msub
    .mul_temp_i(mul_temp_o_ex),
    .cmd_loop_cnt_i(cmd_loop_cnt_o_ex),
    .mul_temp_o(mul_temp_o_exmem),
    .cmd_loop_cnt_o(cmd_loop_cnt_o_exmem)
);


(* keep_hierarchy = "yes" *)
mem mem0(
    .clk(clk),
    .rst(rst),
    .data_i(regw_data_ex_mem0),
    .regw_addr_i(regw_addr_ex_mem0),
    .regw_i(reg_we_ex_mem0),
    .data_o(regw_data_mem0),
    .regw_addr_o(regw_addr_mem0),
    .regw_o(reg_we_mem0),
     //wires HILO
    .hiw_i(hiw_o_exmem),
    .low_i(low_o_exmem),
    .hi_i(hi_o_exmem),
    .lo_i(lo_o_exmem),
    .hi_o(hi_o_mem),
    .lo_o(lo_o_mem),
    .hiw_o(hiw_o_mem),
    .low_o(low_o_mem)
    //
);
(* keep_hierarchy = "yes" *)
mem_wb mem_wb0(
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .data_i(regw_data_mem0),
    .regw_addr_i(regw_addr_mem0),
    .regw_i(reg_we_mem0),
    .data_o(regw_data),
    .regw_addr_o(regw_addr),
    .regw_o(reg_we),
    //wires HILO
    .hiw_i(hiw_o_mem),
    .low_i(low_o_mem),
    .hi_i(hi_o_mem),
    .lo_i(lo_o_mem),
    .hi_o(hi_o_memwb),
    .lo_o(lo_o_memwb),
    .hiw_o(hiw_o_memwb),
    .low_o(low_o_memwb)
    //
);
HILO HILO0(
    .rst(rst),
    .clk(clk),
    .hi_we(hiw_o_memwb),
    .hi_i(hi_o_memwb),
    .hi_o(hi_o_hilo),
    .lo_we(low_o_memwb),
    .lo_i(lo_o_memwb),
    .lo_o(lo_o_hilo)
);

CTRL ctrl0(
    .stall_req_ex(stall_req_ex),
    .stall_req_id(stall_req_id),
    .rst(rst),
    .stall(stall)
    );
endmodule
