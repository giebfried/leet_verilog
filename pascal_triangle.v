/******************************************************************
* Author       : Andrew Giebfried
* Creation Date: 2023/12/31
* Last Update  : 2023/12/31
* License      : MIT License
*******************************************************************/

/* Solution for LeetCode Problem #119 "Pascal's Triangle (2)"
*
* Generates the nth row of Pascal's Triangle. Unused entries are set to 0.
* Values are pre-computed and stored into ROM for fast access.
*
* Time Complexity  : O(1)
* Memory Complexity: O(n^2)
*/


module pascal_triangle
#(  parameter ROWS = 32,
    localparam LOG2ROWS = $clog2(ROWS) 
)(
    input clk,
    input  [LOG2ROWS-1:0] nrow,
    output logic [ROWS-1:0] coefficients [ROWS-1:0] // sum of elements in nrow = 2^nrow
);

integer  pascal_table [ROWS-1:0][ROWS-1:0];// 
initial begin
    // Generate entire table.
    // When ROWS=32, this table is naively 32kb, but can probably be reduced to under 7680b.
    // However this would be rather tedious to implement.
    pascal_table[0][0] = 1;
    for(int i=1;i<ROWS;i+=1) begin
         pascal_table[0][i] = 0;
    end

    for(int i=1;i<ROWS;i+=1) begin
        pascal_table[i][0] = 1;
        for(int j=1;j<ROWS;j+=1) begin
            pascal_table[i][j] = pascal_table[i-1][j-1]+pascal_table[i-1][j];
        end
    end
end

always @(posedge clk) begin
    coefficients <= pascal_table[nrow];
end


endmodule : pascal_triangle
