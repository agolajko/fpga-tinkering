// Top module for iCEstick UART echo timing
`include "../../../icestick-arduino-uart/core/uart.v"

module too (
    input iCE_CLK,              // 12MHz clock
    output PIO1_02,         // UART TX to Arduino
    input PIO1_03,          // UART RX from Arduino
    input PIO1_06,          // Button input pin
    input RS232_Rx_TTL,
    output RS232_Tx_TTL,    // UART TX to PC via FTDI
    output LED0,              // Status LED
    output LED1,
	output LED2,
	output LED3,
	output LED4
);

    // Parameters
    parameter CLK_FREQ = 12_000_000;  // 12MHz
    parameter NUM_SAMPLES = 100;       // Number of echo measurements
    parameter TIMEOUT_CYCLES = 360_000; // 30ms timeout (12MHz * 0.03)
    
    // State machine states
    reg [3:0] state;
    localparam IDLE = 4'd0;
    localparam SEND_ECHO = 4'd1;
    localparam WAIT_ECHO = 4'd2;
    localparam CALCULATE = 4'd3;
    localparam REPORT = 4'd4;
    
    // Internal signals
    reg [6:0] sample_count;
    reg [23:0] total_cycles;
    reg [16:0] cycle_count;
    reg uart_transmit;
    reg [7:0] tx_byte;
    reg uart_tx_pc;
    reg [7:0] debug_output;
    reg led_state;
    
    reg uart_received;
    wire [7:0] rx_byte;
    wire uart_is_receiving;
    wire uart_is_transmitting;

    // Reset generation
    // reg [3:0] reset_cnt = 0;
    // wire rst = ~&reset_cnt;
    wire rst = ~PIO1_06;
    
//    always @(posedge iCE_CLK) begin
//         debug_output <= {7'b0, total_cycles[0]};  // Take bit 10 of cycle count and pad with zeros
//         total_cycles <= total_cycles + 1;
//         if (reset_cnt != 4'hF)
//             reset_cnt <= reset_cnt + 1;
//     end

    // UART instance for Arduino communication
    uart #(
        .baud_rate(9600),
        .sys_clk_freq(CLK_FREQ)
    ) uart_arduino (
        .clk(iCE_CLK),
        .rst(rst),
        .rx(PIO1_03),          // RX from Arduino
        .tx(PIO1_02),          // TX to Arduino
        .transmit(uart_transmit),
        .tx_byte(tx_byte),
        .received(uart_received),
        .rx_byte(rx_byte),
        .is_receiving(uart_is_receiving),
        .is_transmitting(uart_is_transmitting)
    );

    // Timeout counter
    reg [19:0] timeout_counter;
    wire timeout = (timeout_counter == TIMEOUT_CYCLES);

    // Convert cycles to milliseconds
    wire [31:0] avg_time = (total_cycles / NUM_SAMPLES * 1000) / CLK_FREQ;

    // Main state machine
    always @(posedge iCE_CLK) begin

        if (rst) begin
            state <= IDLE;
            sample_count <= 0;
            total_cycles <= 0;
            cycle_count <= 0;
            uart_transmit <= 0;
            timeout_counter <= 0;
            led_state <= 1;
        end else begin
            // Default signal states
            uart_transmit <= 0;
            led_state <= 0;
            
            case (state)
                IDLE: begin
                    if (sample_count < NUM_SAMPLES) begin
                        tx_byte <= 8'h56; // 'V' character
                        uart_transmit <= 1;
                        cycle_count <= 0;
                        timeout_counter <= 0;
                        uart_tx_pc <= 8'h56;  // Send 'V' to PC
                        state <= SEND_ECHO;
                    end else begin
                        state <= CALCULATE;
                    end
                end

                SEND_ECHO: begin
                    if (!uart_is_transmitting) begin
                        state <= WAIT_ECHO;
                    end
                end

                WAIT_ECHO: begin
                    cycle_count <= cycle_count + 1;
                    timeout_counter <= timeout_counter + 1;
                    
                    if (uart_received) begin
                        // total_cycles <= total_cycles + cycle_count;
                        sample_count <= sample_count + 1;
                        // uart_tx_pc <= total_cycles; 

                        // uart_tx_pc <= rx_byte;  // Send echo byte to PC

                        state <= IDLE;
                    end else if (timeout) begin
                        sample_count <= sample_count + 1;
                        state <= IDLE;
                    end
                end

                CALCULATE: begin
                    // Send result via FTDI UART
                    uart_tx_pc <= avg_time[7:0];  // Send LSB of average
                    state <= REPORT;
                end

                REPORT: begin
                    state <= IDLE;
                    sample_count <= 0;
                    total_cycles <= 0;
                end

                default: state <= IDLE;
            endcase
        end
    end

reg uart_pc_transmit;
reg [7:0] uart_pc_byte;

wire uart_pc_is_transmitting;

// Add another UART instance for PC communication
uart #(
    .baud_rate(9600),
    .sys_clk_freq(CLK_FREQ)
) uart_pc (
    .clk(iCE_CLK),
    .rst(rst),
    .rx(1'b1),  // Not used
    .tx(RS232_Tx_TTL),
    // .tx(RS232_Rx_TTL),
    .transmit(uart_pc_transmit),
    .tx_byte(uart_pc_byte),
    .received(),  // Not used
    .rx_byte(),  // Not used
    .is_receiving(),  // Not used
    .is_transmitting(uart_pc_is_transmitting)
);

reg [23:0] uart_send_counter;  // Made wider for slower count
always @(posedge iCE_CLK) begin
    if (rst) begin
        uart_send_counter <= 0;
        uart_pc_transmit <= 0;
    end else begin
        uart_pc_transmit <= 0;  // Default state
        
        if (uart_send_counter == 0) begin
            // uart_pc_byte <= 8'b01010110;  // Or whatever data you want to send
            // uart_pc_byte <= {2'b0, 6'b111111};  // Or whatever data you want to send
            // uart_pc_byte <= rx_byte;
            uart_pc_byte <= {2'b0, 3'b111, sample_count[2:0]};  // Or whatever data you want to send
            uart_pc_transmit <= 1;
        end
        
        uart_send_counter <= uart_send_counter + 1;
        if (uart_send_counter >= CLK_FREQ)  // Send once per second (12M cycles)
            uart_send_counter <= 0;
    end
end


    // Status LED
    assign LED0 = (state == IDLE);
    assign LED1 = (state == SEND_ECHO);
    assign LED2 = (state == WAIT_ECHO);
    // assign LED3 = (state == CALCULATE);
    assign LED3 = uart_received;
    // assign LED4 = (state == REPORT);
    assign LED4 = led_state;

    // assign RS232_Tx_TTL = tx_byte;  // Send MSB of cycle count to PC

endmodule