`timescale 1ns / 1ps
`include "constants.vh"

module control(
    input [10:0] opcode,
    input stall,
    input multiplier_done,
    output reg readreg2_control,
               mem_read,
               mem_write,
               reg_write,
               alu_src,
               update_sreg,
               write_reg_src,
               execute_result_loc,
               mult_start,
    output reg [1:0] mem_to_reg,
    output reg [3:0] alu_op, 
    output reg [2:0] branch_op // 000 => no branch, 001 => branch, 010 => branch_conditionally, 011 => branch_if_zero, 100 => branch_if_not_zero, 110 => pc doesn't increment
);
    
    always @* begin
        // Set every signal to zero
        readreg2_control <= 0;
        mem_read <= 0;
        mem_write <= 0;
        mem_to_reg <= 'b00;
        reg_write <= 0;
        alu_src <= 0;
        update_sreg <= 0;
        branch_op <= 'b000;
        write_reg_src <= 0;
        execute_result_loc <= 0;
        mult_start <= 0;
        
        // Set bits to 1
        if (~stall) begin
            casex(opcode)
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
                    mem_read <= 1;
                    mem_to_reg <= 'b01;
                    reg_write <= 1;
                    alu_src <= 1;
                end
                `STUR, `STURB, `STURH, `STURW: begin
                    readreg2_control <= 1;
                    mem_write <= 1;
                    alu_src <= 1;
                end
                `CBZ: begin
                    readreg2_control <= 1;
                    update_sreg <= 1;
                    branch_op <= 'b011;
                end
                `CBNZ: begin
                    readreg2_control <= 1;
                    update_sreg <= 1;
                    branch_op <= 'b100;
                end
                `B: begin
                    branch_op <= 'b001;
                end
                `BCOND: begin
                    branch_op <= 'b010;
                end
                `BL: begin
                    branch_op <= 'b001;
                    mem_to_reg <= 'b10;
                    write_reg_src <= 1;
                    reg_write <= 1;
                end
                `BR: begin
                    readreg2_control <= 1;
                    branch_op <= `BCOND_OP_ALU;
                end
                `MOV: begin
                    alu_src <= 1;
                    reg_write <= 1;
                end
                `MOVK, `MOVZ: begin
                    reg_write <= 1;
                    alu_src <= 1;
                end
                `MUL: begin
                    if (multiplier_done) begin
                        execute_result_loc <= 1;
                        reg_write <= 1;
                    end else begin
                        mult_start <= 1;
                        branch_op <= 'b110;
                    end
                end
            endcase
            
            // Set alu_op (cleaner in its own case statement)
            casex(opcode)
                `STUR, `STURB, `STURH, `STURW, `LDUR, `LDURB, `LDURH, `LDURSW, `MOV: 
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
        end else
            branch_op <= 'b110;
    end  
    
endmodule