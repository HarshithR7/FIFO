`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 

// Create Date: 01/17/2025 12:50:43 AM
// Design Name: 
// Module Name: ExclusiveRW_FIFO
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


module ExclusiveRW_FIFO #(parameter width=8,parameter depth=4)

(input logic clk,write_clk,read_clk,rst,
input logic [width-1:0] data_in,
output logic [width-1:0] data_out,
output logic full,empty
);

logic [width-1:0]memory [depth-1:0];
logic [$clog2(width):0] write_ptr,read_ptr;
logic write_en,read_en;





always_ff @(posedge clk or posedge rst) begin
if (rst) begin
    write_ptr<=0;
    write_en<=0;
    read_ptr<=0;
    read_en<=0;
    end
else begin
    if (write_clk && !full) begin
        write_en<=1;
            memory[write_ptr] <= data_in;
            write_ptr <= (write_ptr+1)%depth;
        end
    else  begin
    write_en<=0;
    end
    
    if (read_clk && !empty) begin
        read_en<=1;
        data_out <= memory[read_ptr];
        read_ptr<=(read_ptr+1)%depth;
        end
    else begin 
    read_en<=0;
    end
 end   
   
assign full=((write_ptr+1)%depth ==read_ptr);
assign empty=(write_ptr==read_ptr);  
    

end
endmodule
