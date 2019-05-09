`timescale 1ns / 1ps
`include "constants.vh"


module write_data_modifier(
    input [10:0] opcode,
    input [`WORD-1:0] write_data_in,
    output reg [`WORD-1:0] write_data_out
);

    always @* begin
        casez(opcode)
            `STURB:  write_data_out <= {{(`WORD-8){1'b0}},  write_data_in[7:0]}; 
            `STURH:  write_data_out <= {{(`WORD-16){1'b0}}, write_data_in[15:0]};
            `STURW:  write_data_out <= {{(`WORD-32){1'b0}}, write_data_in[31:0]};
            default: write_data_out <= write_data_in;
        endcase
    end

endmodule
