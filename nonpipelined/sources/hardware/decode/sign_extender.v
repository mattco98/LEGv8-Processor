`timescale 1ns / 1ps
`include "constants.vh"

module sign_extender(
    input [`INSTR_LEN-1:0] instruction,
    output reg [`WORD-1:0] out
);

    always @* begin
        casex(instruction[31:21])
            `ADDI, `ANDI, `EORI, `ORRI, `SUBI:
                out <= {{52{instruction[21]}}, instruction[21:10]};
            `LDUR, `STUR:
                out <= {{55{instruction[20]}}, instruction[20:12]};
             `CBZ:
                out <= {{45{instruction[23]}}, instruction[23:5]};
            `B:
                out <= {{38{instruction[25]}}, instruction[25:0]};
            default:
                out <= {{`WORD-`INSTR_LEN{1'b0}}, instruction};
        endcase
    end

endmodule