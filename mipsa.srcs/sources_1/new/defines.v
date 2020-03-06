//LOGIC CODE
`define EXEC_ORI        6'b001101
`define EXEC_OR         6'b100101
`define EXEC_XOR        6'b100110
`define EXEC_NOR        6'b100111
`define EXEC_AND        6'b100100
`define EXEC_ANDI       6'b001100
`define EXEC_XORI       6'b001110
`define EXEC_LUI        6'b001111
//shift code
`define EXEC_SLL        6'b000000
`define EXEC_SLLV       6'b000100
`define EXEC_SRL        6'b000010
`define EXEC_SRLV       6'b000110
`define EXEC_SRA        6'b000011
`define EXEC_SRAV       6'b000111
`define EXEC_SYNC       6'b001111
//move code
`define EXEC_MOVN       6'b001011
`define EXEC_MOVZ       6'b001010
`define EXEC_MFHI       6'b010000
`define EXEC_MFLO       6'b010010
`define EXEC_MTHI       6'b010001
`define EXEC_MTLO       6'b010011
//arith code
`define EXEC_ADD        6'b100000
`define EXEC_ADDU       6'b100001
`define EXEC_SUB        6'b100010
`define EXEC_SUBU       6'b100011
`define EXEC_SLT        6'b101010
`define EXEC_SLTU       6'b101011

`define EXEC_MUL        6'b000010
`define EXEC_MULT       6'b011000
`define EXEC_MULTU      6'b011001
`define EXEC_MADD       6'b000000
`define EXEC_MADDU      6'b000001
`define EXEC_MSUB       6'b000100
`define EXEC_MSUBU      6'b000101

`define EXEC_ADDI       6'b001000
`define EXEC_ADDIU      6'b001001
`define EXEC_SLTI       6'b001010
`define EXEC_SLTIU      6'b001011
//
`define EXEC_CLZ        6'b100000
`define EXEC_CLO        6'b100001

`define EXEC_PREF       6'b110011
`define EXEC_SPECIAL    6'b000000
`define EXEC_SPECIAL2   6'b011100

`define EXEC_OP_NOP     8'b00000000
////
`define EXEC_OP_MOVE    8'b10101010
`define EXEC_OP_MFHI    8'b10100110
`define EXEC_OP_MFLO    8'b10101001
`define EXEC_OP_MTHI    8'b10100110
`define EXEC_OP_MTLO    8'b10101001

///
`define EXEC_OP_AND     8'b00100100
`define EXEC_OP_OR      8'b00100101
`define EXEC_OP_XOR     8'b00100110
`define EXEC_OP_NOR     8'b00100111
//
`define EXEC_OP_LUI     8'b01011100   
`define EXEC_OP_SLL     8'b01111100
`define EXEC_OP_SLLV    8'b00000100
`define EXEC_OP_SRL     8'b00000010
`define EXEC_OP_SRLV    8'b00000110
`define EXEC_OP_SRA     8'b00000011
`define EXEC_OP_SRAV    8'b00000111
//
`define EXEC_OP_ADD     8'b10000000
`define EXEC_OP_ADDU    8'b10000100
`define EXEC_OP_SUB     8'b10001000
`define EXEC_OP_SUBU    8'b10001100
`define EXEC_OP_SLT     8'b10101000
`define EXEC_OP_SLTU    8'b10101100
`define EXEC_OP_CLZ     8'b10101001
`define EXEC_OP_CLO     8'b10101101
//
`define EXEC_OP_MUL     8'b10111101
`define EXEC_OP_MULT    8'b10101111
`define EXEC_OP_MULTU   8'b10111100
`define EXEC_OP_MADD       6'b000000
`define EXEC_OP_MADDU      6'b000001
`define EXEC_OP_MSUB       6'b000100
`define EXEC_OP_MSUBU      6'b000101
`define EXEC_DIV           6'b000101
`define EXEC_OP_DIV        6'b000101
//
`define EXEC_RES_MOVE   3'b011
`define EXEC_RES_LOGIC  3'b001
`define EXEC_RES_NOP    3'b000
`define EXEC_RES_SHIFT  3'b000
`define EXEC_RES_ARITH  3'b100
//BUS WIDTHE
`define REG_BUS_WIDTH   4:0
`define REG_DATA_WIDTH  31:0
`define SYS_DATA_WIDTH  31:0
