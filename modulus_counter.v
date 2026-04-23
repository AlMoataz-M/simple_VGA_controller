module modulus_counter #(parameter M = 800) (
    input reset, clk, enable,
    output [$clog2(M)-1:0] count, 
    output done
);
reg [$clog2(M)-1:0] q_reg, q_next;
always @(posedge clk, negedge reset)
begin
    if(!reset)
        q_reg <= 'b0;
    else if(enable)
        q_reg <= q_next;
    else
        q_reg <= q_reg;
end
assign done = (q_reg == M-1);
always @(*)
begin
    if(done)
        q_next = 'b0;
    else
        q_next = q_reg + 1;
end

assign count = q_reg;

endmodule 