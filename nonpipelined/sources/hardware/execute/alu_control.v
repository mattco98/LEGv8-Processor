`timescale 1ns / 1ps
`include "constants.vh"

module alu_control(
    input  [1:0] alu_op,
    input  [10:0] opcode,
    output reg [3:0] alu_control
);

    always @* begin
        casex(alu_op)
            2'b00:   alu_control <= `ALU_ADD; // D type instructions
            2'b01:   alu_control <= `ALU_PASS_B; // Branch type instructions
            2'b10:   alu_control <= (opcode[0] == 0 ? `ALU_LSR : `ALU_LSL);
            default: alu_control <= {1'b0, opcode[9], opcode[3], opcode[8]}; // R type instructions 
        endcase
    end

endmodule