// ------------------------------------------------------------------
// WARNING: This file is used by the automated test suite. Do not
// modify it.
//
// This file also serves as a template for your own designs. To use
// it:
//   1. Copy the entire contents into a new file with a descriptive
//      name.
//   2. Delete the test logic below and replace it with your own
//      code.
//   3. In top_de1_soc, change the module name from user_top to your
//      new module name.
//
//   The board wrapper sets CYCLES_PER_SECOND; use this parameter in
//   your design wherever timing is needed.
// ------------------------------------------------------------------
`timescale 1ns / 1ps

module user_top_stopwatch_v1 #(
    parameter int CYCLES_PER_SECOND = 50_000_000
) (
    input logic clk,
    /* verilator lint_off UNUSED */
    input logic [3:0] button,
    input logic [9:0] sw,
    /* verilator lint_on UNUSED */
    output logic [9:0] led,
    output logic [6:0] hours_disp,
    output logic [6:0] minutes_disp,
    output logic [6:0] seconds_disp,
    output logic blank_hours,
    output logic blank_minutes,
    output logic blank_seconds
);

  assign led = '0;

  assign blank_hours = '0;
  assign blank_minutes = '0;
  assign blank_seconds = '0;


  logic lap_rise;
  logic start_rise;
  rising_edge_detector u_riserlap (
      .clk(clk),
      .sig_in(button[1]),
      .rise(lap_rise)
  );

  rising_edge_detector u_riserstart (
      .clk(clk),
      .sig_in(button[0]),
      .rise(start_rise)
  );


  logic counter_rst;
  logic counter_enable;
  logic lap_hold;

  stopwatch_control u_cntrlr (
      .clk(clk),
      .rise_start_stop(start_rise),
      .rise_lap(lap_rise),
      .counter_rst(counter_rst),
      .counter_enable(counter_enable),
      .lap_hold(lap_hold)
  );

  //time logic
  logic [6:0] minutes;
  logic [5:0] seconds;
  logic [6:0] centiseconds;

  stopwatch_counter #(
      .CYCLES_PER_SECOND(CYCLES_PER_SECOND)
  ) u_stpcnt (
      .clk(clk),
      .rst(counter_rst),
      .enable(counter_enable),
      .minutes(minutes),
      .seconds(seconds),
      .centiseconds(centiseconds)
  );


  //combine all snapshots in one
  snapshot_mux #(
      .WIDTH(21)
  ) u_snapper (
      .clk(clk),
      .hold(lap_hold),
      .d({minutes, 1'b0, seconds, centiseconds}),
      .q({hours_disp, minutes_disp, seconds_disp})
  );  //violated naming convention. reusing the hour disp etc
  //to display the min sec and centisec


endmodule
