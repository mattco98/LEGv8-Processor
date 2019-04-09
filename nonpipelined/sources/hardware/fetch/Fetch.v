`timescale 1ns / 1ps
`include "constants.vh"


module Fetch(
    input clk,
    input instr_mem_clk,
    input reset,
    input pc_src,
    input [`WORD-1:0] branch_target,
    output [`INSTR_LEN-1:0] instruction,
    output [`WORD-1:0] cur_pc
);

    wire [`WORD-1:0] new_pc, incremented_pc;
    
    register PC(
        .clk(clk),
        .reset(reset),
        .D(new_pc),
        .Q(cur_pc)
    );
    
    mux #(`WORD) MUX(
        .a(incremented_pc),
        .b(branch_target),
        .control(pc_src),
        .out(new_pc)
    );
    
    assign incremented_pc = cur_pc + `WORD'd4;
    
    instruction_mem INSTR_MEM(
        .clk(instr_mem_clk),
        .address(cur_pc),
        .instruction(instruction)
    );

endmodule