//self explanatory
//A pwm signal akin to pw on a synth
//two parameters controlling period
//(inverse of frequency that you'd find on a synth)
//and width. Similar to ratio/width on a synth

//clock to syncing purposes
//rst for restartign. similar to KORG mono/poly
//sync function

//pwm_out as output


//be sure to start and restart at pos clk edge

`timescale 1ns / 1ps

module pwm_generator #(
    // Number of clock cycles in one PWM period
    parameter int PERIOD_CYCLES = 50_000_000,

    // Number of clock cycles output is high
    //ie width of pulse
    parameter int DUTY_CYCLES = 25_000_000
) (
    input logic clk,
    input logic rst,  //rst at next clock edge. delayed asynchro
    output logic pwm_out
);
  // Width to store PERIOD_CYCLES
  localparam int Width = $clog2(PERIOD_CYCLES);

  // Count value of counter stored as counted
  logic [Width-1:0] counted;



  assign pwm_out = ((Width + 1)'(counted) < (Width + 1)'(DUTY_CYCLES));



  mod_n_counter #(
      .N(PERIOD_CYCLES),
      .WIDTH(Width)
  ) u_counter (
      .clk(clk),
      .rst(rst),
      .enable(1'b1),
      .count(counted)
  );

endmodule
