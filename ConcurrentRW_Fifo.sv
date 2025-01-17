`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2025 12:09:07 AM
// Design Name: 
// Module Name: ConcurrentRW_Fifo
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


module ConcurrentRW_Fifo #(parameter width=8,parameter depth=4)

(input logic write_clk,read_clk,rst,write_en,read_en,
input logic [width-1:0] data_in,
output logic [width-1:0] data_out,
output logic full,empty);

logic [width-1:0] memory [depth-1:0];
logic [$clog2(depth):0] write_ptr, read_ptr;
logic [$clog2(depth):0] count;

assign full=(count == depth);
assign empty=(count==0);

//write logic

always_ff @(posedge write_clk or posedge rst) begin
if(rst) begin
    write_ptr<=0;
    end
else if (write_en && !full)
    begin
    memory[write_ptr]<=data_in;
    write_ptr=(write_ptr+1)%depth;
    
    end
    end

//read_logic
always_ff @(posedge read_clk or posedge rst) begin
if (rst) begin
    read_ptr<=0;
    data_out<=0;
end
else if (read_en && !empty) begin
    data_out <= memory [read_ptr];
    read_ptr<=(read_ptr+1)%depth;
    end
end


// count the number of words stored

always_ff @(posedge write_clk or posedge read_clk or posedge rst) begin
if (rst) begin
count <=0;
end
else if (write_clk && write_en&& !full) begin
count<=count+1;
end
else if (read_clk && read_en && !empty) begin
count<=count-1;
end
else if (write_clk && read_clk) begin
    if (write_en && !full && read_en &&!empty) begin
        count<=count;
        end
     else if (write_en && !full) begin
        count<=count+1;
        end
     else if (read_en && !empty) begin
        count<=count-1;
        end
 end
end


endmodule
