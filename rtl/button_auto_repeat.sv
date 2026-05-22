`timescale 1ns / 1ps

//button module that sends a small pulse among initial
//press. after HOLD_CYCLES of the button being held,
//another pulse is sent out, repeating every
//REPEAT_CYCLES until the button is no longer held


module button_auto_repeat #(
    parameter int HOLD_CYCLES   = 50_000_000,
    //REPEAT_CYCLES must be smaller than HOLD_CYCLES
    parameter int REPEAT_CYCLES = 5_000_000
) (
    input  logic clk,
    input  logic button,
    output logic pulse
);

  logic rise;
  logic held;
  logic pulse_train;

  assign pulse = rise | (button & pulse_train);


  rising_edge_detector u_redge (
      .clk(clk),
      .sig_in(button),
      .rise(rise)
  );

  button_hold_detect #(
      .HOLD_CYCLES(HOLD_CYCLES - REPEAT_CYCLES + 1)
  ) u_holder (
      .clk(clk),
      .button(button),
      .held(held)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(REPEAT_CYCLES)
  ) u_rater (
      .clk (clk),
      .run (held),
      .tick(pulse_train)
  );

endmodule
