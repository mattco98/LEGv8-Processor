`timescale 1ns / 1ps
`include "constants.vh"


module status_register(
    input      clk,
    input      reset,
    input      negative_in,
    input      zero_in,
    input      carry_in,
    input      overflow_in,
    input      update_sreg,
    output reg negative_out,
    output reg zero_out,
    output reg carry_out,
    output reg overflow_out
);

    always @(posedge clk, reset)
        if (reset) begin
            {negative_out, zero_out, carry_out, overflow_out} <= 4'b0000;
        end 
        else if (update_sreg) begin
            negative_out <= negative_in;
            zero_out <= zero_in;
            carry_out <= carry_in;
            overflow_out <= overflow_in;
        end

endmodule
