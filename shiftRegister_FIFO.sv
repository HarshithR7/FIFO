`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2025 01:27:38 AM
// Design Name: 
// Module Name: shiftRegister_FIFO
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


module shiftRegister_FIFO #(

    parameter WIDTH = 8,
    parameter DEPTH = 4
) (
    input logic clk,
    input logic rst_n,
    input logic write,
    input logic read,
    input logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] data_out,
    output logic full,
    output logic empty
);

    logic [WIDTH-1:0] memory [DEPTH-1:0];
    logic [$clog2(DEPTH):0] count;

    always_ff @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            count <= 0;
            for (int i = 0; i < DEPTH; i++) begin
                memory[i] <= '0;
            end
        end else if (write && !full && read && !empty) begin
            // Shift data
            for (int i = DEPTH-1; i > 0; i--) begin
                memory[i] <= memory[i-1];
            end
            memory[0] <= data_in;
        end else if (write && !full) begin
            // Write data
            memory[count] <= data_in;
            count <= count + 1;
        end else if (read && !empty) begin
            // Read data
            for (int i = 0; i < DEPTH-1; i++) begin
                data_out <= memory[DEPTH-1];
                memory[i] <= memory[i+1];
            end
            count <= count - 1;
        end
    end

    
    assign full = (count == DEPTH);
    assign empty = (count == 0);

endmodule

