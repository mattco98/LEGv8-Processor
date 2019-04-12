`timescale 1ns / 1ps
`include "helpers.vh"
`include "constants.vh"
`include "files.vh"

module register_memory_tb;

    wire read_clk, write_clk;
    reg  reg_write;
    reg  [4:0] read_reg1, read_reg2, write_reg;
    reg  [`WORD-1:0] write_data;
    wire [`WORD-1:0] read_data1, read_data2;
    
    oscillator read_clk_gen(read_clk);
    
    delay #(4) write_clk_gen(
        .clk(read_clk),
        .clk_delayed(write_clk)
    );
    
    register_memory #(.PATH(`REGISTER_MEM_TB_REGISTER_FILE)) UUT(.*);

    initial begin
        `TB_BEGIN
        
        
        // Set everything to zero
        reg_write <= 0;
        read_reg1 <= 0;
        read_reg2 <= 0;
        write_reg <= 0;
        write_data <= 0;
        #`CYCLE;
        
        // Begin test cases
        read_reg1 <= 'd31;
        #`CYCLE assert(read_data1 == 'd31) else $error("[0] read_data1 != 'd31");
        
        read_reg1 <= 'd20;
        #`CYCLE assert(read_data1 == 'd20) else $error("[1] read_data1 != 'd20");
        
        read_reg1 <= 'd0;
        #`CYCLE assert(read_data1 == 'd0) else $error("[2] read_data1 != 'd0");
        
        read_reg2 <= 'd5;
        #`CYCLE assert(read_data2 == 'd5) else $error("[3] read_data2 != 'd5");
        
        read_reg2 <= 'd17;
        #`CYCLE assert(read_data2 == 'd17) else $error("[4] read_data2 != 'd17");
        
        read_reg2 <= 'd7;
        #`CYCLE assert(read_data2 == 'd7) else $error("[5] read_data2 != 'd7");
        
        write_reg <= 'd11;
        write_data <= 'd100;
        reg_write <= 1;
        #`CYCLE;
        write_reg <= 'd0;
        write_data <= 'd0;
        reg_write <= 0;
        read_reg1 <= 'd11;
        #`CYCLE assert(read_data1 == 'd100) else $error("[6] read_data1 != 'd100");
        
        write_reg <= 'd1;
        write_data <= 'd123456789;
        reg_write <= 1;
        #`CYCLE;
        write_reg <= 'd0;
        write_data <= 'd0;
        reg_write <= 0;
        read_reg2 <= 'd1;
        #`CYCLE assert(read_data2 == 'd123456789) else $error("[6] read_data2 != 'd123456789");
        
        `TB_END
        $finish;
    end

endmodule











