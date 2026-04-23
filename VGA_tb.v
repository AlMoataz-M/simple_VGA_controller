module VGA_tb;
// Parameters
localparam  h_active      = 640,
            h_front_porch = 16,
            h_sync_porch  = 96,
            h_back_porch  = 48,
            v_active      = 480,
            v_front_porch = 10,
            v_sync_porch  = 2,
            v_back_porch  = 33,
            BPP           = 8,
            T             = 40;
// Ports
reg clk, reset;
wire [BPP - 1:0] rgb;
wire h_sync, v_sync, video_on;


VGA_controller # (
.h_active(h_active),
.h_front_porch(h_front_porch),
.h_sync_porch(h_sync_porch),
.h_back_porch(h_back_porch),
.v_active(v_active),
.v_front_porch(v_front_porch),
.v_sync_porch(v_sync_porch),
.v_back_porch(v_back_porch),
.BPP(BPP)
)
VGA_inst (
.clk(clk),
.rstn(reset),
.rgb(rgb),
.h_sync(h_sync),
.v_sync(v_sync),
.video_on(video_on)
);

always  begin
clk = 0;
#(T/2);

clk = 1;
#(T/2);
end

initial begin
    reset = 0;
    #2;
    reset = 1;
    $readmemb("data.mem", VGA_inst.memory);
    
    #(10**9);
    $stop;
    

end


endmodule