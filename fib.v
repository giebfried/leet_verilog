
/******************************************************************
* Author       : Andrew Giebfried
* Creation Date: 2023/12/30
* Last Update  : 2023/12/30
* License      : MIT License
*******************************************************************/

/* Solution for LeetCode Problem #509 "Fibonacci Number."
*
* A closed form solution can be determined using Binet's formula
*
*              Fib(n) = round( 1/sqrt(5) * phi^n )
*
* However the power term is quite computationally expensive. Also
* waiting up to 47 cycles is also infeasible. So a 47 element array
* would be the best way to do this.
*
* Time Complexity  : O(1)
* Memory Complexity: O(n)
*/


module fibbonacci(
    input [7:0] num, //from 0 to 47
    input clk,
    output reg[31:0] fib
);

    integer fib_table[47:0];
    initial begin
        fib_table[0] = 0;
        fib_table[1] = 1;
        for(int i=2;i<=47;i=i+1) begin
            fib_table[i] = fib_table[i-1]+fib_table[i-2];
        end

    end

    //don't consider negative fibbonacci numbers
    always @(posedge clk ) begin
        if (num < 48) begin
            fib <= fib_table[num[5:0]];
        end 
        else begin
            fib <= fib_table[0];
        end
    end
endmodule : fibbonacci
