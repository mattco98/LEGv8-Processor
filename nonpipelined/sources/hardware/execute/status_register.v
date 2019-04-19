`timescale 1ns / 1ps
`include "constants.vh"

module status_register(
    input  clk,
           reset,
           negative_in,
           zero_in,
           carry_in,
           overflow_in,
           update_sreg,
    output reg negative_out,
           zero_out,
           carry_out,
           overflow_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            {negative_out, zero_out, carry_out, overflow_out} <= 4'b0000;
        end else if (update_sreg) begin
            negative_out <= negative_in;
            zero_out <= zero_in;
            carry_out <= carry_in;
            overflow_out <= overflow_in;
        end
    end

endmodule
