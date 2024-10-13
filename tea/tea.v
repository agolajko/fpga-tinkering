module main(

    input wire clk,
    input wire reset,

    input reg [31:0] v1,
    input reg [31:0] v2,
    input reg [31:0] key1,
    input reg [31:0] key2,
    input reg [31:0] key3,
    input reg [31:0] key4,
    output reg [31:0] v1_enc,
    output reg [31:0] v2_enc

);
// encryption inputs
// v1: 32-bit input. to be encrypted
// v2: 32-bit input. to be encrypted
// key1: 32-bit input. key for encryption
// key2: 32-bit input. key for encryption
// key3: 32-bit input. key for encryption
// key4: 32-bit input. key for encryption

// encryption outputs
// v1_enc: 32-bit output. encrypted v1
// v2_enc: 32-bit output. encrypted v2

// TODO: should this be a wire or a reg?
wire [4:0] sum= 0;

// TODO: should this be a wire or a localparam?
wire [31:0] delta = 32'h9E3779B9;

// count to 32
wire [4:0] count = 0;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        sum <= 0;
    end else if (count < 32) begin
        count <= count + 1;
        sum <= sum + delta;

        v0 <= v0 + (((v1 << 4) + k0) ^ (v1 + sum) ^ ((v1 >> 5) + k1));
        v1 <= v1 + (((v0 << 4) + k2) ^ (v0 + sum) ^ ((v0 >> 5) + k3));

    end

    if (count == 32) begin
        v1_enc <= v1;
        v2_enc <= v2;
    end

end




endmodule
