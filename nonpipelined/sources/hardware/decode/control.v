`timescale 1ns / 1ps
`include "constants.vh"

module control(
    input [10:0] opcode,
    output reg readreg2_control,
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg reg_write,
    output reg branch,
    output reg unconditional_branch,
    output reg alu_src,
    output reg [1:0] alu_op
);
    
    always @* begin
        casex(opcode)
            `ADD, `SUB, `AND, `ORR:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch, unconditional_branch, alu_src, alu_op} <= 'b0000100010;
            `LDUR:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch, unconditional_branch, alu_src, alu_op} <= 'b0101100100;
            `STUR:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch, unconditional_branch, alu_src, alu_op} <= 'b1010000100;
            `CBZ:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch, unconditional_branch, alu_src, alu_op} <= 'b1000010001;
            `B:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch, unconditional_branch, alu_src, alu_op} <= 'b0000010001;
            default:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch, unconditional_branch, alu_src, alu_op} <= 'b0000000000;
        endcase
    end  
    
endmodule