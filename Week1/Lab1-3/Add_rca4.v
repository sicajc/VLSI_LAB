module Add_rca4(input[3:0] a,
                input[3:0] b,
                input cin,
                output[3:0] sum,
                output c_out);

genvar i;
wire[3:0] c;

generate
for(i = 0;i<4;i = i+1)
begin
    if (i == 0)
    begin
        fa fa1(.a(a[0]),.b(b[0]),.ci(c_in),.sum(sum[0]),.c_out(c[0]));
    end
    else
    begin
        fa fas(.a(a[i]),.b(b[i]),.ci(c[i-1]),.sum(sum[i]),.c_out(c[i]));
    end
end
endgenerate

assign c_out = c[3];


endmodule
