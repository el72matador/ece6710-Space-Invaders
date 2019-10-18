module VGA_controller(
    input clk,                      // Clock input
    input pixel_strobe,             // Pixel Clock Strobe
    input reset,                    // Reset: restarts frame
    output wire horizontal_sync,    // Horizontal Sync
    output wire vertical_sync,      // Vertical Sync
    output wire blanking,           // high during blanking interval
    output wire active,             // high during active pixel drawing
    output wire screenend,          // high for one tick at the end of screen
    output wire animate,            // high for one tick at end of active drawing
    output wire [9:0] X_output,            // current pixel x position
    output wire [8:0] Y_output             // current pixel y position
);


reg [9:0] horizontal_count;
reg [9:0] vertical_count;

// VGA timings https://timetoexplore.net/blog/video-timings-vga-720p-1080p
localparam HS_STA = 16;              // horizontal sync start
localparam HS_END = 16 + 96;         // horizontal sync end
localparam HA_STA = 16 + 96 + 48;    // horizontal active pixel start
localparam VS_STA = 480 + 10;        // vertical sync start
localparam VS_END = 480 + 10 + 2;    // vertical sync end
localparam VA_END = 480;             // vertical active pixel end
localparam LINE   = 800;             // complete line (pixels)
localparam SCREEN = 525;             // complete screen (lines)

// generate sync signals (active low for 640x480)
assign hoizontal_sync = ~((horizontal_count >= HS_STA) & (horizontal_count < HS_END));
assign vertical_sync = ~((vertical_count >= VS_STA) & (vertical_count < VS_END));

// keep x and y bound within the active pixels
assign X_output = (horizontal_count < HA_STA) ? 0 : (horizontal_count - HA_STA);
assign Y_output = (vertical_count >= VA_END) ? (VA_END - 1) : (vertical_count);

// blanking: high within the blanking period
assign blanking = ((horizontal_count < HA_STA) | (vertical_count > VA_END - 1));

// active: high during active pixel drawing
assign active = ~((horizontal_count < HA_STA) | (vertical_count > VA_END - 1)); 

// screenend: high for one tick at the end of the screen
assign screenend = ((vertical_count == SCREEN - 1) & (horizontal_count == LINE));

// animate: high for one tick at the end of the final active pixel line
assign animate = ((vertical_count == VA_END - 1) & (horizontal_count == LINE));


always @ (posedge clk)
begin
    if (reset)  // reset to start of frame
    begin
        horizontal_count <= 0;
        vertical_count <= 0;
    end
    if (pixel_strobe)  // once per pixel
    begin
        if (horizontal_count == LINE)  // end of line
        begin
            horizontal_count <= 0;
            vertical_count <= vertical_count + 1;
        end
        else 
            horizontal_count <= horizontal_count + 1;
        if (vertical_count == SCREEN)  // end of screen
            vertical_count <= 0;
    end
end

endmodule 