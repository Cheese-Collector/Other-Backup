`timescale 1ns / 1ps

//keeps track of what mode is enabled
//when count is 0, button must be held enough (HOLD_CYCLES)
//for long_press to arm the latch. arming the latch allows
//count to advance to 1. Thereafter, each brief press of button
//advances count further by 1, wrapping to 0 and repeating.



//In better language. When button is held for long enough,
//edit mode is engaged. While in edit mode, each button press,
//advances through the selections: seconds, minutes and hours.
//After we advance past hours, edit mode is disable and the
//button must be held again to activate.

module edit_mode_selector #(
    parameter int HOLD_CYCLES = 50_000_000
) (
    input logic clk,
    input logic button,
    output logic [2:0] mode_enable
);

  logic long_press;
  button_hold_pulse #(
      .HOLD_CYCLES(HOLD_CYCLES)
  ) u_hold_pulse (
      .clk(clk),
      .button(button),
      .pulse(long_press)
  );

  logic press;
  rising_edge_detector u_detector (
      .clk(clk),
      .sig_in(button),
      .rise(press)
  );

  logic armed;
  logic disarm;
  arming_latch u_latch (
      .clk(clk),
      .arm(long_press),
      .disarm(disarm),
      .armed(armed)
  );

  logic reset_counter;
  logic enable_counter;
  logic [1:0] count;
  mod_n_counter #(
      .N(3),
      .WIDTH(2)
  ) u_mod_3_counter (
      .clk(clk),
      .rst(reset_counter),
      .enable(enable_counter),
      .count(count)
  );

  //counter runs only while armed; resets when disarmed
  assign enable_counter = armed ? press : '0;
  assign reset_counter = !armed;

  //Disarm on the press that steps past the last mode
  assign disarm = (count == 2'd2) && press;

  //output logic
  assign mode_enable = armed ? (3'b001 << count) : 3'b000;

endmodule
