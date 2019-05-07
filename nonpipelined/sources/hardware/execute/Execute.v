`timescale 1ns / 1ps
`include "constants.vh"

module Execute(
    input clk,
          reset,
    input [`WORD-1:0] pc,
                      sign_extended_instr,
                      read_data1,
                      read_data2,
    input [10:0] opcode,
    input alu_src, update_sreg, execute_result_loc, mult_start,
    input [3:0] alu_op,
    
    output [`WORD-1:0] branch_alu_result,
                       alu_result,
    output zero, negative, overflow, carry, stall, multiplier_done
);

    // Branch ALU
    wire [`WORD-1:0] shifted_instr;
    
    left_shift #(`WORD) LEFT_SHIFT(
        .in(sign_extended_instr),
        .out(shifted_instr)
    );
    
    adder ADDER(
        .a(pc),
        .b(shifted_instr),
        .out(branch_alu_result)
    );
    
    // ALU
    wire [`WORD-1:0] alu_input_b, alu_result_buff;
    wire negative_internal, zero_internal, carry_internal, overflow_internal;
    
    mux2 #(`WORD) ALU_MUX(
        .a(read_data2),
        .b(sign_extended_instr),
        .control(alu_src),
        .out(alu_input_b)
    );
    
    alu MAIN_ALU(
        .a(read_data1),
        .b(alu_input_b),
        .alu_op(alu_op),
        .negative(negative_internal),
        .zero(zero_internal),
        .carry(carry_internal),
        .overflow(overflow_internal),
        .result(alu_result_buff)
    );
    
    status_register SREG(
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
    wire [`WORD-1:0] multiplier_result;
    
    multiplier MULTIPLIER(
        .clk(clk),
        .reset(reset),
        .start(mult_start),
        .a(read_data1),
        .b(alu_input_b),
        .result(multiplier_result),
        .stall(stall),
        .done(multiplier_done)
    );
    
    mux2 ALU_RESULT_MUX(
        .a(alu_result_buff),
        .b(multiplier_result),
        .control(execute_result_loc),
        .out(alu_result)
    );

endmodule