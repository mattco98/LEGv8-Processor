`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"

module Decode #(parameter PATH=`REGISTER_FILE) (
    input read_clk,
    input write_clk,
    input reset,
    input stall, multiplier_done,
    input [`INSTR_LEN-1:0] instruction,
    input [`WORD-1:0] write_data,
    
    output [`WORD-1:0] extended_instruction,
    output [10:0] opcode,
    output [`WORD-1:0] read_data1, read_data2,
    
    output mem_read,
           mem_write,
           alu_src,
           reg_write,
           update_sreg,
           execute_result_loc,
           mult_start,
    output [2:0] branch_op,
    output [1:0] mem_to_reg,
    output [3:0] alu_op
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
    
    wire readreg2_control, write_reg_src;
    
    control CONTROL(
        .opcode(opcode),
        .stall(stall),
        .multiplier_done(multiplier_done),
        .readreg2_control(readreg2_control),
        .branch_op(branch_op),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .alu_op(alu_op),
        .update_sreg(update_sreg),
        .write_reg_src(write_reg_src),
        .execute_result_loc(execute_result_loc),
        .mult_start(mult_start)
    );
    
    wire [4:0] read_reg2;
    
    mux2 #(5) READ_REG_2_MUX(
        .a(rm),
        .b(rd),
        .control(readreg2_control),
        .out(read_reg2)
    );
    
    wire [4:0] write_reg;
    
    mux2 #(5) WRITE_REG_MUX(
        .a(rd),
        .b(5'd30),
        .control(write_reg_src),
        .out(write_reg)
    );
    
    register_memory #(PATH) REG_MEM(
        .read_clk(read_clk),
        .write_clk(write_clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_reg1(rn),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    
    sign_extender SIGN_EXTENDER(
        .instruction(instruction),
        .out(extended_instruction)
    );

endmodule





