`timescale 1ns / 1ps
`include "constants.vh"

module control(
    input [10:0] opcode,
    output reg readreg2_control,
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg reg_write,
    output reg branch_if_zero,
    output reg branch,
    output reg branch_if_not_zero,
    output reg alu_src,
    output reg [1:0] alu_op
);
    
    always @* begin
        casex(opcode)
            `ADD, `SUB, `AND, `ORR:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op} <= 'b00001000010;
            `LDUR, `LDURB, `LDURH, `LDURSW:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op} <= 'b01011000100;
            `STUR, `STURB, `STURH, `STURW:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op} <= 'b10100000100;
            `CBZ:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op} <= 'b10000100001;
            `CBNZ:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op} <= 'b10000001001;
            `B:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op} <= 'b00000100001;
            default:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op} <= 'b00000000000;
        endcase
    end  
    
endmodule