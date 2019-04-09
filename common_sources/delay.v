`timescale 1ns / 1ps
`include "constants.vh"

module delay #(parameter DELAY_NS = 0) (
    input in,
    output reg out
);

    initial out <= in;
    
    always @* out <= #DELAY_NS in;

endmodule
