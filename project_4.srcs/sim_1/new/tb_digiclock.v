`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2026 11:49:07
// Design Name: 
// Module Name: tb_digiclock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////







module tb_digiclock;

    reg clk;
    reg reset;
    reg enable;

    wire [3:0] q1;
    wire [3:0] q2;
    wire [3:0] q3;
    wire [3:0] q4;
    wire [3:0] unit_hour;
    wire [3:0] ten_hour;

    wire [6:0] seg0, seg1, seg2, seg3, seg4, seg5;

    integer errors;

    top_module uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .q1(q1),
        .q2(q2),
        .q3(q3),
        .q4(q4),
        .unit_hour(unit_hour),
        .ten_hour(ten_hour),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .seg4(seg4),
        .seg5(seg5)
    );

    // Clock
    always #5 clk = ~clk;

    // -------------------------
    // CHECK TASK
    // -------------------------
    task check_time;
        input [3:0] eh_ten, eh_unit;
        input [3:0] em_ten, em_unit;
        input [3:0] es_ten, es_unit;
        input [255:0] msg;
        begin
            if (ten_hour == eh_ten &&
                unit_hour == eh_unit &&
                q4 == em_ten &&
                q3 == em_unit &&
                q2 == es_ten &&
                q1 == es_unit)
            begin
                $display("PASS: %s --> %0d%0d:%0d%0d:%0d%0d",
                         msg, ten_hour, unit_hour, q4, q3, q2, q1);
            end
            else begin
                $display("FAIL: %s", msg);
                $display("Expected: %0d%0d:%0d%0d:%0d%0d",
                         eh_ten, eh_unit, em_ten, em_unit, es_ten, es_unit);
                $display("Got     : %0d%0d:%0d%0d:%0d%0d",
                         ten_hour, unit_hour, q4, q3, q2, q1);
                errors = errors + 1;
            end
        end
    endtask

    // -------------------------
   
    initial begin
        $display("TB STARTED");

        clk = 0;
        reset = 1;
        enable = 0;
        errors = 0;

        // Hold reset
        #12;
        @(posedge clk);
        #1;
        check_time(0,0,0,0,0,0,"Reset Initialization");

        // : RELEASE RESET
        reset = 0;
        enable = 1;

       
        // 00:00:09 ? 00:00:10
       
        wait (ten_hour==0 && unit_hour==0 && q4==0 && q3==0 && q2==0 && q1==9);
        @(posedge clk);
        #1;
        check_time(0,0,0,0,1,0,"00:00:09 ? 00:00:10");

        
        // 00:00:59 ? 00:01:00
       
        wait (ten_hour==0 && unit_hour==0 && q4==0 && q3==0 && q2==5 && q1==9);
        @(posedge clk);
        #1;
        check_time(0,0,0,1,0,0,"00:00:59 ? 00:01:00");

        
        // ? 00:09:59 ? 00:10:00
       
        wait (ten_hour==0 && unit_hour==0 && q4==0 && q3==9 && q2==5 && q1==9);
        @(posedge clk);
        #1;
        check_time(0,0,1,0,0,0,"00:09:59 ? 00:10:00");

        
        //  00:59:59 ? 01:00:00
       
        wait (ten_hour==0 && unit_hour==0 && q4==5 && q3==9 && q2==5 && q1==9);
        @(posedge clk);
        #1;
        check_time(0,1,0,0,0,0,"00:59:59 ? 01:00:00");

      
        // 23:59:59 ? 00:00:00
       
        wait (ten_hour==2 && unit_hour==3 && q4==5 && q3==9 && q2==5 && q1==9);
        @(posedge clk);
        #1;
        check_time(0,0,0,0,0,0,"23:59:59 ? 00:00:00");

        // Final
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TOTAL FAILS = %0d", errors);

        $display("TB ENDED AT %0t", $time);
        $finish;
    end

endmodule