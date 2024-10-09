// module main(clk, LED0);
module main(
input wire clk,
// output wire LED0,
output  reg [3:0]   led,
input wire reset);

// reg [23:0] cnt;
// always @(posedge clk) cnt <= cnt+1;

// binary for the tick rate
reg div_clk;

reg [31:0] count;
localparam [31:0] max_count = 6000000;
wire rst;
assign rst = ~reset;

// Clock divider
// Divide 12 MHz clock by 6000000 to get 2 Hz clock
always @(posedge clk or posedge rst) begin
    if (rst == 1'b1) begin
        count <= 32'b0;
    end else if (count == max_count) begin
        count <= 32'b0;
        div_clk <= ~div_clk;
    end else begin
        count <= count + 1;
    end
end

reg [3:0] lfsr= 4'b1111;

always @(posedge div_clk or posedge rst) begin
    if (rst)
        lfsr <= 4'b1111;  // Non-zero seed value
    else begin
        lfsr[3] <= lfsr[2];
        lfsr[2] <= lfsr[1];
        lfsr[1] <= lfsr[0];
        lfsr[0] <= lfsr[3] ^ lfsr[2];  // XOR feedback
    end
end

// Count up on (divided) clock rising edge or reset on button push
always @ (posedge clk or posedge rst) begin
    if (rst == 1'b1) begin
        led <= 4'b1111;
    end else 
    begin
        led <= lfsr;

    end
end


endmodule