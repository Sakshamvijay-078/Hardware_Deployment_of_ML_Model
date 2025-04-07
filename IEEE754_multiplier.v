`timescale 1ns / 1ps
module IEEE754_multiplier #(parameter XLEN=32)
                                (input [XLEN-1:0] A,
                                 input [XLEN-1:0] B,
                                 output reg [XLEN-1:0] result);

    // Extracting Sign, Exponent, and Mantissa
    wire [23:0] A_Mantissa = {1'b1, A[22:0]};
    wire [23:0] B_Mantissa = {1'b1, B[22:0]};
    wire [7:0] A_Exponent = A[30:23], B_Exponent = B[30:23];
    wire A_sign = A[31], B_sign = B[31];

    reg [47:0] Temp_Mantissa;
    reg [8:0] Temp_Exponent;  // 9-bit for overflow check
    reg [7:0] Exponent;
    reg Sign;

    always @(*) begin
        // Multiply mantissas (24-bit * 24-bit = 48-bit)
        Temp_Mantissa = A_Mantissa * B_Mantissa;

        // Compute exponent (bias correction)
        Temp_Exponent = A_Exponent + B_Exponent - 8'd127;

        // Normalize result
        if (Temp_Mantissa[47]) begin
            Temp_Mantissa = Temp_Mantissa >> 1;  // RIGHT shift to normalize
            Temp_Exponent = Temp_Exponent + 1;   // Adjust exponent
        end

        // Prevent exponent overflow
        if (Temp_Exponent >= 8'hFF) begin
            Exponent = 8'hFF; // Infinity
            Temp_Mantissa = 0;
        end
        // Prevent underflow
        else if (Temp_Exponent == 0) begin
            Exponent = 8'h00; // Zero
            Temp_Mantissa = 0;
        end 
        else begin
            Exponent = Temp_Exponent[7:0]; // Store final exponent
        end

        // Compute sign
        Sign = A_sign ^ B_sign;

        // Assemble final result
        result = {Sign, Exponent, Temp_Mantissa[45:23]};
    end
endmodule
