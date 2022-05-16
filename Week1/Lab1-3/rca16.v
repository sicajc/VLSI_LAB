module rca16(input[15:0] a,
             input[15:0] b,
             input c_in,
             output c_out,
             output[7:0] sum);

genvar i;
wire[3:0] c;

generate

for(i = 1;i<=4;i = i+1)
begin
    if (i == 1)
    begin
        Add_rca4 rca_head(.a(a[3:0]),.b(b[3:0]),.ci(c_in),.sum(sum[3:0]),.c_out(c[0]));
    end
    else
    begin
        Add_rca4 rca_s(.a(a[i*4-1 : i*4-4]),.b(b[i*4-1 : i*4-4]),.ci(c[i-2]),.sum(sum[sum[i*4-1 : i*4-4]]),.c_out(c[i-1]));
    end
end

endgenerate

assign c_out = c[3];

endmodule
