//If run is low (OFF), tick is low too
//
//Else if run is high (ON)
//If run has been high for CYCLE_COUNT-1 rising
//clock cycles, tick is high for exactly one clock
//cycle (the final clock cycle of CYCLE_COUNT)
//
//Thereafter 


`timescale 1ns / 1ps

module restartable_rate_generator #(
    parameter int CYCLE_COUNT = 2
) (
    input  logic clk,
    input  logic run,
    output logic tick
);

  localparam int CountWidth = $clog2(CYCLE_COUNT);

  logic tick_qualifier;  //to go high at end of cycle

  logic running = 1'b0;
  always_ff @(posedge clk) running <= run;

  assign tick = running && tick_qualifier;

  generate
    ;
    if (CYCLE_COUNT > 1) begin : g_general
      //Code for general case
      //Includes module instantiation
    end else begin : g_special
      //Code for special case CYCLE_COUNT = 1;
    end
  endgenerate

endmodule
