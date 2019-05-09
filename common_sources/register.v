`timescale 1ns / 1ps
`include "constants.vh"


module register #(parameter SIZE=`WORD) (
    input                 clk,
    input                 reset,
    input      [SIZE-1:0] D,
    output reg [SIZE-1:0] Q
);

    initial Q <= 'b0;
    
    always @(posedge clk, reset)
        Q <= (reset == 1'b1 ? 'b0 : D);

endmodule