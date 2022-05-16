module alu(alu_out,
           accum,
           data,
           opcode,
           zero,
           clk,
           reset);
    input 		clk, reset;
    input 	[7:0] 	accum, data;
    input 	[2:0] 	opcode;
    output reg[7:0] 	alu_out;
    output 		zero;

    reg[7:0] mux_out;

    //alu_out_reg
    always @(posedge clk) begin
        alu_out <= reset ? 'd0 : mux_out;
    end

    //mux selection
    always @(*)
    begin
        case(opcode)
        3'b000:    mux_out = accum;
        3'b001:    mux_out = accum + data;
        3'b010:    mux_out = accum - data;
        3'b011:    mux_out = accum & data;
        3'b100:    mux_out = accum ^ data;
        3'b101:    mux_out = ~accum + 1;
        3'b110:    mux_out = accum * 'd5 + accum / 'd8;
        3'b111:    mux_out = (accum >= 'd32 ) ? data : ~data;
        default:    mux_out = 'd0;
        endcase
    end

    //zero detection
    assign zero = (accum == 'd0);

endmodule
