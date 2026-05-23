`timescale 1ns / 1ps
//three counters.
//first counter counts as usual
//when enable high and rst low, count0
//advances to clk tick.

//when count0 rollsover, count1 ticks
//when count1 rollsover, count2 ticks

//if rst, set all counts to 0. All
//initialise to 0.
//If rst and enable are low. remain unchanged



module cascade_counter #(
    parameter int N2 = 3,  //wraps at N-1 and ticks over
    parameter int N1 = 4,
    parameter int N0 = 5,

    //output port widths
    parameter int W2 = 2,
    parameter int W1 = 2,
    parameter int W0 = 3
) (
    input logic clk,
    input logic rst,
    input logic enable,
    output logic [W2-1:0] count2,
    output logic [W1-1:0] count1,
    output logic [W0-1:0] count0
);

  logic roll0;
  logic roll1;

  assign roll0 = (count0 == W0'(N0 - 1)) && enable;
  assign roll1 = (count1 == W1'(N1 - 1)) && roll0;


  mod_n_counter #(
      .N(N0),
      .WIDTH(W0)
  ) u_counter0 (
      .clk(clk),
      .rst(rst),
      .enable(enable),
      .count(count0)
  );


  mod_n_counter #(
      .N(N1),
      .WIDTH(W1)
  ) u_counter1 (
      .clk(clk),
      .rst(rst),
      .enable(roll0),
      .count(count1)
  );


  mod_n_counter #(
      .N(N2),
      .WIDTH(W2)
  ) u_counter2 (
      .clk(clk),
      .rst(rst),
      .enable(roll1),
      .count(count2)
  );


endmodule
