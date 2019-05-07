`timescale 1ns / 1ps
`include "constants.vh"

module mux4 #(parameter SIZE=`WORD)(
    input [SIZE-1:0] a, b, c, d,
    input [1:0] control,
    output reg [SIZE-1:0] out
);

    always @* begin
        case(control)
            'b00: out <= a;
            'b01: out <= b;
            'b10: out <= c;
            'b11: out <= d;
        endcase
    end

endmodule
