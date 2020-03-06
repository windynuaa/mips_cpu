`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:04:01 10/31/2017 
// Design Name: 
// Module Name:    fft_test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fft_test(
		input clk,
		input reset,
		input fft_start,
		input [31:0] xn_re,
		input [31:0] xn_im,
		input fwd_inv,
		output rfd,
		output [3:0] xn_index,
		output busy,
		output fft_col_dv,
		output edone,
		output done,
		output [3:0] xk_index,
		output [31:0] xk_re_o,
		output [31:0] xk_im_o,
		output  dout_valid_o
		
		
    );
/////////////////////////////////////////////////////////////////////////////////
//reg start;
reg [31:0] xn_re_reg;
parameter FFT_N=32;


reg [13:0] fft_row_cnt;
wire fft_row_dv;
wire [31:0] row_xk_re;
wire [4:0] row_xk_re_ex;
wire [31:0] row_xk_im;
wire [4:0] row_xk_im_ex;
wire [3:0] row_xk_index;

reg [13:0] fft_row_ram_addra;
reg [6:0] fft_row_ram_addra_h;
reg [6:0] fft_row_ram_addra_l;
wire [31:0] row_ram_re_din;
wire [31:0] row_ram_im_din;

reg fft_col_start;
//wire fft_col_dv;
wire [31:0] col_xk_re;
wire [4:0] col_xk_re_ex;
wire [31:0] col_xk_im;
wire [4:0] col_xk_im_ex;
wire [3:0] col_xk_index;

wire [63:0] fft_row_ram_dout;
reg [63:0] fft_row_ram_dout_reg;
parameter	S_IDLE		=   5'h0,
				S_FFT_ROW =	5'h1,
				S_FFT_COL=   5'h2,
				S_FFT_OUT=   5'h3;

	
	reg [4:0]	s_state;
	wire [31:0] xk_im;
	wire [31:0] xk_re;
	reg [13:0] fft_col_ram_addra;
reg [6:0] fft_col_ram_addra_h;
reg [6:0] fft_col_ram_addra_l;
wire [63:0] fft_col_ram_dout;
reg fft_done;
reg dout_valid;
reg dout_valid_dff1;
reg dout_valid_dff2;

wire fft_row_ovflo;
wire fft_col_ovflo;

///////////////////////////////////////////////////////////////////////////////
assign dout_valid_o=dout_valid_dff2;
assign xk_re_o=fft_col_ram_dout[63:32];
assign xk_im_o=fft_col_ram_dout[31:0];
assign xk_index=col_xk_index;
//assign xk_im=col_xk_im<<2;
//assign xk_re=col_xk_re<<2;
//assign row_ram_re_din=row_xk_re<<2;
//assign row_ram_im_din=row_xk_im<<2;
assign xk_im=col_xk_im;
assign xk_re=col_xk_re;
assign row_ram_re_din=row_xk_re;
assign row_ram_im_din=row_xk_im;

always@(posedge clk or negedge reset)//为了保证进入fft的数据比start一个时钟
	if(~reset)begin
		xn_re_reg<=0;
		//fft_row_ram_dout_reg<=0;
	end else begin
		
			xn_re_reg<=xn_re;
			//fft_row_ram_dout_reg<=fft_row_ram_dout;
		
	end
fft fft_row (
	.clk(clk), // input clk
	.start(fft_start), // input start
	.xn_re(xn_re_reg), // input [31 : 0] xn_re
	.xn_im(xn_im), // input [31 : 0] xn_im
	.fwd_inv(fwd_inv), // input fwd_inv
	.fwd_inv_we(1), // input fwd_inv_we
	//.scale_sch(0000), // input [3 : 0] scale_sch
	//.scale_sch_we(1), // input scale_sch_we
	.rfd(), // ouput rfd
	.xn_index(), // ouput [3 : 0] xn_index
	.busy(), // ouput busy
	.edone(), // ouput edone
	.done(), // ouput done
	.dv(fft_row_dv), // ouput dv
	.xk_index(row_xk_index), // ouput [3 : 0] xk_index
	.xk_re(row_xk_re), // ouput [36 : 0] xk_re
	.xk_im(row_xk_im));
	//.ovflo(fft_row_ovflo)); // ouput [36 : 0] xk_im

fft_ram fft_row_ram (
  .clka(clk), // input clka
  .wea(fft_row_dv), // input [0 : 0] wea
  .addra(fft_row_ram_addra), // input [13 : 0] addra
  .dina({row_ram_re_din,row_ram_im_din}), // input [63 : 0] dina
  .douta(fft_row_ram_dout) // output [63 : 0] douta
);
fft fft_col (
	.clk(clk), // input clk
	.start(fft_col_start), // input start
	.xn_re(fft_row_ram_dout[63:32]), // input [31 : 0] xn_re
	.xn_im(fft_row_ram_dout[31:0]), // input [31 : 0] xn_im
	.fwd_inv(fwd_inv), // input fwd_inv
	.fwd_inv_we(1), // input fwd_inv_we
	//.scale_sch(0000), // input [3 : 0] scale_sch
	//.scale_sch_we(1), // input scale_sch_we
	.rfd(rfd), // ouput rfd
	.xn_index(xn_index), // ouput [3 : 0] xn_index
	.busy(busy), // ouput busy
	.edone(edone), // ouput edone
	.done(done), // ouput done
	.dv(fft_col_dv), // ouput dv
	.xk_index(col_xk_index), // ouput [3 : 0] xk_index
	.xk_re(col_xk_re), // ouput [36 : 0] xk_re
	.xk_im(col_xk_im));
	//.ovflo(fft_col_ovflo)); // ouput [36 : 0] xk_im
	
fft_ram fft_col_ram (
  .clka(clk), // input clka
  .wea(fft_col_dv), // input [0 : 0] wea
  .addra(fft_col_ram_addra), // input [13 : 0] addra
  .dina({xk_re,xk_im}), // input [63 : 0] dina
  .douta(fft_col_ram_dout) // output [63 : 0] douta
);
	always@(posedge clk or negedge reset)
	if(~reset)begin
		fft_row_cnt<=0;
		
		
	end else begin
		
		if(fft_col_start)begin
				fft_row_cnt<=fft_row_cnt+1;
				
		end else begin
				
				fft_row_cnt<=fft_row_cnt;
		end
		if(s_state==S_IDLE)begin
			fft_row_cnt<=0;
		end
	end
	always@(posedge clk or negedge reset)
	if(~reset)begin
		s_state<=S_IDLE;
		fft_row_ram_addra<=0;
		fft_col_start<=0;
		fft_row_ram_addra_h<=0;
		fft_row_ram_addra_l<=0;
		fft_done<=0;
		fft_col_ram_addra<=0;
		fft_col_ram_addra_h<=0;
		fft_col_ram_addra_l<=0;
	end else begin
		case(s_state)
		S_IDLE:begin
			fft_done<=0;
			if(fft_start)begin
				s_state<=S_FFT_ROW;
			end
		end
		S_FFT_ROW:begin
			if(fft_row_dv)begin
				fft_row_ram_addra<=fft_row_ram_addra+1;
			end else begin
				fft_row_ram_addra<=fft_row_ram_addra;
			end
			if(fft_row_ram_addra==FFT_N*FFT_N-1)begin
				fft_row_ram_addra<=0;
				s_state<=S_FFT_COL;
			end
		end
		S_FFT_COL:begin
			
			if(fft_row_cnt>=FFT_N*FFT_N-1)begin
				fft_row_ram_addra<=0;
				fft_col_start<=0;
				
			end else begin
				fft_col_start<=1;
				fft_row_ram_addra_h<=fft_row_ram_addra_h+1;
				fft_row_ram_addra	  <= fft_row_ram_addra_h*FFT_N+fft_row_ram_addra_l;
						if(fft_row_ram_addra_h==FFT_N-1) begin  
							fft_row_ram_addra_l  <= fft_row_ram_addra_l + 1;
							fft_row_ram_addra_h<=0;
						end
			end
			if(fft_col_dv)begin
				fft_col_ram_addra<=fft_col_ram_addra+1;
			end else begin
				fft_col_ram_addra<=fft_col_ram_addra;
			end
			if(fft_col_ram_addra==FFT_N*FFT_N-1)begin
				fft_col_ram_addra<=0;
				s_state<=S_FFT_OUT;
				fft_done<=1;
			end
		end
		S_FFT_OUT:begin
			if(fft_done)begin
				fft_col_ram_addra_h<=fft_col_ram_addra_h+1;
				fft_col_ram_addra<=fft_col_ram_addra_h*FFT_N+fft_col_ram_addra_l;
				if(fft_col_ram_addra_h==FFT_N-1)begin
					fft_col_ram_addra_l<=fft_col_ram_addra_l+1;
					fft_col_ram_addra_h<=0;
				end
			end 
			if(fft_col_ram_addra==FFT_N*FFT_N-1)begin
				fft_done<=0;
				fft_col_ram_addra<=0;
				fft_col_ram_addra_h<=0;
				fft_col_ram_addra_l<=0;
				s_state<=S_IDLE;
			end
		end
		endcase
	end
	
//	always@(posedge clk or negedge reset)
//	if(~reset)begin
//		dout_valid<=0;
//	end else begin
//		if(fft_done)begin
//			dout_valid<=1;
//		end
//	end

//	always@(posedge clk or negedge reset)
//	if(~reset)begin
//		fft_col_ram_addra<=0;
//		fft_col_ram_addra_h<=0;
//		fft_col_ram_addra_l<=0;
//		dout_valid<=0;
//		
//	end else begin
//		if(fft_done)begin
//			dout_valid<=1;
//		end
//		if(dout_valid)begin
//				fft_col_ram_addra_h<=fft_col_ram_addra_h+1;
//				fft_col_ram_addra<=fft_col_ram_addra_h*16+fft_col_ram_addra_l;
//				if(fft_col_ram_addra_h==15)begin
//					fft_col_ram_addra_l<=fft_col_ram_addra_l+1;
//					fft_col_ram_addra_h<=0;
//				end
//		end 
//		if(fft_col_ram_addra==16*16-1)begin
//			dout_valid<=0;
//			fft_col_ram_addra<=0;
//			fft_col_ram_addra_h<=0;
//			fft_col_ram_addra_l<=0;
//		end
//	end
	always@(posedge clk or negedge reset)
	if(~reset)begin
		dout_valid_dff1<=0;
		dout_valid_dff2<=0;
	end else begin
		
			dout_valid_dff1<=fft_done;
			dout_valid_dff2<=dout_valid_dff1&fft_done;
		
	end
endmodule
