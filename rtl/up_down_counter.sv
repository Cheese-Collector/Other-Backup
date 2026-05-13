//Counter than can count up and down for 0 to MAX
//with enable pin
//
//Parameters:
//MAX   - the max value stored in decimal
//WIDTH - number of binary digits to store max
//
//Ports:
//clk               - standard clock signal
//enable            - enable pin. only count when on
//up                - increment if up is true, decrement if false
//count [WIDTH-1:0] - count output
`timescale 1ns / 1ps


module up_down_counter #(
    parameter int MAX   = 2,
    parameter int WIDTH = 2
) (
    input logic clk,
    input logic enable,
    input logic up,
    output logic [WIDTH-1:0] count
);
  logic [WIDTH-1:0] next_count;
  always_ff @(posedge clk) if (enable) count <= next_count;

  // span of count set to 0 using "'"
  initial count = '0;

  //Restricts MAX 32bit width to new variable Max with 'WIDTH'bit width
  localparam logic [WIDTH-1:0] Max = WIDTH'(MAX);

  always_comb begin
    if (up) next_count = count < Max ? count + WIDTH'(1) : '0;
    else next_count = count > 0 ? count - WIDTH'(1) : Max;
  end
endmodule
