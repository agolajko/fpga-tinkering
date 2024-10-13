module encrypt(

    input wire clk,
    input wire reset,

    // encryption inputs
    // v1: 32-bit input. to be encrypted
    input wire [31:0] v1, 
    input wire [31:0] v2,

    // key1: 32-bit input. key for encryption
    input wire [31:0] key1, 
    input wire [31:0] key2,
    input wire [31:0] key3,  
    input wire [31:0] key4,

    // encryption outputs
    // v1_enc: 32-bit output. encrypted v1
    output reg [31:0] v1_out,
    output reg [31:0] v2_out,
    output reg done


);

// loop counter
integer i;

reg [31:0] v1_enc, v2_enc;


// TODO: should this be a wire or a reg?
reg [4:0] sum =0;

// TODO: should this be a wire or a localparam?
localparam [31:0] delta = 32'h9E3779B9;


always @(posedge clk or posedge reset) begin
    if (reset) begin

        v1_enc <= v1;
        v2_enc <= v2;
        sum <= 0;
        i<=0;
    
    end else if (start) begin
        v1_enc <= v1;
        v2_enc <= v2;

    end else if (i <32) begin
        i<=i+1;
        sum <= sum + delta;

        v1_enc <= v1_enc + (((v2_enc << 4) + key1) ^ (v2_enc + sum) ^ ((v2_enc >> 5) + key2));
        v2_enc <= v2_enc + (((v1_enc << 4) + key3) ^ (v1_enc + sum) ^ ((v1_enc >> 5) + key4));
    end

    else if (i == 32) begin
        // Encryption complete
        v1_out <= v1_enc;
        v2_out <= v2_enc;
        done <= 1'b1;
    end
    
    end



endmodule
