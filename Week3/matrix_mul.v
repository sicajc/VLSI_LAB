module matrix_mul(clk,rst,in_en,datain,multout,valid);
input clk;
input rst;
input in_en;
input [3:0] datain;
output reg [9:0] multout;
output reg valid;

reg[3:0] di0,di1,di2;
reg[9:0] mo0,mo1,mo2;

parameter a = 2;
parameter b = 1;
parameter c = 3;

//FSM
//States
parameter RD_DATA='d0 ;
parameter MATRIX_CAL='d1 ;
parameter OUTPUT_STAGE= 'd2;

//states indicators
wire state_RD_DATA = (current_state == RD_DATA);
wire state_MATRX_CAL =(current_state == MATRIX_CAL);
wire state_OUTPUT_STAGE = (current_state == OUTPUT_STAGE);

//State registers
reg[1:0] current_state,next_state;

//Counter register
reg[1:0] counter_reg;

//FLAGS
wire rd_done_flag = state_RD_DATA ? (counter_reg == 'd2) : 1'b0;
wire output_done_flag = state_OUTPUT_STAGE ? (counter_reg == 'd2) : 1'b0;

//MAIN CTR
always @(posedge clk or negedge rst)
begin
    current_state <= rst ? RD_DATA : next_state;
end

always @(*)
begin
    case(current_state)
        RD_DATA:
        begin
            next_state = rd_done_flag ? MATRIX_CAL : RD_DATA;
        end
        MATRIX_CAL:
        begin
            next_state = OUTPUT_STAGE;
        end
        OUTPUT_STAGE:
        begin
            next_state = output_done_flag ? RD_DATA : OUTPUT_STAGE;
        end
        default:
        begin
            next_state = RD_DATA;
        end
    endcase
end


//COUNTER
always @(posedge clk or negedge rst)
begin
    if(rst)
    begin
        counter_reg <= 'd0;
    end
    else
    begin
        case(current_state)
            RD_DATA:
            begin
                counter_reg <= rd_done_flag ? 'd0 : ( in_en ? counter_reg + 'd1 : counter_reg);
            end
            OUTPUT_STAGE:
            begin
                counter_reg <= output_done_flag ? 'd0 : counter_reg + 'd1;
            end
            default:
            begin
                counter_reg <= counter_reg;
            end
        endcase
    end
end

//registers d0,d1,d2
always @(posedge clk or negedge rst)
begin
    if(rst)
    begin
        di0 <= 'd0;
        di1 <= 'd0;
        di2 <= 'd0;
    end
    else if(state_RD_DATA)
    begin
        case(counter_reg)
            'd0:
                di0 <= datain;
            'd1:
                di1 <= datain;
            'd2:
                di2 <= datain;
            default:
            begin
                di0 <= 'd0;
                di1 <= 'd0;
                di2 <= 'd0;
            end
        endcase
    end
    else
    begin
        di0 <= di0;
        di1 <= di1;
        di2 <= di2;
    end
end

//registers mo1,mo2,mo3
always @(posedge clk or negedge rst)
begin
    if(rst)
    begin
        mo0  <=  'd0 ;
        mo1 <= 'd0 ;
        mo2 <=  'd0 ;
    end
    else if(MATRIX_CAL)
    begin
        mo0 <= a * di0 + b * di1 + c * di2;
        mo1 <= b * di0 + b * di1 + a * di2;
        mo2 <= c * di0 + b * di1 + a * di2;
    end
    else
    begin
        mo0 <= mo0;
        mo1 <= mo1;
        mo2 <= mo2;
    end
end


//output stage
always @(*)
begin
    if(state_OUTPUT_STAGE)
    begin
        valid = 1'b1;
        case(counter_reg)
            'd0:
            begin
                multout = mo0;
            end
            'd1:
            begin
                multout = mo1;
            end
            'd2:
            begin
                multout = mo2;
            end
            default:
            begin
                multout = 'd0;
            end
        endcase
    end
    else
    begin
        valid = 1'b0;
        multout = 'd0;
    end
end
endmodule
