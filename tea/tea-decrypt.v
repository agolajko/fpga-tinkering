module decrypt(

    input wire clk,
    input wire reset,
    input wire run,

    // encryption outputs
    output reg v0_out,
    output reg v1_out,
    output reg done

);

reg [31:0] v0_dec, v1_dec;
reg [5:0] i;

reg [31:0] sum =32'hC6EF3720;

//set the decryption inputs
localparam [31:0] v0 = 32'h5CF85E83;
localparam [31:0] v1 = 32'hE967E1FD;

// set the encryption keys
localparam [31:0] k0 = 32'h11111111;
localparam [31:0] k1 = 32'h22222222;
localparam [31:0] k2 = 32'h33333333;
localparam [31:0] k3 = 32'h44444444;

// delta is a constant
localparam [31:0] delta = 32'h9E3779B9;

always @(posedge clk or posedge reset) begin
    if (reset) begin

        v0_dec <= v0;
        v1_dec <= v1;
        sum <= 32'hC6EF3720;
        i<=0;
    
    end else if (run) begin

        if (i <32) begin
            i<=i+1;

            // need blocking assignment
            // to ensure update interdependencies
            v1_dec = v1_dec - (((v0_dec << 4) + k2) ^ (v0_dec + sum) ^ ((v0_dec >> 5) + k3));
            v0_dec = v0_dec - (((v1_dec << 4) + k0) ^ (v1_dec + sum) ^ ((v1_dec >> 5) + k1));
            sum = sum - delta;

        end

        else if (i == 32) begin
            // Encryption complete

            // 32 loops:
            // v0_out <= (v0_dec == 32'h12345678);
            v0_out <= (sum == 0);
            v1_out <= (v1_dec == 32'h9ABCDEF0);

            done <= 1'b1;
        end

    end
end


endmodule
