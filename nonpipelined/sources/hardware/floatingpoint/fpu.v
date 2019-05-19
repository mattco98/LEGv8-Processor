`timescale 1ns / 1ps
`include "constants.vh"


module fpu(
    input      [63:0] a,
    input      [63:0] b,
    input      [2:0]  fpu_op,
    input             double,
    output reg [63:0] result
);

    wire [31:0] adds_out;
    wire [63:0] addd_out;
    wire [31:0] muls_out;
    wire [63:0] muld_out;
    wire [31:0] divs_out;
    wire [63:0] divd_out;

    fadders fadders(
        .a(a[31:0]),
        .b(fpu_op == `FPU_SUB ? {~b[31], b[30:0]} : b[31:0]),
        .out(adds_out)
    );
    
    /*
    fadderd fadderd(
        .a(a),
        .b(b),
        .out(addd_out)
    );
    */
    
    always @* begin
        casez(fpu_op)
            `FPU_ADD, `FPU_SUB: 
                result <= double ? addd_out : {32'b0, adds_out};
            `FPU_MUL:
                result <= double ? muld_out : {32'b0, muls_out};
            `FPU_DIV:
                result <= double ? divd_out : {32'b0, divs_out};
        endcase
    end

endmodule