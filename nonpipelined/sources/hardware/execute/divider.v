`timescale 1ns / 1ps


module divider #(parameter SIZE=4) (
    input             clk,
    input             reset,
    input             start, 
    input             is_signed,
    input  [SIZE-1:0] dividend,
    input  [SIZE-1:0] divisor,
    output [SIZE-1:0] quotient,
    output [SIZE-1:0] remainder,
    output reg        stall,
    output reg        done
);

    reg              is_signed_b;
    reg [SIZE/2:0]   i;
    reg              active;
    reg              sign_dividend;
    reg              sign_divisor;
    reg [SIZE-1:0]   dividend_b;
    reg [SIZE-1:0]   divisor_b;
    reg [SIZE*2-1:0] quotient_b;
    
    assign quotient  = quotient_b[SIZE-1:0];
    assign remainder = (quotient_b[SIZE*2-1:SIZE] >> 1) | (is_signed_b && sign_dividend ? 'b1 << (SIZE-1) : 0);
    
    // TODO: The concatenation later on literally will not work unless these are
    // their own signals. When you stick the expression together directly in a concatenate,
    // it breaks
    // ????????????????????????
    wire [SIZE-1:0] __why_do_i_need_this_signal_1 = sign_dividend ? ~quotient_b[SIZE*2-1:SIZE] + 'b1 : quotient_b[SIZE*2-1:SIZE];
    wire [SIZE-1:0] __why_do_i_need_this_signal_2 = sign_dividend != sign_divisor ? ~quotient_b[SIZE-1:0] + 'b1 : quotient_b[SIZE-1:0];
    
    always @(posedge reset) begin
        quotient_b = 0;
        dividend_b = 0;
        divisor_b = 0;
        active = 0;
        i = 0;
        done = 0;
        stall = 0;
        is_signed_b = 0;
    end
    
    always @(posedge clk) begin
        if (start) begin
            stall = 1;
            active = 1;
            is_signed_b = is_signed;
            divisor_b = is_signed_b && divisor[SIZE-1] ? (~divisor + 1) : divisor;
            dividend_b = is_signed_b && dividend[SIZE-1] ? (~dividend + 1) : dividend;
            quotient_b = {{SIZE{1'b0}}, dividend_b} << 1;
            i = 0;
            done = 0;
            sign_divisor = divisor[SIZE-1];
            sign_dividend = dividend[SIZE-1];
        end
        else if (i == SIZE) begin
            active = 0;
            stall = 0;
            done = 1;
            i = 0;
            if (is_signed_b) begin
                quotient_b = {__why_do_i_need_this_signal_1, __why_do_i_need_this_signal_2};
            end
        end
        else if (active) begin
            if ((quotient_b[SIZE*2-1:SIZE] - divisor_b) >> (SIZE - 1)) 
                quotient_b = quotient_b << 1;
            else 
                quotient_b = ({quotient_b[SIZE*2-1:SIZE] - divisor_b, quotient[SIZE-1:0]} << 1) | 'b1;
            i = i + 1;
        end
        else if (done) 
            done = 0;
    end

endmodule






