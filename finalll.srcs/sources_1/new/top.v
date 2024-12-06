`timescale 1ns / 1ps

module top(
    input clk,              // 100MHz Basys 3
    input reset,            // sw[15]
    input set,              // btnC
    input up,               // btnU
    input down,             // btnD
    input left,             // btnL
    input right,            // btnR
    input [7:0] sw,         // sw[6:0] sets ASCII value
    input wire RsRx,
    input JA1,
    output JA2,
    output hsync, vsync,    // VGA connector
    output wire RsTx,
    output [11:0] rgb       // DAC, VGA connector
    );
    
    // signals
    wire [9:0] w_x, w_y;
    wire w_vid_on, w_p_tick;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    
    wire sent1, sent2 ;
    wire received1, received2; // FROM Keyboard and FROM another board
    wire [7:0] data_in, data_out; //WRITE DATA FROM UART, DATA THAT SHOWN ON SCREEN
    reg [6:0] idx;
    wire [3:0] char_row; // 4-bit row of ASCII character
    wire [2:0] bit_addr; // column number of ROM data
    wire gnd; // Ground
    wire [7:0] gnd_b; //
    
    // UART1 Receive from another and transmit to monitor
    uart uart1(.tx(RsTx), .data_transmit(gnd_b),
               .rx(JA1), .data_received(data_in), .received(received1),
               .dte(1'b0), .clk(clk), .sent(sent1));

    // UART2 Receive from keyboard or switch and transmit to another
    uart uart2(.rx(RsRx), .data_transmit(sw), 
               .tx(JA2), .data_received(gnd_b), .received(received2),
               .dte(set), .clk(clk), .sent(sent2));
    
    // instantiate vga controller
    vga_controller vga(.clk_108MHz(clk), .reset(reset), .video_on(w_vid_on),
                       .hsync(hsync), .vsync(vsync), .p_tick(w_p_tick), 
                       .x(w_x), .y(w_y));
    
    // instantiate text generation circuit
    text_screen_gen tsg(.clk(clk), .reset(reset), .video_on(w_vid_on), .set(received1),
                        .up(up), .down(down), .left(left), .right(right),
                        .sw(data_in), .x(w_x), .y(w_y), .rgb(rgb_next));
    
    // rgb buffer
    always @(posedge clk)
        if(w_p_tick)
            rgb_reg <= rgb_next;
            
    // output
    assign rgb = rgb_reg;
    
endmodule

