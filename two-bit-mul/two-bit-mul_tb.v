`timescale 1ns/10ps

module main_tb;

    // Inputs
    reg [1:0] a, b;

    // Outputs
    wire [3:0] product;

    // Instantiate the Unit Under Test (UUT)
    main uut (
        .a(a), 
        .b(b),
        .product(product)
    );

    // Variables for test vector
    integer i;
    reg [3:0] test_vector;

    initial begin
        // Initialize inputs
        a[0] = 0;
        a[1] = 0;
        b[0] = 0;
        b[1] = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Generate test vectors
        for (i = 0; i < 16; i = i + 1) begin
            test_vector = i;
            a[0] = test_vector[3];
            a[1] = test_vector[2];
            b[0] = test_vector[1];
            b[1] = test_vector[0];
            #50; // Wait for 10ns between each test case
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