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
    output reg update_sreg,
    output reg [2:0] branch_op // 000 => no branch, 001 => branch, 010 => branch_conditionally, 011 => branch_if_zero, 100 => branch_if_not_zero
);
    
    always @* begin
        casex(opcode)
            `ADD, `SUB, `AND, `ORR:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, alu_src, alu_op, update_sreg, branch_op} <= 'b0_0_0_0_1_0_10_0_000;
            `ADDS, `ANDS, `SUBS:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, alu_src, alu_op, update_sreg, branch_op} <= 'b0_0_0_0_1_0_10_1_000;
            `ADDI, `ANDI, `EORI, `ORRI, `SUBI:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, alu_src, alu_op, update_sreg, branch_op} <= 'b0_0_0_0_1_1_10_0_000;
            `ADDIS, `ANDIS, `SUBS:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, alu_src, alu_op, update_sreg, branch_op} <= 'b0_0_0_0_1_1_10_1_000;
            `LDUR, `LDURB, `LDURH, `LDURSW:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, alu_src, alu_op, update_sreg, branch_op} <= 'b0_1_0_1_1_1_00_0_000;
            `STUR, `STURB, `STURH, `STURW:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, alu_src, alu_op, update_sreg, branch_op} <= 'b1_0_1_0_0_1_00_0_000;
            `CBZ:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, alu_src, alu_op, update_sreg, branch_op} <= 'b1_0_0_0_0_0_01_1_011;
            `CBNZ:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, alu_src, alu_op, update_sreg, branch_op} <= 'b1_0_0_0_0_0_01_1_100;
            `B:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, alu_src, alu_op, update_sreg, branch_op} <= 'b0_0_0_0_0_0_01_0_001;
            `BCOND:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, alu_src, alu_op, update_sreg, branch_op} <= 'b0_0_0_0_0_0_01_0_010;
            default:
                {readreg2_control, mem_read, mem_write, mem_to_reg, reg_write, alu_src, alu_op, update_sreg, branch_op} <= 'b0_0_0_0_0_0_00_0_000;
        endcase
    end  
    
endmodule