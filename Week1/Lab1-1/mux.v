module mux(input a,
           input b,
           input sel,
           output out);
    
    
    wire a1,b1;
    
    assign a1  = a & !sel;
    assign b1  = sel & b;
    assign out = a1 | b1;
    
endmodule
