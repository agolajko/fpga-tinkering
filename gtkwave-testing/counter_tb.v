`timescale 1ns/1ps

module counter_tb;

    reg clk;
    reg reset;
    wire [3:0] count;

    // Instantiate the Unit Under Test (UUT)
    counter uut (
        .clk(clk), 
        .reset(reset), 
        .count(count)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5ns (100MHz clock)
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;

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
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, counter_tb);
    end

endmodule