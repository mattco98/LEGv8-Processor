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
`define ALU_LSL      4'b1000
`define ALU_LSR      4'b1001

/////////////
// OPCODES //
/////////////
`define ADD     11'b10001011000
`define ADDI    11'b1001000100?
`define ADDS    11'b10101011000
`define ADDIS   11'b1011000100?
`define AND     11'b10001010000
`define ANDI    11'b1001001000?
`define ANDS    11'b11101010000
`define ANDIS   11'b1111001000?
`define B       11'b000101?????
`define BL      11'b100101?????
`define BR      11'b11010110000
`define BCOND   11'b01010100???
`define CBZ     11'b10110100???
`define CBNZ    11'b10110101???
`define CMP     11'b01001011011
`define CMPI    11'b1100001110?
`define EOR     11'b11001010000
`define EORI    11'b1101001000?
`define LDA     11'b10010110101
`define LDUR    11'b11111000010
`define LDURB   11'b00111000010
`define LDURH   11'b01111000010
`define LDURSW  11'b10111000100
`define LSL     11'b11010011011
`define LSR     11'b11010011010
`define MOV     11'b10010011110
`define MOVK    11'b111100101??
`define MOVZ    11'b110100101??
`define MUL     11'b10011011000
`define ORR     11'b10101010000
`define ORRI    11'b1011001000?
`define SMULH   11'b10011011010
`define STUR    11'b11111000000
`define STURB   11'b00111000000
`define STURH   11'b01111000000
`define STURW   11'b10111000000
`define SUB     11'b11001011000
`define SUBI    11'b1101000100?
`define SUBS    11'b11101011000
`define SUBIS   11'b1111000100?
`define UMULH   11'b10011011110

//////////////////////////////////
// CONDITIONAL BRANCH RT VALUES //
//////////////////////////////////
`define BCOND_NV  5'b00000
`define BCOND_EQ  5'b00001
`define BCOND_NE  5'b00010
`define BCOND_CS  5'b00011
`define BCOND_LE  5'b00100
`define BCOND_CC  5'b00101
`define BCOND_MI  5'b00111
`define BCOND_PL  5'b01000
`define BCOND_VS  5'b01001
`define BCOND_VC  5'b01010
`define BCOND_HI  5'b01011
`define BCOND_LS  5'b01100
`define BCOND_GE  5'b01101
`define BCOND_LT  5'b01110
`define BCOND_GT  5'b01111
`define BCOND_AL  5'b11111

////////////////////////////
// CONDITIONAL BRANCH OPS //
////////////////////////////
`define BCOND_OP_NONE    3'b000
`define BCOND_OP_BRANCH  3'b001
`define BCOND_OP_COND    3'b010
`define BCOND_OP_ZERO    3'b011
`define BCOND_OP_NZERO   3'b100
`define BCOND_OP_ALU     3'b101
`define BCOND_OP_NOINC   3'b110

