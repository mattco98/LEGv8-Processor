`timescale 1ns / 1ps
`include "constants.vh"

module alu(
    input [`WORD-1:0] a,
    input [`WORD-1:0] b,
    input [3:0] alu_control,
    output reg [`WORD-1:0] result,
    output zero
);

    assign zero = result == 0;

    always @* begin
        case(alu_control)
            `ALU_AND:      result <= a & b;
            `ALU_OR:       result <= a | b;
            `ALU_ADD:      result <= a + b;
            `ALU_SUBTRACT: result <= a - b;
            `ALU_PASS_B:   result <= b;
            `ALU_NOR:      result <= ~(a | b);
            `ALU_XOR:      result <= a ^ b;
        endcase
    end
    
endmodule