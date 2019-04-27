`timescale 1ns / 1ps
`include "constants.vh"


module mux3 #(parameter SIZE=`WORD) (
    input  [SIZE-1:0] a,
    input  [SIZE-1:0] b,
    input  [SIZE-1:0] c,
    input  [1:0] control,
    output [SIZE-1:0] out
);

    assign out = control == 2'b00 ? a : (control == 2'b01 ? b : c);

endmodule
