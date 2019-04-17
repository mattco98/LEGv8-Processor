`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"


module Fetch #(parameter PATH=`INSTRUCTION_FILE) (
    input clk,
    input instr_mem_clk,
    input reset,
    input pc_src,
    input [`WORD-1:0] branch_target,
    output [`INSTR_LEN-1:0] instruction,
    output [`WORD-1:0] pc
);

    wire [`WORD-1:0] new_pc, incremented_pc;
    
    register PC(
        .clk(clk),
        .reset(reset),
        .D(new_pc),
        .Q(pc)
    );
    
    mux #(`WORD) MUX(
        .a(incremented_pc),
        .b(branch_target),
        .control(pc_src),
        .out(new_pc)
    );
    
    assign incremented_pc = pc + `WORD'd4;
    
    instruction_mem #(PATH) INSTR_MEM(
        .clk(instr_mem_clk),
        .address(pc),
        .instruction(instruction)
    );

endmodule