`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"


module Memory #(parameter PATH=`RAM_FILE) (
    input  read_clk,
           write_clk,
           zero,
           negative,
           overflow,
           carry,
           mem_read,
           mem_write,
    input  [`WORD-1:0] address,
                       write_data,
    input  [2:0] branch_op,
    input [10:0] opcode,
    output pc_src,
    output [`WORD-1:0] read_data
);

    reg [`WORD-1:0] write_data_new;
    
    branch_source BRANCH_SOURCE(
        .zero(zero),
        .negative(negative),
        .carry(carry),
        .overflow(overflow),
        .branch_op(branch_op),
        .branch_src(pc_src)
    );
    
    always @* begin
        casex(opcode)
            `STURB: write_data_new <= {{(`WORD-8){1'b0}}, write_data[7:0]}; 
            `STURH: write_data_new <= {{(`WORD-16){1'b0}}, write_data[15:0]};
            `STURW: write_data_new <= {{(`WORD-32){1'b0}}, write_data[31:0]};
            default: write_data_new <= write_data;
        endcase
    end
    
    data_memory #(PATH) DATA_MEM(
        .read_clk(read_clk),
        .write_clk(write_clk),
        .address(address),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_data),
        .write_data(write_data)
    );

endmodule
