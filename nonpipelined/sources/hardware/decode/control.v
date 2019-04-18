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
    output reg [1:0] alu_op,
    output reg update_sreg
);
    
    always @* begin
        casex(opcode)
            `ADD, `SUB, `AND, `ORR:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op, update_sreg} <= 'b000010000100;
            `ADDS, `ANDS, `SUBS:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op, update_sreg} <= 'b000010000101;
            `ADDI, `ANDI, `EORI, `ORRI, `SUBI:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op, update_sreg} <= 'b000010001100;
            `ADDIS, `ANDIS, `SUBS:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op, update_sreg} <= 'b000010001101;
            `LDUR, `LDURB, `LDURH, `LDURSW:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op, update_sreg} <= 'b010110001000;
            `STUR, `STURB, `STURH, `STURW:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op, update_sreg} <= 'b101000001000;
            `CBZ:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op, update_sreg} <= 'b100001000011;
            `CBNZ:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op, update_sreg} <= 'b100000010011;
            `B:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op, update_sreg} <= 'b000000100010;
            default:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, branch_if_zero, branch, branch_if_not_zero, alu_src, alu_op, update_sreg} <= 'b000000000000;
        endcase
    end  
    
endmodule