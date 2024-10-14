module tea(    
    
    input wire clk,

    input wire run_enc,
    input wire run_dec,

    input wire reset_enc,
    input wire reset_dec,

    output wire done_enc,
    output wire done_dec,

    output wire v0_out_enc,
    output wire v1_out_enc,

    output wire v0_out_dec,
    output wire v1_out_dec
    );

    // Instantiate the encrypt module
    encrypt encrypt_inst (
        .clk(clk), 
        .reset(reset_enc),
        .run(run_enc),
        .done(done_enc),
        .v0_out(v0_out_enc),
        .v1_out(v1_out_enc)
    );


    // Instantiate the decrypt module
    decrypt decrypt_inst (
        .clk(clk), 
        .reset(reset_dec),
        .run(run_dec),
        .done(done_dec),
        .v0_out(v0_out_dec),
        .v1_out(v1_out_dec)
    );

endmodule