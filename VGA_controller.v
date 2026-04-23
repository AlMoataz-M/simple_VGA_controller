
module VGA_controller #(parameter h_active      = 640,
                                  h_front_porch = 16,
                                  h_sync_porch  = 96,
                                  h_back_porch  = 48,
                                  v_active      = 480,
                                  v_front_porch = 10,
                                  v_sync_porch  = 2,
                                  v_back_porch  = 33,
                                  BPP           = 8
            ) 
(
    input clk, rstn, 
    output reg [BPP-1:0] rgb,
    output h_sync, v_sync, video_on
);
localparam h_sync_width = h_active + h_front_porch + h_back_porch + h_sync_porch;
localparam v_sync_width = v_active + v_front_porch + v_back_porch + v_sync_porch;
localparam ADDR_WIDTH   = $clog2(v_active * h_active);
localparam pixel_x_bits = $clog2(h_sync_width);
localparam pixel_y_bits = $clog2(v_sync_width);

wire [pixel_x_bits-1:0] pixel_x;
wire [pixel_y_bits-1:0] pixel_y;
wire tick_x, tick_y;
wire [ADDR_WIDTH - 1:0] addr;


modulus_counter #(.M(h_sync_width)) 
pixels_x (
.reset(rstn),
.clk(clk),
.enable(1'b1),
.count(pixel_x),
.done(tick_x)
);
modulus_counter #(.M(v_sync_width)) 
pixels_y (
.reset(rstn),
.clk(clk),
.enable(tick_x),
.count(pixel_y),
.done(tick_y)
);



// assuming that the photos that will be displayed will be exactly the same
// in wdith and height as the screen which is 640 x 480 and each pixel has
// a color and each color is represented with BPP bits so the word will have
// 8 bits for color, and each line will represent one pixel, and each pixel is
// represented by one line, so number lines equal to total number of pixels
// = 640 * 480 = 307200, this number will change if the pixels changes

reg [BPP-1:0] memory [0 : 2 ** ADDR_WIDTH - 1];
assign video_on = (pixel_x < h_active  && pixel_y < v_active)? 1'b1 : 1'b0;
assign h_sync = (pixel_x <(h_active + h_front_porch - 1) || pixel_x >=(h_active + h_front_porch + h_sync_porch - 1))? 1'b1 : 1'b0;
assign v_sync = (pixel_y <(v_active + v_front_porch - 1) || pixel_y >=(v_active + v_front_porch + v_sync_porch - 1))? 1'b1 : 1'b0;

// addr = number of columns * counter_of_rows + counter_of_columns
assign addr = v_active * pixel_y  + pixel_x;

always @(posedge clk)
begin
    if(video_on)
        rgb = memory[addr];
    else
        rgb = rgb;
end



endmodule

