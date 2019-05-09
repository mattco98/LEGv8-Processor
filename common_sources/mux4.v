`timescale 1ns / 1ps
`include "constants.vh"


module mux4 #(parameter SIZE=`WORD)(
    input      [SIZE-1:0] a, 
    input      [SIZE-1:0] b,
    input      [SIZE-1:0] c,
    input      [SIZE-1:0] d,
    input      [1:0]      control,
    output reg [SIZE-1:0] out
);

    always @*
        case(control)
            'b00: out <= a;
            'b01: out <= b;
            'b10: out <= c;
            'b11: out <= d;
        endcase

endmodule
