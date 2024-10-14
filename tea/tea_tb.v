`timescale 1ns/1ps

module tea_tb;

    reg clk;
    reg reset;

    reg encrypt_start;
    reg decrypt_start;

    reg reset_enc;
    reg reset_dec;

    wire done_enc;
    wire done_dec;

    wire v0_out_enc;
    wire v1_out_enc;

    wire v0_out_dec;
    wire v1_out_dec;

    wire [5:0] bits;

    reg v0_out_reg_enc;
    reg v1_out_reg_enc;

    // Instantiate the encrypt module
    encrypt uut_encrypt (
        .clk(clk), 
        .reset(reset_enc),
        .start(encrypt_start),
        .done(done_enc),
        .v0_out(v0_out_enc),
        .v1_out(v1_out_enc),
        .bits(bits) 
    );


    // Instantiate the decrypt module
    decrypt uut_decrypt (
        .clk(clk), 
        .reset(reset_dec),
        .start(decrypt_start),
        .done(done_dec),
        .v0_out(v0_out_dec),
        .v1_out(v1_out_dec),
        .bits(bits) 
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Toggle clock every 5ns (100MHz clock)
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        encrypt_start = 0;
        decrypt_start = 0;
        reset_enc = 1;
        reset_dec = 1;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Apply reset
        reset_enc = 1;
        #20;
        reset_enc = 0;
        encrypt_start = 1;

        // v0_out_reg_enc = v0_out_enc;
        // v1_out_reg_enc = v1_out_enc;
        
        #400;

        // Apply reset
        encrypt_start = 0;
        reset_dec = 1;
        #20;
        reset_dec = 0;
        decrypt_start = 1;

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