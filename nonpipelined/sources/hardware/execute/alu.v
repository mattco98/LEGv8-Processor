`timescale 1ns / 1ps
`include "constants.vh"


module alu(
    input  signed [`WORD-1:0] a,
    input  signed [`WORD-1:0] b,
    input         [3:0]       alu_op,
    output signed [`WORD-1:0] result,
    output                    zero,
    output                    negative,
    output                    carry,
    output reg                overflow
);
    
    reg  signed [`WORD:0] buff;
    wire buff_msb = buff[`WORD]; 

    assign result = buff[`WORD-1:0];
    assign zero = result == 0;
    assign negative = result < 0;
    assign carry = 1; // Numbers are always signed

    always @* begin
        overflow = 0;
        
        case(alu_op)
            `ALU_AND: 
                buff = a & b;
            `ALU_OR:   
                buff = a | b;
            `ALU_ADD: begin      
                buff = a + b;
                if (a > 0 && b > 0 && buff_msb == 1) overflow = 1;
                else if (a < 0 && b < 0 && buff_msb == 0) overflow = 1;          
            end
            `ALU_SUBTRACT: begin
                buff = a - b;
                if (a > 0 && b < 0 && buff_msb == 1) overflow = 1;
                else if (a < 0 && b > 0 && buff_msb == 0) overflow = 1;
            end
            `ALU_PASS_B:   
                buff = b;
            `ALU_NOR:      
                buff = ~(a | b);
            `ALU_XOR:      
                buff = a ^ b;
            `ALU_LSL:
                buff = a << b;
            `ALU_LSR:
                buff = a >> b;
        endcase
    end
    
endmodule