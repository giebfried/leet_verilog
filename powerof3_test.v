/******************************************************************
* Author       : Andrew Giebfried
* Creation Date: 2024/01/08
* Last Update  : 2024/01/08
* License      : MIT License
*******************************************************************/
module powerof3_test();

reg clk;
reg[31:0] num;
reg[4:0] pow;
logic ispow3;
logic [31:0] results [20:0];

initial begin
    pow = 0;
    num = 0;
end

//Tests non-power of 3 values by using overflow values
always @(posedge clk) begin
    $write("%d 3^%d ",num,pow);
    num <= 3**pow;
    pow <= pow+1;
    $display("%d ",ispow3);

    if(pow == 28) 
        $finish();
end

powerof3 dut(clk,num,ispow3);

always forever begin
    #10 clk <= ~clk;
end


endmodule : powerof3_test
