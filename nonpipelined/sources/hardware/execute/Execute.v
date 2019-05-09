`timescale 1ns / 1ps
`include "constants.vh"


module Execute(
    input              clk,
    input              reset,
    input  [`WORD-1:0] pc,
    input  [`WORD-1:0] sign_extended_instr,
    input  [`WORD-1:0] read_data1,
    input  [`WORD-1:0] read_data2,
    input  [10:0]      opcode,
    input              alu_src, 
    input              update_sreg, 
    input              execute_result_loc, 
    input              mult_start,
    input  [3:0]       alu_op,
    input  [1:0]       mult_mode,
    output [`WORD-1:0] branch_alu_result,
    output [`WORD-1:0] alu_result,
    output             zero, 
    output             negative,
    output             overflow, 
    output             carry, 
    output             stall, 
    output             multiplier_done
);

    // Branch ALU
    wire [`WORD-1:0] shifted_instr = sign_extended_instr << 2;
    assign branch_alu_result       = pc + shifted_instr;
    
    // ALU
    wire [`WORD-1:0] alu_input_b;
    wire [`WORD-1:0] alu_result_buff;
    wire             negative_internal;
    wire             zero_internal; 
    wire             carry_internal;
    wire             overflow_internal;
    wire [`WORD-1:0] multiplier_result;
    
    mux2 #(.SIZE(`WORD)) mux2_alu(
        .a(read_data2),
        .b(sign_extended_instr),
        .control(alu_src),
        .out(alu_input_b)
    );
    
    alu alu(
        .a(read_data1),
        .b(alu_input_b),
        .alu_op(alu_op),
        .negative(negative_internal),
        .zero(zero_internal),
        .carry(carry_internal),
        .overflow(overflow_internal),
        .result(alu_result_buff)
    );
    
    status_register status_register(
        .clk(clk),
        .reset(reset),
        .update_sreg(update_sreg),
        .negative_in(negative_internal),
        .zero_in(zero_internal),
        .carry_in(carry_internal),
        .overflow_in(overflow_internal),
        .negative_out(negative),
        .zero_out(zero),
        .carry_out(carry),
        .overflow_out(overflow)
    );
    
    // Multiplier
    
    multiplier multiplier(
        .clk(clk),
        .reset(reset),
        .start(mult_start),
        .multiplicand(read_data1),
        .multiplier(alu_input_b),
        .result(multiplier_result),
        .stall(stall),
        .done(multiplier_done),
        .mult_mode(mult_mode)
    );
    
    mux2 mux2_alu_result(
        .a(alu_result_buff),
        .b(multiplier_result),
        .control(execute_result_loc),
        .out(alu_result)
    );

endmodule