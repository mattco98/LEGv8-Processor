`timescale 1ns / 1ps
`include "constants.vh"


module Writeback(
    input  [`WORD-1:0] alu_result,
                       read_data,
    input  mem_to_reg,
    output [`WORD-1:0] write_back
);

    mux MUX(
        .a(alu_result),
        .b(read_data),
        .control(mem_to_reg),
        .out(write_back)
    );

endmodule
