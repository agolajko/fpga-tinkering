module LEDglow(clk, LED0);
input clk;
output LED0;

reg [23:0] cnt;
always @(posedge clk) cnt <= cnt+1;


// ramp the intensity up and down:

// the 22:29 bits of cnt always increase
// until the register overflows, then it's set to 0
// the intensity value is decreasing (from 1111) until cnt[23] is 1
// at that point it starts increasing (from 0000) until
// cnt[23] is 0 again (when the register overflows)

wire [3:0] intensity = cnt[23] ? cnt[22:19] : ~cnt[22:19];    

reg [4:0] PWM;

// PWM is a 5-bit register
// increases by the intensity value on each clok cycle
// the LED is on when bit 4 is 1
// the is more likely to be on when the intensity is higher
// hence the LED flashes a higher rate when the intensity is higher

always @(posedge clk) PWM <= PWM[3:0] + intensity;

assign LED0 = PWM[4];
endmodule