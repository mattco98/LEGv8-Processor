`timescale 1ns / 1ps
`include "constants.vh"


module sign_extender(
    input      [`INSTR_LEN-1:0] instruction,
    output reg [`WORD-1:0]      out
);

    always @*
        casez(instruction[31:21])
            `LSL, `LSR:
                out <= {{(`WORD-6){instruction[15]}}, instruction[15:10]};
            `ADDI, `ANDI, `EORI, `ORRI, `SUBI, `CMPI:
                out <= {{(`WORD-12){instruction[21]}}, instruction[21:10]};
            `LDUR, `STUR, `LDA:
                out <= {{(`WORD-9){instruction[20]}}, instruction[20:12]};
             `CBZ, `CBNZ, `BCOND:
                out <= {{(`WORD-19){instruction[23]}}, instruction[23:5]};
            `B, `BL:
                out <= {{(`WORD-26){instruction[25]}}, instruction[25:0]};
            `MOV: 
                out <= {`WORD{1'b0}};
            `MOVK, `MOVZ:
                out <= {{(`WORD-16){1'b0}}, instruction[20:5]};
            default:
                out <= {{(`WORD-`INSTR_LEN){1'b0}}, instruction};
        endcase

endmodule