`timescale 1ns / 1ps
`include "constants.vh"

module instr_parse(
    input [`INSTR_LEN-1:0] instruction,
    output [4:0]  rm, rn, rd,
    output [8:0]  address,
    output [10:0] opcode
);

    assign opcode  = instruction[31:21];
    assign address = instruction[20:12];
    assign rm      = instruction[20:16];
    assign rn      = instruction[9:5];
    assign rd      = instruction[4:0];

endmodule