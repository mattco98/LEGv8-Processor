`timescale 1ns / 1ps
`include "constants.vh"


module write_data_transformer(
    input [`WORD-1:0] write_data_in,
    input [10:0] opcode,
    output reg [`WORD-1:0] write_data_out
);

    always @* begin
        casex(opcode)
            `LDURB: write_data_out <= {{(`WORD-8){1'b0}}, write_data_in[7:0]};
            default: write_data_out <= write_data_in;  
        endcase
    end

endmodule
