/******************************************************************
* Author       : Andrew Giebfried
* Creation Date: 2024/01/08
* Last Update  : 2024/01/08
* License      : MIT License
*******************************************************************/

module fib_test();

reg clk;
reg[7:0] num;
reg[31:0] fib;
integer fib_table[47:0];
initial begin
    clk = 0;
    num = 0;
    fib_table[0] = 0;
    fib_table[1] = 1;
    fib_table[2] = 1;
    fib_table[3] = 2;
    fib_table[4] = 3;
    fib_table[5] = 5;
    fib_table[6] = 8;
    fib_table[7] = 13;
    fib_table[8] = 21;
    fib_table[9] = 34;
    fib_table[10] = 55;
    fib_table[11] = 89;
    fib_table[12] = 144;
    fib_table[13] = 233;
    fib_table[14] = 377;
    fib_table[15] = 610;
    fib_table[16] = 987;
    fib_table[17] = 1597;
    fib_table[18] = 2584;
    fib_table[19] = 4181;
    fib_table[20] = 6765;
    fib_table[21] = 10946;
    fib_table[22] = 17711;
    fib_table[23] = 28657;
    fib_table[24] = 46368;
    fib_table[25] = 75025;
    fib_table[26] = 121393;
    fib_table[27] = 196418;
    fib_table[28] = 317811;
    fib_table[29] = 514229;
    fib_table[30] = 832040; 
    fib_table[31] = 1346269;
    fib_table[32] = 2178309;
    fib_table[33] = 3524578;
    fib_table[34] = 5702887;
    fib_table[35] = 9227465;
    fib_table[36] = 14930352;
    fib_table[37] = 24157817;
    fib_table[38] = 39088169;
    fib_table[39] = 63245986;
    fib_table[40] = 102334155;
    fib_table[41] = 165580141;
    fib_table[42] = 267914296;
    fib_table[43] = 433494437;
    fib_table[44] = 701408733;
    fib_table[45] = 1134903170;
    fib_table[46] = 1836311903;
    fib_table[47] = 2971215073;
end

always @(posedge clk) begin
    $strobe("Fib(%d)=%d (%d)",num,fib,fib_table[num[5:0]-1]);
    num <= num+1;
   

    if(num == 48) 
        $finish();
end

fibbonacci dut(num,clk,fib);

always forever begin
    #10 clk <= ~clk;
end

endmodule : fib_test
