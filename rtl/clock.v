`timescale 1ns / 1ps
module top_module(
    input clk,
    input reset,
    input enable,
    output [3:0] q1,
    output [3:0] q2,
    output [3:0] q3,
    output [3:0] q4,
    output [3:0]unit_hour,
    output[3:0] ten_hour,
    output [6:0] seg0,
    output [6:0] seg1,
    output [6:0] seg2,
    output [6:0] seg3,
    output [6:0] seg4,
    output [6:0] seg5
    
);
wire carry_unitsec;
wire carry_tensec;
wire carry_unitmin;
wire carry_tenmin;

unit_sec u1(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .q1(q1),
    .carry_unitsec(carry_unitsec)
);
ten_sec u2(
    .clk(clk),
    .reset(reset),
    .enable_tensec(carry_unitsec),
    .q2(q2),
    .carry_tensec(carry_tensec)
);
unit_min u3(
.clk(clk),
.reset(reset),
.enable_unitmin(carry_tensec),
.q3(q3),
.carry_unitmin(carry_unitmin)
);
ten_min u4(
    .clk(clk),
    .reset(reset),
    .enable_tenmin(carry_unitmin),
    .q4(q4),
    .carry_tenmin(carry_tenmin)
);
hour u5 (
.clk(clk),
.reset(reset),
.enable_hour(carry_tenmin),
.unit_hour(unit_hour),
.ten_hour(ten_hour)
);
bcd_to7seg U0(.bcd(q1),.seg(seg0));
bcd_to7seg U1(.bcd(q2),.seg(seg1));
bcd_to7seg U2(.bcd(q3),.seg(seg2));
bcd_to7seg U3(.bcd(q4),.seg(seg3));
bcd_to7seg U4(.bcd(unit_hour),.seg(seg4));
bcd_to7seg U5(.bcd(ten_hour),.seg(seg5));


endmodule

module unit_sec(
input clk,reset,enable,
output reg [3:0]q1,
output carry_unitsec 
    );
   
   assign  carry_unitsec = (q1==4'd9) && enable;
    always@(posedge clk )begin
    if(reset)
    q1<=4'd0;
    else if (enable)
      begin 
    if (q1==4'd9)
    q1<=4'd0;
    else 
    q1 <= q1+1;
    end 
  end
endmodule

module ten_sec(
input clk,reset,enable_tensec,
output reg [3:0]q2,
output carry_tensec 
    );
   
   assign  carry_tensec = (q2==4'd5) && enable_tensec;
    always@(posedge clk )begin
    if(reset)
    q2<=4'd0;
    else if ( enable_tensec)
      begin 
    if (q2==4'd5)
    q2<=4'd0;
    else 
    q2 <= q2+1;
    end 
  end
endmodule

module unit_min(
input clk,reset,enable_unitmin,
output reg [3:0]q3,
output carry_unitmin 
    );
   
   assign  carry_unitmin = (q3==4'd9) && enable_unitmin;
    always@(posedge clk )begin
    if(reset)
    q3<=4'd0;
    else if (enable_unitmin)
      begin 
    if (q3==4'd9)
    q3<=4'd0;
    else 
    q3 <= q3+1;
    end 
  end
endmodule

module ten_min(
input clk,reset,enable_tenmin,
output reg [3:0]q4,
output carry_tenmin
    );
   
   assign  carry_tenmin = (q4==4'd5) && enable_tenmin;
    always@(posedge clk )begin
    if(reset)
    q4<=4'd0;
    else if ( enable_tenmin)
      begin 
    if (q4==4'd5)
    q4<=4'd0;
    else 
    q4<= q4+1;
    end 
  end
endmodule


module hour(
input clk,reset,enable_hour,
output reg [3:0]unit_hour,
output reg [3:0]ten_hour
);
always@(posedge clk)
if(reset)begin
unit_hour <= 4'd0;
ten_hour <= 4'd0 ;
end
else if (enable_hour) begin 
if ( ten_hour == 4'd2 && unit_hour == 4'd3)begin
unit_hour <= 4'd0;
ten_hour <= 4'd0;
end
else if(unit_hour ==4'd9 )begin
unit_hour <= 4'b0;
ten_hour <= ten_hour +1;
end
else begin
unit_hour <= unit_hour+1;
ten_hour <= ten_hour;
end
end
endmodule


module bcd_to7seg(
    input  [3:0] bcd,
    output reg [6:0] seg
);

always @(*) begin
    case(bcd)
        4'd0: seg = 7'b1111110;
        4'd1: seg = 7'b0110000;
        4'd2: seg = 7'b1101101;
        4'd3: seg = 7'b1111001;
        4'd4: seg = 7'b0110011;
        4'd5: seg = 7'b1011011;
        4'd6: seg = 7'b1011111;
        4'd7: seg = 7'b1110000;
        4'd8: seg = 7'b1111111;
        4'd9: seg = 7'b1111011;
        default: seg = 7'b0000000;
    endcase
end

endmodule