`timescale 1ns / 1ps
`include "constants.vh"

module delay #(parameter DELAY_NS = 0) (
    input clk,
    output reg clk_delayed
);

    initial clk_delayed <= clk;
    
    always @* clk_delayed <= #DELAY_NS clk;

endmodule
