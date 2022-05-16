module fsm_bspd(clk,reset,bit_in,det_out);
input clk,reset,bit_in;
output det_out;

//states
parameter  S_X= 'd0;
parameter  S_0= 'd1;
parameter  S_00= 'd2;
parameter  S_001= 'd3;

//state registers
reg[1:0] current_state,next_state;


always @(posedge clk or posedge reset)
begin
    current_state <= reset ? S_X : next_state;
end

//next_state_logic
always @(*)
begin
    case(current_state)
    S_X:
    begin
        next_state = !bit_in ? S_0 : S_X ;
    end
    S_0:
    begin
        next_state = !bit_in ? S_00 : S_X;
    end
    S_00:
    begin
        next_state = bit_in ? S_001 : S_00;
    end
    S_001:
    begin
       next_state = bit_in ? S_X : S_0;
    end
    default:
    begin
        next_state = S_X;
    end
    endcase
end

//output_logic
assign det_out = ((!bit_in) && (current_state == S_001)) ? 1'b1 : 1'b0;


endmodule