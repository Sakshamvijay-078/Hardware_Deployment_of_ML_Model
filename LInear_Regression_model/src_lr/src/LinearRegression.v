`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2025 14:46:31
// Design Name: 
// Module Name: LinearRegression
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

//weights and bias are generated from ML model
module LinearRegression #(
    parameter [31:0] w1 = 32'h41AC8898,  // IEEE 754 representation of 21.566696
    parameter [31:0] w2 = 32'h48219343,  // IEEE 754 representation of 165453.042478
    parameter [31:0] w3 = 32'h47EB59EB,  // IEEE 754 representation of 120499.839093
    parameter [31:0] w4 = 32'h44F9F921,  // IEEE 754 representation of 1999.785336
    parameter [31:0] w5 = 32'h4175731D,  // IEEE 754 representation of 15.340604
    parameter [31:0] bias = 32'hCA2128E6// IEEE 754 representation of -2640441.3997814003
)(
    input [31:0] x1, x2, x3, x4, x5,
    output [31:0] y
);

    wire [31:0] p1, p2, p3, p4, p5, sum1, sum2, sum3, sum4;

    // Instantiate IEEE 754 Multipliers
    IEEE754_multiplier mul1 (.A(w1), .B(x1), .result(p1));
    IEEE754_multiplier mul2 (.A(w2), .B(x2), .result(p2));
    IEEE754_multiplier mul3 (.A(w3), .B(x3), .result(p3));
    IEEE754_multiplier mul4 (.A(w4), .B(x4), .result(p4));
    IEEE754_multiplier mul5 (.A(w5), .B(x5), .result(p5));

    // Instantiate IEEE 754 Adders
    IEEE754_adder add1 (.A(p1), .B(p2), .result(sum1));
    IEEE754_adder add2 (.A(p3), .B(p4), .result(sum2));
    IEEE754_adder add3 (.A(sum1), .B(sum2), .result(sum3));
    IEEE754_adder add4 (.A(sum3), .B(p5), .result(sum4));
    IEEE754_adder add5 (.A(sum4), .B(bias), .result(y));

endmodule

