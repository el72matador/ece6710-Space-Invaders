module VGA_testbench;
    reg clk;                      // Clock input
    reg pixel_strobe;             // Pixel Clock Strobe
    reg reset;                    // Reset: restarts frame
    wire horizontal_sync;         // Horizontal Sync
    wire vertical_sync;           // Vertical Sync
    wire blanking;                // high during blanking interval
    wire active;                  // high during active pixel drawing
    wire screenend;               // high for one tick at the end of screen
    wire animate;                 // high for one tick at end of active drawing
    wire [9:0] x;                 // current pixel x position
    wire [8:0] y;                 // current pixel y position

VGA_controller VGA_TB (
    .clk          (clk),
    .pixel_strobe (pixel_strobe),
    .reset        (reset)
);

initial begin
    
end
endmodule // 


