module LEDglow(clk, LED0);
input clk;
output LED0;

reg [23:0] cnt;
always @(posedge clk) cnt <= cnt+1;

reg [4:0] PWM;
wire [3:0] intensity = cnt[23] ? cnt[22:19] : ~cnt[22:19];    // ramp the intensity up and down
always @(posedge clk) PWM <= PWM[3:0] + intensity;

assign LED0 = PWM[4];
endmodule