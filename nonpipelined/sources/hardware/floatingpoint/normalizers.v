`timescale 1ns / 1ps


module normalizers(
    input      [7:0]  exp_in,
    input      [278:0] mant_in, 
    output reg [7:0]  exp_out,
    output reg [278:0] mant_out
);

    always @* begin
        exp_out  = exp_in;
        mant_out = mant_in;
        
        repeat(255) begin
            if (mant_out[278] == 0) begin
                exp_out = exp_out - 1;
                mant_out = mant_out << 1;
            end
        end
    end

endmodule
