`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"


module Memory #(parameter PATH=`RAM_FILE) (
    input              read_clk,
    input              write_clk,
    input              reset,
    input              zero,
    input              negative,
    input              overflow,
    input              carry,
    input              mem_read,
    input              mem_write,
    input  [`WORD-1:0] address,
    input  [`WORD-1:0] write_data,
    input  [2:0]       branch_op,
    input  [10:0]      opcode,
    input  [4:0]       rt,
    output [1:0]       pc_src,
    output [`WORD-1:0] read_data
);

    wire [`WORD-1:0] write_data_modified;
    
    branch_source branch_source(
        .zero(zero),
        .negative(negative),
        .carry(carry),
        .overflow(overflow),
        .branch_op(branch_op),
        .conditional_branch(rt),
        .branch_src(pc_src)
    );
    
    write_data_modifier write_data_modifier(
        .opcode(opcode),
        .write_data_in(write_data),
        .write_data_out(write_data_modified)
    );
    
    data_memory #(.PATH(PATH)) data_memory(
        .read_clk(read_clk),
        .write_clk(write_clk),
        .reset(reset),
        .address(address),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_data),
        .write_data(write_data_modified)
    );

endmodule
