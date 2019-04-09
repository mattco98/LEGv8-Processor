`timescale 1ns / 1ps

module mux #(parameter SIZE=4) (
    input [SIZE-1:0] a,
    input [SIZE-1:0] b,
    input control,
    output [SIZE-1:0] out
);

    assign out = control == 1'b0 ? a : b;

endmodule