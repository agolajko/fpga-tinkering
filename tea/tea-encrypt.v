module encrypt(

    input wire clk,
    input wire reset,
    input wire start,

    // encryption outputs
    output reg v0_out,
    output reg v1_out,
    output reg done,
    output reg [5:0] bits

);

reg [31:0] v0_enc, v1_enc;
reg [5:0] i;

reg [31:0] sum =0;

//set the encryption inputs
localparam [31:0] v0 = 32'h12345678;
localparam [31:0] v1 = 32'h9ABCDEF0;

// set the encryption keys
localparam [31:0] k0 = 32'h11111111;
localparam [31:0] k1 = 32'h22222222;
localparam [31:0] k2 = 32'h33333333;
localparam [31:0] k3 = 32'h44444444;

// delta is a constant
localparam [31:0] delta = 32'h9E3779B9;

always @(posedge clk or posedge reset) begin
    if (reset) begin

        v0_enc <= v0;
        v1_enc <= v1;
        sum <= 0;
        i<=0;
        bits <= 6'b000000;
    
    end else if (start) begin

        if (i <32) begin
            i<=i+1;
            bits <= bits + 1;

            sum = sum + delta;

            // need blocking assignment
            // to ensure update interdependencies
            v0_enc = v0_enc + (((v1_enc << 4) + k0) ^ (v1_enc + sum) ^ ((v1_enc >> 5) + k1));
            v1_enc = v1_enc + (((v0_enc << 4) + k2) ^ (v0_enc + sum) ^ ((v0_enc >> 5) + k3));

        end

        else if (i == 32) begin
            // Encryption complete

            // 32 loops:
            v0_out <= (v0_enc == 32'h5CF85E83);
            v1_out <= (v1_enc == 32'hE967E1FD);

            done <= 1'b1;
        end

    end
end


endmodule
