`timescale 1ns / 1ps


//helps remove metastability and inverts signals.
//all inputs are processed through two flip flops
//hence the output is synced to the clock

module key_synchroniser (
    input  logic       clk,
    input  logic [3:0] key_n,    //active-low, asynchronous
    output logic [3:0] key_sync  //active-high, synchronised
);
  logic [3:0] pre_sync;
  initial key_sync = '0;
  initial pre_sync = '0;

  always_ff @(posedge clk) begin
    pre_sync <= ~key_n;
    key_sync <= pre_sync;
  end


endmodule
