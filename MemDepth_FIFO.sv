`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2025 02:06:17 AM
// Design Name: 
// Module Name: MemDepth_FIFO
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


module MemDepth_FIFO #(parameter WIDTH = 8, parameter DEPTH = 4, parameter NUM_FIFOS = 4) // Set NUM_FIFOS to 4
(
    input logic clk, write_clk, read_clk, rst,
    input logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] data_out,
    output logic full, empty
);

    logic [WIDTH-1:0] fifo_data_in [NUM_FIFOS-1:0];
    logic [WIDTH-1:0] fifo_data_out [NUM_FIFOS-1:0];
    logic fifo_full [NUM_FIFOS-1:0], fifo_empty [NUM_FIFOS-1:0];


    generate
        genvar i;
        for (i = 0; i < NUM_FIFOS; i = i + 1) begin : cascaded_fifos
            ExclusiveRW_FIFO #(.WIDTH(WIDTH), .DEPTH(DEPTH)) fifo_inst (
                .clk(clk),
                .write_clk(write_clk),
                .read_clk(read_clk),
                .rst(rst),
                .data_in((i == 0) ? data_in : fifo_data_out[i-1]),  
                .data_out(fifo_data_out[i]),
                .full(fifo_full[i]),
                .empty(fifo_empty[i])
            );
        end
    endgenerate

 
    assign data_out = fifo_data_out[NUM_FIFOS-1];
    assign full = fifo_full[NUM_FIFOS-1];
    assign empty = fifo_empty[0];

endmodule