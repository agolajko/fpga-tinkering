/*
 * Copyright 2015 Forest Crossman
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

// `include "../../../icestick-arduino-uart/core/uart.v"

module top(
	input iCE_CLK,
	// input RS232_Rx_TTL,
	output RS232_Tx_TTL,
	output LED0,
	output LED1,
	output LED2,
	output LED3,
	output LED4,
    output PIO1_02,     // New output pin
	input PIO1_03,       // New input pin
    input PIO1_06       // New input pin
	);
    
    // general purpose registers
    wire rst = ~PIO1_06;
    reg received_latch;  // Latch the received signal
    reg [24:0] counter;   // Counter for debugging

    // Parameters
    parameter CLK_FREQ = 12_000_000;  // 12MHz
    parameter NUM_SAMPLES = 20;       // Number of echo measurements
    parameter TIMEOUT_CYCLES = 360_000; // 30ms timeout (12MHz * 0.03)    

    // arduino uart registers
	reg transmit;
	reg [7:0] tx_byte;
	wire received;
	wire [7:0] rx_byte;
	wire is_receiving;
	wire is_transmitting;
	wire recv_error;

	uart #(
		.baud_rate(9600),                 // The baud rate in kilobits/s
		.sys_clk_freq(CLK_FREQ)           // The master clock frequency
	)
	uart_arduino(
		.clk(iCE_CLK),                    // The master clock for this module
		.rst(rst),                      // Synchronous reset
		.rx(PIO1_03),                // Incoming serial line
		.tx(PIO1_02),                // Outgoing serial line
		.transmit(transmit),              // Signal to transmit
		.tx_byte(tx_byte),                // Byte to transmit
		.received(received),              // Indicated that a byte has been received
		.rx_byte(rx_byte),                // Byte received
		.is_receiving(is_receiving),      // Low when receive line is idle
		.is_transmitting(is_transmitting),// Low when transmit line is idle
		.recv_error(recv_error)           // Indicates error in receiving packet.
	);

    // PC uart registers
    reg uart_pc_transmit;
    reg [7:0] uart_pc_byte;
    wire uart_pc_is_transmitting;
    reg [15:0] uart_send_counter;  // Made wider for slower count


    // Add another UART instance for PC communication
    uart #(
        .baud_rate(9600),
        .sys_clk_freq(CLK_FREQ)
    ) uart_pc (
        .clk(iCE_CLK),
        .rst(rst),
        .rx(1'b1),  // Not used
        .tx(RS232_Tx_TTL),
        .transmit(uart_pc_transmit),
        .tx_byte(uart_pc_byte),
        .received(),  // Not used
        .rx_byte(),  // Not used
        .is_receiving(),  // Not used
        .is_transmitting(uart_pc_is_transmitting)
    );

    always @(posedge iCE_CLK) begin
        if (rst) begin
            uart_send_counter <= 0;
            uart_pc_transmit <= 0;
            uart_pc_byte <= 0;
        end else begin
            uart_send_counter <= uart_send_counter + 1;
            uart_pc_transmit <= 0;  // Default state
            
            if (uart_send_counter[1:0] == 2'b00 && !uart_pc_is_transmitting) begin
                uart_pc_byte <=  {2'b00, total_cycles[23:18]};
                uart_pc_transmit <= 1;

            end else if (uart_send_counter[1:0] == 2'b01 && !uart_pc_is_transmitting) begin
                uart_pc_byte <=  {2'b01, total_cycles[17:12]};
                uart_pc_transmit <= 1;

            end else if (uart_send_counter[1:0] == 2'b10 && !uart_pc_is_transmitting) begin
                uart_pc_byte <=  {2'b10, total_cycles[11:6]};
                uart_pc_transmit <= 1;

            end else if (uart_send_counter[1:0] == 2'b11 && !uart_pc_is_transmitting) begin
                uart_pc_byte <= {2'b11, total_cycles[5:0]} ;
                uart_pc_transmit <= 1;
            
            end else begin
                uart_pc_transmit <= 0;  // Set transmit low when not sending
            end
            
            // if (uart_send_counter >= CLK_FREQ/1000)  // Send once per second (12M cycles)
            //     uart_send_counter <= 0;
        end
    end

    // Main state machine

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
    reg [23:0] send_counter;
    reg [16:0] cycle_count;
    reg [7:0] uart_tx_pc;


    // Timeout counter
    reg [19:0] timeout_counter;
    wire timeout = (timeout_counter == TIMEOUT_CYCLES);

    localparam STATE1_MAX = 24'h555555;
    localparam STATE2_MAX = 24'hAAAAAA;

    reg [2:0] leds;

    always @(posedge iCE_CLK) begin


        if (rst) begin
            state <= IDLE;
            sample_count <= 0;
            total_cycles <= 0;
            cycle_count <= 0;
            timeout_counter <= 0;
            send_counter <=0;
            transmit <= 0;
            leds <= 3'b000;
            uart_tx_pc <= 0;

        end else begin
        
            send_counter <= send_counter + 1;
            transmit <= 0;

            case (state)
                IDLE: begin
                    leds <= 3'b100;

                    // send the signal during a single clock cycle
                    // simoplify this by just checking if a single reg is at 0
                    if (STATE1_MAX-2 < send_counter && send_counter < STATE1_MAX) begin 
                        if (sample_count < NUM_SAMPLES) begin

                            tx_byte <= h56'; // 'V' character
                            transmit <= 1;
                            cycle_count <= 0;
                            timeout_counter <= 0;

                            state <= SEND_ECHO;
                        end else begin
                            state <= CALCULATE;
                        end
                    end

                end

                SEND_ECHO: begin
                    leds <= 3'b010;

                    if (!is_transmitting) begin 
                        state <= WAIT_ECHO;
                    end
                end

                WAIT_ECHO: begin
                    leds <= 3'b001;


                    cycle_count <= cycle_count + 1;
                    timeout_counter <= timeout_counter + 1;

                    if ( received ) begin 
                        sample_count <= sample_count + 1;
                        total_cycles <= total_cycles + cycle_count;
                        state <= IDLE;

                    end else if (timeout) begin
                        // sample_count <= sample_count + 1;
                        state <= IDLE;
                    end
                end

                CALCULATE: begin
                    // Send result via FTDI UART
                    uart_tx_pc <= 42; //avg_time[7:0];  // Send LSB of average
                    state <= REPORT;
                end

                REPORT: begin
                    // sample_count <= 0;
                    // avg_time <= (total_cycles / NUM_SAMPLES * 1000) / CLK_FREQ;
                    // total_cycles <= 0;
                    state <= IDLE;

                end

            endcase
        end

    end

    assign LED0 = leds[2];
    assign LED1 = leds[1];
    // assign LED2 = leds[0];
    assign LED2 = timeout;
    assign LED3 = uart_send_counter[15];
    assign LED4 = rst;


endmodule
