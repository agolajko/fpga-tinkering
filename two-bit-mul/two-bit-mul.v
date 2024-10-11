`timescale 1ns/10ps //time units and precision

// module main(clk, LED0);
module main(
    input [1:0] a,
    input [1:0] b,
    output [3:0] product
);

    wire [3:0] partial_products;

    // Generate partial products
    assign partial_products[0] = a[0] & b[0];
    assign partial_products[1] = a[1] & b[0];
    assign partial_products[2] = a[0] & b[1];
    assign partial_products[3] = a[1] & b[1];

    // Sum the partial products
    assign product[0] = partial_products[0];
    assign product[1] = partial_products[1] ^ partial_products[2];
    assign product[2] = (partial_products[1] & partial_products[2]) ^ partial_products[3];
    assign product[3] = (partial_products[1] & partial_products[2] & partial_products[3]);

endmodule