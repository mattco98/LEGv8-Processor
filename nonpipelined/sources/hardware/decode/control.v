`timescale 1ns / 1ps
`include "constants.vh"


module control(
    input      [10:0] opcode,
    input             stall,
    input             multiplier_done,
    output reg        readreg2_loc,
    output reg        write_reg_src,
    output reg        reg_write,
    output reg        alu_src,
    output reg [3:0]  alu_op, 
    output reg        execute_result_loc,
    output reg        update_sreg, 
    output reg        mult_start,
    output reg [1:0]  mult_mode,
    output reg [2:0]  branch_op,
    output reg        mem_read,
    output reg        mem_write,
    output reg [1:0]  mem_to_reg
);
    
    always @* begin
        // Set every signal to zero
        readreg2_loc <= 0;
        write_reg_src <= 0;
        reg_write <= 0;
        alu_src <= 0;
        execute_result_loc <= 0;
        update_sreg <= 0;
        mult_start <= 0;
        mult_mode <= 'b00;
        branch_op <= `BCOND_OP_NONE;
        mem_read <= 0;
        mem_write <= 0;
        mem_to_reg <= 'b00;
        
        // Set bits to 1
        if (~stall) begin
            casez(opcode)
                `ADD, `SUB, `AND, `ORR: begin
                    reg_write <= 1;
                end
                `LSL, `LSR: begin
                    reg_write <= 1;
                    alu_src <= 1;
                end
                `ADDS, `ANDS, `SUBS: begin
                    reg_write <= 1;
                    update_sreg <= 1;
                end
                `ADDI, `ANDI, `EORI, `ORRI, `SUBI: begin
                    reg_write <= 1;
                    alu_src <= 1;
                end
                `ADDIS, `ANDIS, `SUBS: begin
                    reg_write <= 1;
                    alu_src <= 1;
                    update_sreg <= 1;
                end
                `CMP: begin
                    update_sreg <= 1;
                end
                `CMPI: begin
                    alu_src <= 1;
                    update_sreg <= 1;
                end
                `LDUR, `LDURB, `LDURH, `LDURSW: begin
                    reg_write <= 1;
                    alu_src <= 1;
                    mem_read <= 1;
                    mem_to_reg <= 'b01;
                end
                `STUR, `STURB, `STURH, `STURW: begin
                    readreg2_loc <= 1;
                    alu_src <= 1;
                    mem_write <= 1;
                end
                `CBZ: begin
                    readreg2_loc <= 1;
                    update_sreg <= 1;
                    branch_op <= `BCOND_OP_ZERO;
                end
                `CBNZ: begin
                    readreg2_loc <= 1;
                    update_sreg <= 1;
                    branch_op <= `BCOND_OP_NZERO;
                end
                `B: begin
                    branch_op <= `BCOND_OP_BRANCH;
                end
                `BCOND: begin
                    branch_op <= `BCOND_OP_COND;
                end
                `BL: begin
                    reg_write <= 1;
                    write_reg_src <= 1;
                    branch_op <= `BCOND_OP_BRANCH;
                    mem_to_reg <= 'b10;
                end
                `BR: begin
                    readreg2_loc <= 1;
                    branch_op <= `BCOND_OP_ALU;
                end
                `MOV: begin
                    reg_write <= 1;
                    alu_src <= 1;
                end
                `MOVZ: begin
                    reg_write <= 1;
                    alu_src <= 1;
                end
                `MOVK: begin
                    readreg2_loc <= 1;
                    reg_write <= 1;
                    alu_src <= 1;
                end
                `MUL: begin
                    if (multiplier_done) begin
                        reg_write <= 1;
                        execute_result_loc <= 1;
                    end else begin
                        mult_start <= 1;
                        mult_mode <= 'b00;
                        branch_op <= `BCOND_OP_NOINC;
                    end
                end
                `UMULH: begin
                    if (multiplier_done) begin
                        reg_write <= 1;
                        execute_result_loc <= 1;
                    end else begin
                        mult_start <= 1;
                        mult_mode <= 'b01;
                        branch_op <= `BCOND_OP_NOINC;
                    end
                end
                `SMULH: begin
                    if (multiplier_done) begin
                        reg_write <= 1;
                        execute_result_loc <= 1;
                    end 
                    else begin
                        mult_start <= 1;
                        mult_mode <= 'b10;
                        branch_op <= `BCOND_OP_NOINC;
                    end
                end
                `LDA: begin
                    readreg2_loc <= 1;
                    reg_write <= 1;
                    alu_src <= 1;
                end
            endcase
            
            // Set alu_op (cleaner in its own case statement)
            casez(opcode)
                `STUR, `STURB, `STURH, `STURW, `LDUR, `LDURB, `LDURH, `LDURSW, `LDA, `MOV: 
                    alu_op <= `ALU_ADD;
                `CBZ, `CBNZ, `B, `BCOND, `BL, `BR:
                    alu_op <= `ALU_PASS_B;
                `LSL: 
                    alu_op <= `ALU_LSL;
                `LSR:
                    alu_op <= `ALU_LSR;
                default:
                    alu_op <= {1'b0, opcode[9], opcode[3], opcode[8]};
            endcase
        end 
        else
            branch_op <= `BCOND_OP_NOINC;
    end  
    
endmodule