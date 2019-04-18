`timescale 1ns / 1ps
`include "constants.vh"

module alu(
    input signed [`WORD-1:0] a,
    input signed [`WORD-1:0] b,
    input [3:0] alu_control,
    output signed [`WORD-1:0] result,
    output zero,
    output negative,
    output carry,
    output reg overflow
);
    
    reg signed [`WORD:0] buff;
    reg is_signed = 1; // TODO: Will need to add logic here to determine signed-ness from opcode.
                       // Right now, every number is interpreted as signed

    assign result = buff[`WORD-1:0];
    assign zero = result == 0;
    assign negative = result < 0;
    assign carry = is_signed ? 1'bZ : (buff[`WORD] ? 1 : 0);
    //assign carry = (~is_signed && buff[`WORD]) ? 1'b1 : ((is_signed) ? 1'bZ : 1'b0);

    always @* begin
        overflow = 0;
        
        case(alu_control)
            `ALU_AND: 
                buff = a & b;
            `ALU_OR:   
                buff = a | b;
            `ALU_ADD: begin      
                buff = a + b;
                if (a > 0 && b > 0 && buff[`WORD-1] == 1) overflow = 1;
                else if (a < 0 && b < 0 && buff[`WORD-1] == 0) overflow = 1;          
            end
            `ALU_SUBTRACT: begin
                buff = a - b;
                if (a > 0 && b < 0 && buff[`WORD-1] == 1) overflow = 1;
                else if (a < 0 && b > 0 && buff[`WORD-1] == 0) overflow = 1;
            end
            `ALU_PASS_B:   
                buff = b;
            `ALU_NOR:      
                buff = ~(a | b);
            `ALU_XOR:      
                buff = a ^ b;
        endcase
        
        if (~is_signed) overflow = 1'bZ;
    end
    
endmodule