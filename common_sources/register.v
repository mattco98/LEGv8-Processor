`timescale 1ns / 1ps
`include "constants.vh"

module register #(parameter SIZE=`WORD) (
    input clk,
    input reset,
    input [`WORD-1:0] D,
    output reg [`WORD-1:0] Q
);

    initial Q <= `WORD'b0;
    
    always @(posedge(clk), posedge(reset))
        Q <= (reset == 1'b1) ? `WORD'b0 : D;

endmodule