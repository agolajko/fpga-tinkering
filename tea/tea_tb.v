`timescale 1ns/1ps

module tea_tb;

    reg clk;
    reg reset;
    reg start;
    wire done;

    wire v0_out;
    wire v1_out;
    wire [5:0] i;
    wire [5:0] bits;

    // encryption inputs
    // v1: 32-bit input. to be encrypted
    // input reg [31:0] v1, 
    // input reg [31:0] v2,

    // // key1: 32-bit input. key for encryption
    // input reg [31:0] key1, 
    // input reg [31:0] key2,
    // input reg [31:0] key3,  
    // input reg [31:0] key4,

    // // encryption outputs
    // // v1_enc: 32-bit output. encrypted v1
    // output reg [31:0] v1_enc,
    // output reg [31:0] v2_enc

    // Instantiate the Unit Under Test (UUT)
    encrypt uut (
        .clk(clk), 
        .reset(reset),
        .start(start),
        .done(done),
        .v0_out(v0_out),
        .v1_out(v1_out),
        .bits(bits) 
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5ns (100MHz clock)
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;
        start = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Apply reset
        reset = 1;
        #20;
        reset = 0;
        start = 1;

        // Let it count for a while
        #600;

        // Finish the simulation
        $finish;
    end

    // Optional: Generate VCD file for waveform viewing
    initial begin
        $dumpfile("tea_tb.vcd");
        $dumpvars(0, tea_tb);
    end

endmodule