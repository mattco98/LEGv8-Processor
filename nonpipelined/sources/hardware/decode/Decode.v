`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"

module Decode #(parameter PATH=`REGISTERS_FILE) (
    input read_clk,
    input write_clk,
    input [`INSTR_LEN-1:0] instruction,
    input [`WORD-1:0] write_data,
    
    output [`WORD-1:0] extended_instruction,
    output [10:0] opcode,
    output [`WORD-1:0] read_data1, read_data2,
    
    output branch,
           branch_if_zero,
           branch_if_not_zero,
           mem_read,
           mem_to_reg,
           mem_write,
           alu_src,
           reg_write,
    output [1:0] alu_op
);

    wire [4:0] rm, rn, rd;
    wire [8:0] address;
    
    instr_parse INSTR_PARSE(
        .instruction(instruction),
        .rm(rm),
        .rn(rn),
        .rd(rd),
        .address(address),
        .opcode(opcode)
    );
    
    wire readreg2_control;
    
    control CONTROL(
        .opcode(opcode),
        .readreg2_control(readreg2_control),
        .branch(branch),
        .branch_if_zero(branch_if_zero),
        .branch_if_not_zero(branch_if_not_zero),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .alu_op(alu_op)
    );
    
    wire [4:0] read_reg2;
    
    mux #(5) READ_REG_2_MUX(
        .a(rm),
        .b(rd),
        .control(readreg2_control),
        .out(read_reg2)
    );
    
    register_memory #(PATH) REG_MEM(
        .read_clk(read_clk),
        .write_clk(write_clk),
        .reg_write(reg_write),
        .read_reg1(rn),
        .read_reg2(read_reg2),
        .write_reg(rd),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    sign_extender SIGN_EXTENDER(
        .instruction(instruction),
        .out(extended_instruction)
    );

endmodule





