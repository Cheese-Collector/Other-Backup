`timescale 1ns / 1ps

//This is a little bridging module to turn
//button_held_detect into a single pulse output
//using a rising edge detector on the held output


//This remains as a Moore FSM as the 'inputs'
//that the Mealy FSM rising_edge_detector is
//reading are the outputs from the Moore FSM
//button_hold_detect.

//In other words, the output of the module
//are relying on previous state inputs
//due to the delay on button_hold_detect.

module button_hold_pulse #(
    parameter int HOLD_CYCLES = 50_000_000
) (
    input  logic clk,
    input  logic button,
    output logic pulse
);

  logic held;

  button_hold_detect #(
      .HOLD_CYCLES(HOLD_CYCLES)
  ) u_detect (
      .clk(clk),
      .button(button),
      .held(held)
  );

  rising_edge_detector u_detector (
      .clk(clk),
      .sig_in(held),
      .rise(pulse)
  );


endmodule
