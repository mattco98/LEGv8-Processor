`timescale 1ns / 1ps
`include "constants.vh"


module oscillator(
    output reg clk
);

    initial clk <= 0;
    
    always #(`CYCLE/2) clk <= ~clk;

endmodule
