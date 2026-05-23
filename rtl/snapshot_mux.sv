`timescale 1ns / 1ps
//If hold is low, q equals d exactly, no delay
//(comb logic)
//
//When hold is high, q is frozen at the value
//d held on the previous clock edge before hold
//went high
//
module snapshot_mux #(
    parameter int WIDTH = 1
) (
    input logic clk,
    input logic hold,  //When to snapshot
    input logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);
  logic [WIDTH-1:0] snapd;

  initial snapd = '0;

  always_ff @(posedge clk) begin
    if (!hold) snapd <= d;  //updates snapd only if hold is off
    //if hold is on then stop updating
  end



  always_comb begin
    if (!hold) q = d;
    else q = snapd;
  end

endmodule
