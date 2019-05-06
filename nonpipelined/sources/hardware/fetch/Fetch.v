`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"


module Fetch #(parameter PATH=`INSTRUCTION_FILE) (
    input clk,
    input instr_mem_clk,
    input reset,
    input [1:0] pc_src,
    input [`WORD-1:0] branch_target,
                      alu_result,
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
    
    mux3 #(`WORD) MUX(
        .a(incremented_pc),
        .b(branch_target),
        .c(alu_result),
        .control(pc_src),
        .out(new_pc)
    );
    
    assign incremented_pc = reset ? 0 : (pc + `WORD'd4);
    
    instruction_mem #(PATH) INSTR_MEM(
        .clk(instr_mem_clk),
        .reset(reset),
        .address(pc),
        .instruction(instruction)
    );

endmodule