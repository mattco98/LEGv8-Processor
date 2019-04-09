`timescale 1ns / 1ps
`include "files.vh"
`include "constants.vh"

module instruction_mem #(parameter SIZE=1024)(
    input clk,
    input [`WORD-1:0] address,
    output reg [`INSTR_LEN-1:0] instruction
);

    reg [`INSTR_LEN-1:0] instruction_memory [SIZE-1:0];
    
    initial $readmemb(`INSTRUCTION_FILE, instruction_memory);
    
    always @(posedge(clk)) instruction = instruction_memory[address / 4];

endmodule