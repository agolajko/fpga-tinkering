`timescale 1ns/1ps

module tea_tb;

    reg clk;
    reg reset;

    // encryption inputs
    // v1: 32-bit input. to be encrypted
    input reg [31:0] v1, 
    input reg [31:0] v2,

    // key1: 32-bit input. key for encryption
    input reg [31:0] key1, 
    input reg [31:0] key2,
    input reg [31:0] key3,  
    input reg [31:0] key4,

    // encryption outputs
    // v1_enc: 32-bit output. encrypted v1
    output reg [31:0] v1_enc,
    output reg [31:0] v2_enc

    // Instantiate the Unit Under Test (UUT)
    encrypt uut (
        .clk(clk), 
        .reset(reset),
        .v1(v1),
        .v2(v2),
        .key1(key1),
        .key2(key2),
        .key3(key3),
        .key4(key4),
        .v1_enc(v1_enc),
        .v2_enc(v2_enc) 
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5ns (100MHz clock)
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;
        v1 = 32'h12345678;
        v2 = 32'h9ABCDEF0;
        key1 = 32'h11111111;
        key2 = 32'h22222222;
        key3 = 32'h33333333;
        key4 = 32'h44444444;
        

        // Wait 100 ns for global reset to finish
        #100;
        
        // Apply reset
        reset = 1;
        #20;
        reset = 0;

        // Let it count for a while
        #200;

        // Apply reset again
        reset = 1;
        #20;
        reset = 0;

        // Let it count some more
        #200;

        // Finish the simulation
        $finish;
    end

    // Optional: Generate VCD file for waveform viewing
    initial begin
        $dumpfile("tea_tb.vcd");
        $dumpvars(0, tea_tb);
    end

endmodule