`timescale 1ns / 1ps


module left_shift #(parameter SIZE=64, AMT=2) (
    input  [SIZE-1:0] in,
    output [SIZE-1:0] out
);

    assign out = in << AMT;

endmodule
