`define NIBBLE 4
`define BYTE 8
`define WORD 64
`define HALFWORD 32
`define INSTR_LEN `HALFWORD

`define CYCLE 10

/////////////
// OPCODES //
/////////////
`define ADD   11'b10001011000
`define SUB   11'b11001011000
`define AND   11'b10001010000
`define ORR   11'b10101010000
`define LDUR  11'b11111000010
`define STUR  11'b11111000000
`define CBZ   11'b10110100XXX
`define B     11'b000101XXXXX