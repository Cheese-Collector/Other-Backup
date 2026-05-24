`timescale 1ns / 1ps
//controls state switching as described by 4.1

module stopwatch_control (
    input  logic clk,
    input  logic rise_start_stop,
    input  logic rise_lap,
    output logic counter_rst,
    output logic counter_enable,   //low is stopped
    output logic lap_hold
);


  initial counter_rst = '0;
  initial counter_enable = '0;
  initial lap_hold = '0;

  logic nxt_counter_rst;
  logic nxt_counter_enable;
  logic nxt_lap_hold;


  wire  ss_iso = rise_start_stop && !rise_lap;
  wire  lap_iso = !rise_start_stop && rise_lap;

  always_comb begin
    nxt_counter_enable = ss_iso ? ~counter_enable : counter_enable;  //toggles
    nxt_counter_rst = (!lap_hold && lap_iso && !counter_enable);  //live stopped and lap input
    nxt_lap_hold = (lap_iso && counter_enable) ? ~lap_hold : lap_hold;
  end



  always_ff @(posedge clk) begin
    counter_rst <= nxt_counter_rst;
    counter_enable <= nxt_counter_enable;
    lap_hold <= nxt_lap_hold;
  end
endmodule
