`timescale 1ns/1ps

module tea_tb_new;

    reg clk;

    reg run_enc;
    reg run_dec;

    reg reset_enc;
    reg reset_dec;

    wire done_enc;
    wire done_dec;

    wire v0_out_enc;
    wire v1_out_enc;

    wire v0_out_dec;
    wire v1_out_dec;

    wire [5:0] bits;

  tea uut (
    .clk(clk),
    .run_enc(run_enc),
    .run_dec(run_dec),
    .reset_enc(reset_enc),
    .reset_dec(reset_dec),
    .done_enc(done_enc),
    .done_dec(done_dec),
    .v0_out_enc(v0_out_enc),
    .v1_out_enc(v1_out_enc),
    .v0_out_dec(v0_out_dec),
    .v1_out_dec(v1_out_dec)
  );


    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5ns (100MHz clock)
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        run_enc = 0;
        run_dec = 0;
        reset_enc = 1;
        reset_dec = 1;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Apply reset
        reset_enc = 1;
        #20;
        reset_enc = 0;
        run_enc = 1;

        
        #400;

        // Apply reset
        run_enc = 0;
        reset_dec = 1;
        #20;
        reset_dec = 0;
        run_dec = 1;

        // Let it count for a while
        #600;

        // Finish the simulation
        $finish;
    end

    // Optional: Generate VCD file for waveform viewing
    initial begin
        $dumpfile("tea_tb.vcd");
        $dumpvars(0, tea_tb_new);
    end

endmodule