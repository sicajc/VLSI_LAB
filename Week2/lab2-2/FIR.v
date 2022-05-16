module FIR(Dout,
           Din,
           clk,
           reset);

    parameter b0 = 7;
    parameter b1 = 17;
    parameter b2 = 32;
    parameter b3 = 46;
    parameter b4 = 52;
    parameter b5 = 46;
    parameter b6 = 32;
    parameter b7 = 17;
    parameter b8 = 7;

    output	[17:0]	Dout;
    input 	[7:0] 	Din;
    input 		clk, reset;

    reg[17:0] cal_out[0:8];
    reg[7:0] shift_regs[0:7];

    integer reg_index;
    //registers group
    always @(posedge clk)
    begin
        for(reg_index = 0;reg_index < 8 ; reg_index = reg_index + 1)
        begin
            if (reset)
            begin
                shift_regs[reg_index] <= 'd0;
            end
            else
            begin
                if(reg_index == 0)
                    shift_regs[reg_index] <= Din;
                else
                    shift_regs[reg_index] <= shift_regs[reg_index-1];
            end
        end
    end

    //Registers assignments
    assign Dout = (((Din * b0 + 'd0) + (shift_regs[0] * b1)) + (shift_regs[1] * b2) + (shift_regs[2] * b3)+(shift_regs[3]*b4)+
        (shift_regs[4]*b5)+(shift_regs[5]*b6) + (shift_regs[6]*b7) + (shift_regs[7]*b8));


endmodule
