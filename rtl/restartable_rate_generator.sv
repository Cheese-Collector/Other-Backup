//If run is low (OFF), tick is low too
//
//Else if run is high (ON)
//If run has been high for CYCLE_COUNT-1 rising
//clock cycles, tick is high for exactly one clock
//cycle (the final clock cycle of CYCLE_COUNT)
//
//Thereafter, after each period of length CYCLE_COUNT
//where run has remained high, tick is high for exactly
//one clock cycle
//
//for case CYCLE_COUNT = 1, tick follows run directly

`timescale 1ns / 1ps

module restartable_rate_generator #(
    parameter int CYCLE_COUNT = 2
) (
    input  logic clk,
    input  logic run,
    output logic tick
);

  logic tick_qualifier;  //to go high at end of cycle

  logic running = 1'b0;
  always_ff @(posedge clk) running <= run;

  assign tick = running && tick_qualifier;  //tick high when running and at end of cycle

  generate
    if (CYCLE_COUNT > 1) begin : g_general
      //Code for general case
      //Includes module instantiation
      localparam int CountWidth = $clog2(CYCLE_COUNT);

      logic rst_count;
      logic enable_count;
      logic [CountWidth-1:0] count;
      mod_n_counter #(
          .N(CYCLE_COUNT),
          .WIDTH(CountWidth)
      ) u_count (
          .clk(clk),
          .rst(rst_count),
          .enable(enable_count),
          .count(count)
      );

      assign rst_count = !running;
      assign enable_count = running;

      assign tick_qualifier = (count == CountWidth'(CYCLE_COUNT - 2));
      //CountWidth param helps make the width of LHS equal that of RHS
    end else begin : g_special
      //Code for special case CYCLE_COUNT = 1;
      assign tick_qualifier = 1'b1;
    end
  endgenerate

endmodule
