/******************************************************************
* Author       : Andrew Giebfried
* Creation Date: 2024/01/08
* Last Update  : 2024/05/30
* License      : MIT License
*******************************************************************/

module fib_test();

reg clk;
reg[7:0] num;
reg[31:0] fib;
reg done;
reg start;
reg[31:0] fib_table[47:0];
initial begin
    clk  = 0;
    num  = 0;
    done = 0;
    start= 1;
    fib_table[0] = 0;
    fib_table[1] = 1;
    for(int i=2;i<=47;i=i+1) begin
        fib_table[i] = fib_table[i-1]+fib_table[i-2];
    end
end

always @(posedge clk) begin
    
    if(done) begin
        assert(fib == fib_table[num[5:0]]) else $error("fib(%d) == %d != %d",num,fib, fib_table[num[5:0]]);
        $display("Fib(%d)=%d (%d) %d",num,fib,fib_table[num[5:0]],done);
        num   <= num + 1;
        start <= 1'b1;
    end else begin
        start <= 1'b0;
    end

    if(num == 48) //stop before 32-bit overflow
        $finish();
end

//fibbonacci dut(num,clk,fib); // num, start, clk, | fib, ready
fibbonacci #(8) dut (num,start,clk,fib,done);
always forever begin
    #10 clk <= ~clk;
end

endmodule : fib_test