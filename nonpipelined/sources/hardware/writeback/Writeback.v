`timescale 1ns / 1ps
`include "constants.vh"


module Writeback(
    input  [`WORD-1:0] alu_result,
                       read_data,
                       pc,
    input  [1:0] mem_to_reg,
    input  [10:0] opcode,
    output [`WORD-1:0] write_back
);

    wire [`WORD-1:0] write_back_internal;

    mux3 MUX(
        .a(alu_result),
        .b(read_data),
        .c(pc + 4),
        .control(mem_to_reg),
        .out(write_back_internal)
    );
    
    write_data_transformer WRITE_DATA_TRANSFORMER(write_back_internal, opcode, write_back);
    
endmodule
