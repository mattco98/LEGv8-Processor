`define NIBBLE 4
`define BYTE 8
`define WORD 64
`define HALFWORD 32
`define INSTR_LEN `HALFWORD

`define CYCLE 10

//////////////////////
// ALU Control Bits //
//////////////////////
`define ALU_AND      4'b0000
`define ALU_OR       4'b0001
`define ALU_ADD      4'b0010
`define ALU_SUBTRACT 4'b0110
`define ALU_PASS_B   4'b0111
`define ALU_NOR      4'b1100
`define ALU_XOR      4'b0100

/////////////
// OPCODES //
/////////////
`define ADD   11'b10001011000
`define AND   11'b10001010000
`define B     11'b000101XXXXX
`define CBZ   11'b10110100XXX
`define EOR   11'b11001010000
`define LDUR  11'b11111000010
`define ORR   11'b10101010000
`define STUR  11'b11111000000
`define SUB   11'b11001011000