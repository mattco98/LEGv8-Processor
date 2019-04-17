`timescale 1ns / 1ps
`include "files.vh"
`include "constants.vh"

module instruction_mem #(parameter PATH=`INSTRUCTION_FILE, parameter SIZE=1024) (
    input clk,
    input [`WORD-1:0] address,
    output reg [`INSTR_LEN-1:0] instruction
);

    reg [`INSTR_LEN-1:0] instruction_memory [SIZE-1:0];
    
    initial 
        $readmemb(PATH, instruction_memory);
    
    always @(posedge clk) 
        instruction <= instruction_memory[address / 4];

endmodule