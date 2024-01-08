/******************************************************************
* Author       : Andrew Giebfried
* Creation Date: 2024/01/08
* Last Update  : 2024/01/08
* License      : MIT License
*******************************************************************/

/* Solution for LeetCode Problem #326 "Power of Three"
*
* The general approach for this problem is to take the log base 3
* of the number in question, then check if n = 3^log3(n)
*  
* To compute log3() we use bit twiddling to find log2() and change　base
*
*   log3(x) = log2(x)/log2(3)
*
* To compute pow(3,x), we can instead compute (1+2)^x using its
* binomial expansion (i.e. Pascal's Triangle). The one term can be
* ignored and the 2 term can use bit-shifts instead.  
*
* Time Complexity  : O(1)
* Memory Complexity: O(log(n)^2)
*/


module powerof3(
    input  logic clk,
    input  logic [31:0] n,
    output logic ispow3
);

//compute ceil[log2(x)] based on find first set approach
function [4:0] log2(input [31:0] n);
    static logic flag1 = 0;
    static logic flag2 = 0;
    for(int i=0;i<32;i+=1) begin
        if(n[i]) begin
            log2 = i[4:0];
            flag2 = flag1;
            flag1 = 1'b1;
        end
    end
    log2 = log2 + {3'b0,flag2};
endfunction

//delay input signal for later stages
localparam N_STAGES = 4;
logic [31:0] n_pipe [N_STAGES-1:0];
initial begin
    n_pipe = {0,0,0,0};
end
always @(posedge clk) begin
    n_pipe <= {n_pipe[2:0],n}; ;
end

//pipeline stage (1)
logic [4:0] pow2;
always @(posedge clk) begin
    pow2 <= log2(n);
end

//pipeline stage (2)
localparam ILOG3 = 2709822657; // sufficiently accurate for 32 bits
logic [4+32:0] ppow3;
wire [4:0] pow3; 
always @(posedge clk) begin
    ppow3 <= (ILOG3*pow2);
end
assign pow3 = ppow3[5+32-1:32];

//pipeline stage (3)
logic [31:0] coef [31:0];
pascal_triangle pt(clk,pow3,coef);

//pipeline stage (4)
logic [31:0] m;
always @(posedge clk) begin
    // Because (0 << x) == 0, we don't need to worry about terminating early.
    // In a synthesizable implementation, the summation should also be split
    // into multiple stages.
    m = 0;
    for(int i=0;i<32;i+=1) begin
        m = m + (coef[i] << i); 
    end
    ispow3 <= ~(|(m ^ n_pipe[2])) & (|m); //m == n, m != 0
end

// Check validity of module using assertions. 
// This should be in its own .svh file. 
// Note: Verilator does not support ##N syntax.
property n_is_power_of_3;
    @(posedge clk)
       $past(n,N_STAGES-1) != 0 && 
       $rtoi($ceil($log10($past(n,N_STAGES-1))/$log10(3.0))) < 20 && //no 32-bit integer overflow
       $past(n,N_STAGES-1) == 3**$rtoi($ceil($log10($past(n,N_STAGES-1))/$log10(3.0))) 
       |=> ispow3; 
endproperty;
property n_is_not_power_of_3;
    @(posedge clk)
       $past(n,N_STAGES-1) == 0 || 
       $rtoi($ceil($log10($past(n,N_STAGES-1))/$log10(3.0))) < 20 &&
       $past(n,N_STAGES-1) != 3**$rtoi($ceil($log10($past(n,N_STAGES-1))/$log10(3.0))) 
       |=> !ispow3;
endproperty;
n_is_power_of_3_assertion     : assert property (n_is_power_of_3)     else $error("%d is not power of 3 ",$past(n,N_STAGES-1));
n_is_not_power_of_3_assertion : assert property (n_is_not_power_of_3) else $error("%d is power of 3 "    ,$past(n,N_STAGES-1));

endmodule : powerof3
