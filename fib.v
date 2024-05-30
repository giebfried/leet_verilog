
/******************************************************************
* Author       : Andrew Giebfried
* Creation Date: 2023/12/30
* Last Update  : 2023/5/30
* License      : MIT License
*******************************************************************/

/* Solution for LeetCode Problem #509 "Fibonacci Number."
*
* A closed form solution can be determined using Binet's formula
*
*              Fib(n) = round( 1/sqrt(5) * phi^n )
*
* However using floating points and the power term is quite computationally expensive. Also
* waiting up to log(n)+1 cycles is also infeasible. So for 8-bit inputs, just listing all 256 inputs
* would be the best way to do this. However, that isn't very interesting, so lets compute it
* directly. We can use a 2x2 matrix and the exponentiation by squaring algorithm to compute
* this effectively using only integer arithmetic. Pipelining will not lead to much improvement
* because saving all possible values in memory is faster and smaller than calculating it!
*
* Note: Based on the above formula, the width for the fibbonacci number is ~ O(log(1.6^n)) => O(n)
* So saving all data in RAM/ROM would be O(n^2) 
*
* Time Complexity       : O(log(n)) [for very big n, we'll need a slower clock and will approach O(nlog(n))]
* Memory/Area Complexity: O(n^2)    [~10 multipliers]
*/

module fibbonacci
#(
    parameter  int NUM_WIDTH = 8,
    localparam real phi = (1+$sqrt(5))/2,
    localparam int FIB_WIDTH = 1+$clog2($rtoi((phi**(2**(NUM_WIDTH-1)))/$sqrt(5))),//based on Binet's formula +1 bit for signed bits
    localparam int F0 = F2-F1,
    parameter  int F1 = 1, //we can change this to 2 to generate Lucas Numbers
    parameter  int F2 = 1
)(
    input [NUM_WIDTH-1:0] num,
    input start,
    input clk,
    output wire[FIB_WIDTH-1:0] fib,
    output reg ready
);

//Performs the exponentiation by squaring algorithm.
//Note that while matrix multiplication is not commutitive, it is transistive, so
//we can group the matrix multiplication in such a way that we do the odd parts last
    reg [FIB_WIDTH-1:0] fn,fp,fm;
    reg [FIB_WIDTH-1:0] gn,gp,gm;
    reg [NUM_WIDTH-1:0] n;

    assign fib = gn;
    always @(posedge clk) begin
        ready <= 1'b0;
        if(start) begin
            //ready <= 1'b0;
            if(num > 0) begin
                // [[1,1],[1,0]]
                fp <= F2[FIB_WIDTH-1:0];
                fn <= F1[FIB_WIDTH-1:0];
                fm <= F0[FIB_WIDTH-1:0];
                n <= num;
            end else if (num == 0) begin
                 // [[1,0],[0,1]]
                fp <= F1[FIB_WIDTH-1:0];
                fn <= F0[FIB_WIDTH-1:0];
                fm <= {F1-F0}[FIB_WIDTH-1:0];
                n <= 0;
            end else begin //n < 0
                // [[0,1],[1,-1]]
                fp <= F0[FIB_WIDTH-1:0];
                fn <= {F1-F0}[FIB_WIDTH-1:0];
                fm <= {(F1-F0) - F0}[FIB_WIDTH-1:0];
                n <= -num;
            end
            // [[1,0],[0,1]]
            gp <= 1;
            gn <= 0;
            gm <= 1;
        end else if (!ready) begin
            ready <= ~(|(n)); //(n == 0)
            if((n[0] == 1'b1)) begin //odd
                gp <= gp * fp + gn * fn;
                gn <= gp * fn + gn * fm;
                gm <= gn * fn + gm * fm; //Note: gn*fn term repeated and should be optimized away
            end

            fp <= fp * fp + fn * fn;
            fn <= fp * fn + fn * fm;
            fm <= fn * fn + fm * fm;

            n <= n >> 1; // n/2, but also subtracts 1 in case of odd number
        end
    end    
endmodule : fibbonacci

