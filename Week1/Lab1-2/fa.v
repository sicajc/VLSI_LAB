module fa(input a,
          input b,
          input ci,
          output sum,
          output cout);

    wire ha1_co,ha1_sum;
    wire ha2_co,ha2_sum;

    ha ha1(.a(a),.b(b),.cout(ha1_co),.sum(ha1_sum));
    ha ha2(.a(ci),.b(ha1_sum),.cout(ha2_co),.sum(ha2_sum));

    assign sum = ha2_sum;
    assign cout = ha+1_co | ha2_co ;

endmodule
