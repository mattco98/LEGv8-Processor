`timescale 1ns / 1ps
`include "constants.vh"


module fadders(
    input  [31:0] a, 
    input  [31:0] b,
    output [31:0] out
);

    wire        a_sign;
    wire        b_sign;
    reg         out_sign;
    wire [7:0]  a_exp;
    wire [7:0]  b_exp;
    reg  [7:0]  out_exp;
    wire [47:0] a_mant;
    wire [47:0] b_mant;
    reg  [48:0] out_mant;
    reg  [47:0] a_mant_norm;
    reg  [47:0] b_mant_norm;
    
    assign a_sign = a[31];
    assign b_sign = b[31];
    assign a_exp = a[30-:8];
    assign b_exp = b[30-:8];
    assign a_mant = {1'b1, a[0+:23], 24'b0};
    assign b_mant = {1'b1, b[0+:23], 24'b0};
    
    reg  [7:0]  norm_exp_in;
    wire [7:0]  norm_exp_out;
    reg  [47:0] norm_mant_in;
    wire [47:0] norm_mant_out;
    
    normalizers normalizers(
        .exp_in(norm_exp_in),
        .exp_out(norm_exp_out),
        .mant_in(norm_mant_in),
        .mant_out(norm_mant_out)
    );
    
    assign out = {out_sign, norm_exp_out, norm_mant_out[46-:23]};
    
    always @* begin
        if (a_exp == 'b0 && a_mant == 'b0) begin
            {out_sign, out_exp, out_mant} = {b_sign, b_exp, b_mant};
        end
        else if (b_exp == 'b0 && b_mant == 'b0) begin
            {out_sign, out_exp, out_mant} = {a_sign, a_exp, a_mant};
        end
        else if (a_exp == 'd255) begin
            {out_sign, out_exp, out_mant} = {a_sign, a_exp, a_mant};
        end
        else if (b_exp == 'd255) begin
            {out_sign, out_exp, out_mant} = {b_sign, b_exp, b_mant};
        end
        else if (a_exp == b_exp) begin
            out_exp = a_exp;
            
            if (a_sign == b_sign) begin
                out_sign = a_sign;
                out_mant = a_mant + b_mant;
            end
            else if (a_mant > b_mant) begin
                out_sign = a_sign;
                out_mant = a_mant - b_mant;
            end else if (b_mant > a_mant) begin
                out_sign = b_sign;
                out_mant = b_mant - a_mant;
            end
        end
        else if (a_exp > b_exp) begin
            out_exp = a_exp;
            out_sign = a_sign; 
            a_mant_norm = a_mant;
            b_mant_norm = b_mant >> (a_exp - b_exp);
            
            if (a_sign == b_sign)
                out_mant = a_mant_norm + b_mant_norm;
            else
                out_mant = a_mant_norm - b_mant_norm;
        end
        else if (a_exp < b_exp) begin
            out_exp = b_exp;
            out_sign = b_sign;
            a_mant_norm = a_mant >> (b_exp - a_exp);
            b_mant_norm = b_mant;
            
            if (a_sign == b_sign)
                out_mant = b_mant_norm + a_mant_norm;
            else
                out_mant = b_mant_norm - a_mant_norm;
        end
        
        if (out_mant[48]) begin
            out_exp = out_exp + 1;
            out_mant = out_mant >> 1;
        end
        
        if (out_mant != 'b0) begin
            norm_mant_in = out_mant[47:0];
            norm_exp_in  = out_exp;
        end
        else begin
            norm_mant_in = {2'b01, 46'b0};
            norm_exp_in =  out_exp;
        end
    end
    
//    wire [10:0] max_exp  = a_exp > b_exp ? a_exp : b_exp;
//    wire [10:0] min_exp  = a_exp > b_exp ? b_exp : a_exp;
//    wire [10:0] diff_exp = max_exp - min_exp;
    
//    wire [52:0] a_mant_norm = a_exp < b_exp ? a_mant >> diff_exp : a_mant;
//    wire [52:0] b_mant_norm = a_exp < b_exp ? b_mant : b_mant >> diff_exp;
    
//    wire [53:0] out_mant = 
//        a_sign == 0 && b_sign == 0 ? a_mant_norm + b_mant_norm : 
//        a_sign == 0 && b_sign == 1 ? a_mant_norm - b_mant_norm :
//        a_sign == 1 && b_sign == 0 ? b_mant_norm - a_mant_norm : 
//        -a_mant_norm - b_mant_norm;
    
//    //wire [53:0] out_mant = a_mant_norm + b_mant_norm;
    
//    assign out = double ? {
//        1'b0,
//        max_exp + out_mant[53],
//        out_mant[53] ? out_mant[52:1] : out_mant[51:0]
//    } : {
//        33'b0,
//        max_exp[8:0] + out_mant[53],
//        out_mant[53] ? out_mant[52-:23] : out_mant[51-:23]
//    };

endmodule













