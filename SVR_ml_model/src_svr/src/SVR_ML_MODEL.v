`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 20:06:43
// Design Name: 
// Module Name: SVR_ML_MODEL
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

module SVR_ML_MODEL #(
    parameter [31:0] w1 = 32'h3E5A0275,  // IEEE 754 representation of 0.2129
    parameter [31:0] w2 = 32'h3F13D07D,  // IEEE 754 representation of 0.5774
    parameter [31:0] w3 = 32'h403F9A6B,  // IEEE 754 representation of 2.9938
    parameter [31:0] w4 = 32'h3FB08312,  // IEEE 754 representation of 1.3790
    parameter [31:0] w5 = 32'h40CCBAC7,  // IEEE 754 representation of 6.3978
    parameter [31:0] w6 = 32'h41427C1C,  // IEEE 754 representation of 12.1553
    parameter [31:0] w7 = 32'hBF2A92A3,  // IEEE 754 representation of -0.6663
    parameter [31:0] w8 = 32'hBFAFD567,  // IEEE 754 representation of -1.3737
    parameter [31:0] w9 = 32'h3EEE8A72,  // IEEE 754 representation of 0.4659
    parameter [31:0] bias = 32'hC3C00E4C // IEEE 754 representation of -384.1117
)(
    input [31:0] x1, x2, x3, x4, x5,x6,x7,x8,x9,
    output [31:0] y
);

    wire [31:0] p1, p2, p3, p4, p5, p6, p7, p8, p9 , sum1, sum2, sum3, sum4,sum5,sum6,sum7,sum8;

    // Instantiate IEEE 754 Multipliers
    IEEE754_multiplier mul1 (.A(w1), .B(x1), .result(p1));
    IEEE754_multiplier mul2 (.A(w2), .B(x2), .result(p2));
    IEEE754_multiplier mul3 (.A(w3), .B(x3), .result(p3));
    IEEE754_multiplier mul4 (.A(w4), .B(x4), .result(p4));
    IEEE754_multiplier mul5 (.A(w5), .B(x5), .result(p5));
    IEEE754_multiplier mul6 (.A(w6), .B(x6), .result(p6));
    IEEE754_multiplier mul7 (.A(w7), .B(x7), .result(p7));
    IEEE754_multiplier mul8 (.A(w8), .B(x8), .result(p8));
    IEEE754_multiplier mul9 (.A(w9), .B(x9), .result(p9));
    // Instantiate IEEE 754 Adders
    IEEE754_adder add1 (.A(p1), .B(p2), .result(sum1));
    IEEE754_adder add2 (.A(p3), .B(p4), .result(sum2));
    IEEE754_adder add3 (.A(p5), .B(p6), .result(sum3));
    IEEE754_adder add4 (.A(p7), .B(p8), .result(sum4));
    IEEE754_adder add5 (.A(sum4), .B(p9), .result(sum5));
    IEEE754_adder add6 (.A(sum1), .B(sum2), .result(sum6));
    IEEE754_adder add7 (.A(sum3), .B(sum6), .result(sum7));
    IEEE754_adder add8 (.A(sum7), .B(sum5), .result(sum8));
    IEEE754_adder add9 (.A(sum8), .B(bias), .result(y));

endmodule
