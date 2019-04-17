`timescale 1ns / 1ps
`include "constants.vh"


module adder #(parameter SIZE=`WORD)(
    input  [SIZE-1:0] a,
    input  [SIZE-1:0] b,
    output [SIZE-1:0] out
);

    assign out = a + b;

endmodule
