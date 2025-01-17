`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2025 02:18:42 AM
// Design Name: 
// Module Name: wordwidth_fifo
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


module wordwidth_fifo #(
    parameter NUM_FIFOS = 2,   
    parameter WIDTH = 8,        
    parameter DEPTH = 4       
)(
    input  logic write_clk,
    input  logic read_clk,
    input  logic clear,
    input  logic write_en,
    input  logic read_en,
    input  logic [(NUM_FIFOS*WIDTH)-1:0] data_in,
    output logic [(NUM_FIFOS*WIDTH)-1:0] data_out,
    output logic full,
    output logic empty
);

    // Internal signals
    logic [NUM_FIFOS-1:0] fifo_full, fifo_empty;
    
    // Generate multiple FIFO instances
    genvar i;
    generate
        for (i = 0; i < NUM_FIFOS; i++) begin : fifo_gen
            ConcurrentRW_Fifo #(
                .WIDTH(WIDTH),
                .DEPTH(DEPTH)
            ) fifo_inst (
                .write_clk(write_clk),
                .read_clk(read_clk),
                .rst(clear),
                .write_en(write_en),
                .read_en(read_en),
                .data_in(data_in[WIDTH*(i+1)-1 : WIDTH*i]),
                .data_out(data_out[WIDTH*(i+1)-1 : WIDTH*i]),
                .full(fifo_full[i]),
                .empty(fifo_empty[i])
            );
        end
    endgenerate

   
    assign full = |fifo_full;   
    assign empty = |fifo_empty; 

endmodule
