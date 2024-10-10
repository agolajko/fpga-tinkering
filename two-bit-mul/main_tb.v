`timescale 1ns/10ps

module main_tb;

    // Inputs
    reg A, B, C, D;

    // Outputs
    wire X, Y, Z, N;

    // Instantiate the Unit Under Test (UUT)
    main uut (
        .X(X), 
        .Y(Y), 
        .Z(Z), 
        .N(N), 
        .A(A), 
        .B(B), 
        .C(C), 
        .D(D)
    );

    // Variables for test vector
    integer i;
    reg [3:0] test_vector;

    initial begin
        // Initialize inputs
        A = 0;
        B = 0;
        C = 0;
        D = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Generate test vectors
        for (i = 0; i < 16; i = i + 1) begin
            test_vector = i;
            A = test_vector[3];
            B = test_vector[2];
            C = test_vector[1];
            D = test_vector[0];
            #10; // Wait for 10ns between each test case
        end

        // Add some delay at the end
        #100;

        // Finish the simulation
        $finish;
    end

    // Optional: Generate VCD file for GTKWave
    initial begin
        $dumpfile("main_tb.vcd");
        $dumpvars(0, main_tb);
    end

endmodule