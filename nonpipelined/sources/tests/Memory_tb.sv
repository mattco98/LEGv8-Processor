`timescale 1ns / 1ps
`include "constants.vh"

module Memory_tb;
    wire read_clk, write_clk;
    reg uncondbranch, branch, zero, mem_read, mem_write;
    
    reg [`WORD-1:0] address;
    reg [`WORD-1:0] write_data;
    wire pc_src;
    wire [`WORD-1:0] read_data;

    oscillator read_clk_gen(read_clk);
    
    delay #(2) write_clk_gen(read_clk, write_clk);

    Memory MEMORY(.*);
    
    initial begin
        // Initialize
        uncondbranch <= 0;
        branch <= 0;
        zero <= 0;
        mem_read <= 0;
        mem_write <= 0;
        address <= 0;
        write_data <= 0;
        
        // Test branching logic
        // pc_src == 1
        uncondbranch <= 1;
        #`CYCLE;
        
        // pc_src == 1
        uncondbranch <= 0;
        branch <= 1;
        zero <= 1;
        #`CYCLE;
        
        // pc_src == 0
        branch <= 0;
        #`CYCLE;
        
        // pc_src == 0
        branch <= 1;
        zero <= 0;
        #`CYCLE;
        
        // Test memory reads (words 0 - 2)
        // Note that the initial values for these words are
        // as follows: 63, 42, 128
        // word 0
        branch <= 0;
        mem_read <= 1;
        #`CYCLE;
        
        // word 1
        address <= 'd8;
        #`CYCLE;
        
        // word 2
        address <= 'd16;
        #`CYCLE;
        
        // Test memory writes
        // write 10 to word 0
        mem_read <= 0;
        mem_write <= 1;
        address <= 0;
        write_data <= 'd10;
        #`CYCLE;
        
        // write 5 to word 1
        address <= 'd8;
        write_data <= 'd5;
        #`CYCLE;
        
        // write -1 to word 2
        address <= 'd16;
        write_data <= {`WORD{1'b1}};
        #`CYCLE;
        
        // Read written data to ensure accuracy
        // read_data == 10
        address <= 0;
        mem_write <= 0;
        mem_read <= 1;
        #`CYCLE;
        
        // read_data == 5
        address <= 'd8;
        #`CYCLE;
        
        // read_data == -1
        address <= 'd16;
        #`CYCLE;
        
        $finish;
    end
endmodule