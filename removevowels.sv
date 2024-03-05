/******************************************************************
* Author       : Andrew Giebfried
* Creation Date: 2024/01/08
* Last Update  : 2024/01/08
* License      : MIT License
*******************************************************************/

/* Solution for LeetCode Problem #1119 "Remove Vowels From A String"
*
* This is a seemingly very simple problem, but needs careful consideration
* about the protocol used. First off, as this is being implemented in hardware
* it makes more sense that we are editing a data stream rather than altering
* pre-existing data in memory. Although mostly ignored, ASCII does have
* control characters and can handle data as a stream. (So when you run python
* on the command line and tells you to press ctrl-D to quit, it reads the ASCII
* control character EOT End-of-Transmission and then quits). For true ASCII the
* null packet actually means to _ignore_ the data.
*
* We could also intercept keyboard data (e.g. from USB or PS/2 data) and drop the 
* packet containing the vowels read in. But possibly for later.
*
* Time Complexity  : O(1)
* Memory Complexity: O(1)
*/


module removevowels (
    input logic clk,
    input logic  [7:0] ascii_in, //technically ASCII is 7 bits...
    output logic [7:0] ascii_out
);

logic [9:0][7:0] vowels = "AEIOUaeiou";//same as {"A","E","I","O","U", "a","e","i","o","u"};

always_ff @(posedge clk) begin
    ascii_out <= ascii_in; 
    for(int v=0;v<$size(vowels);v++) begin
        if(ascii_in == vowels[v]) begin
            // For true ASCII, null packet means to _ignore_ the data.
           ascii_out <= 8'h00; 
        end
    end
end

endmodule : removevowels

module removevowels_test();

string msg;
integer idx;
logic clk;
logic[7:0] in;
logic[7:0] filtered;

removevowels removevowels_dut(clk,in,filtered); 

initial begin
    msg = "Hello World!";
    idx = 0;
end

always forever begin
    #10 clk <= ~clk;
end

always @(posedge clk) begin
    idx <= idx + 1;
    in <= msg.getc(idx);
    $write("%c",filtered);
    if(idx >= msg.len()) begin
        $write("\n");
        $finish();
    end

end

endmodule : removevowels_test