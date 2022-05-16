module ha(input a,
          input b,
          output c_out,
          output sum);


    assign c_out = a & b;
    assign sum = a ^ b;

endmodule
