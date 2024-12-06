`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 04:25:12 PM
// Design Name: 
// Module Name: dual_port_ram
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


module dual_port_ram
    #(
        parameter DATA_SIZE = 8,
        parameter ADDR_SIZE = 14
    )
    (
    input clk,
    input we,
    input reset,
    input [ADDR_SIZE-1:0] addr_a, addr_b,
    input [DATA_SIZE-1:0] din_a,
    output [DATA_SIZE-1:0] dout_a, dout_b
    );
    
    // Infer the RAM as block ram
    (* ram_style = "block" *) reg [DATA_SIZE-1:0] ram [2**ADDR_SIZE-1:0];
    // Simulation initialization to zero
    // Simulation initialization to zero
    initial begin : INIT_RAM    // Name the block for clarity
        integer i;
        for (i = 0; i < 2**ADDR_SIZE; i = i + 1) begin
            ram[i] = 0;  // Set each location to zero
        end
    end
    reg [ADDR_SIZE-1:0] addr_a_reg, addr_b_reg;
    
    // body
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            for (integer i = 0; i < 2**ADDR_SIZE; i = i + 4) begin
                ram[i] <= 0;  // Set each location to zero
                ram[i+1] <= 0;
                ram[i+2] <= 0;
                ram[i+3] <= 0;
            end
        end else if(we)      // write operation
            ram[addr_a] <= din_a;
        addr_a_reg <= addr_a;
        addr_b_reg <= addr_b;
    end
    
    // two read operations        
    assign dout_a = ram[addr_a_reg];
    assign dout_b = ram[addr_b_reg];
    
endmodule