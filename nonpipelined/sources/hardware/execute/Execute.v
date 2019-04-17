`timescale 1ns / 1ps
`include "constants.vh"

module Execute(
    input [`WORD-1:0] pc,
                      sign_extended_instr,
                      read_data1,
                      read_data2,
    input [10:0] opcode,
    input [1:0] alu_op,
    input alu_src,
    
    output [`WORD-1:0] branch_alu_result,
                       alu_result,
    output zero
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
    
    // ALU Control
    wire [3:0] alu_control;
    
    alu_control ALU_CONTROL(
        .alu_op(alu_op),
        .opcode(opcode),
        .alu_control(alu_control)
    );
    
    // ALU
    wire [`WORD-1:0] alu_input_b;
    
    mux #(`WORD) ALU_MUX(
        .a(read_data2),
        .b(sign_extended_instr),
        .control(alu_src),
        .out(alu_input_b)
    );
    
    alu MAIN_ALU(
        .a(read_data1),
        .b(alu_input_b),
        .alu_control(alu_control),
        .zero(zero),
        .result(alu_result)
    );

endmodule