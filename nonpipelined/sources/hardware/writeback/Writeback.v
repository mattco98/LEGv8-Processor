`timescale 1ns / 1ps
`include "constants.vh"


module Writeback(
    input  [`WORD-1:0] alu_result,
                       read_data,
                       pc,
    input  [1:0] mem_to_reg,
    output [`WORD-1:0] write_back
);

    mux3 MUX(
        .a(alu_result),
        .b(read_data),
        .c(pc + 4),
        .control(mem_to_reg),
        .out(write_back)
    );

endmodule
