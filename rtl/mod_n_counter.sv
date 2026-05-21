//Up counter with upper limit N.
//With reset pin.
//Resets when rst is high or count reaches the upper limit.

`timescale 1ns / 1ps

module mod_n_counter #(
    parameter int N = 4,
    parameter int WIDTH = 2
) (
    input logic clk,
    input logic rst,
    input logic enable,
    output logic [WIDTH-1:0] count
);
  logic [WIDTH-1:0] next_count;

  initial count = '0;



  always_ff @(posedge clk) begin
    if (rst) count <= '0;
    else if (enable) count <= next_count;
  end

  always_comb begin
    if (count == WIDTH'(N - 1)) next_count = '0;
    else next_count = count + WIDTH'(1);
  end
endmodule
