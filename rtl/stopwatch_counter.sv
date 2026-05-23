`timescale 1ns / 1ps
//Meets requeirement as the rate generator outputs
//at end of cycle
//
//Counter for stopwatch that counts in centisecond
//precision.
//Larger application of the cascade_counter with
//a delay and larger input period.

//clk is a syncing clk and larger timing system
//rst resets the counter
//enable activates the system

//if enable and not rst, then
//stopwatch_counter runs with a 1cs
//delay
//
//if not enable and not rst then hold values
//
//if rst reset values

module stopwatch_counter #(
    parameter int CYCLES_PER_SECOND = 50_000_000
) (
    input logic clk,
    input logic rst,  //Priority over enable
    input logic enable,
    output logic [6:0] minutes,  //Up to 99 (no hours)
    output logic [5:0] seconds,  //To 59 (rollover to minutes)
    output logic [6:0] centiseconds  //100th of a second
);

  logic enable_1cs;
  logic pulse_1cs;

  assign enable_1cs = enable && pulse_1cs;

  cascade_counter #(
      .N2(100),  //0-99
      .N1(60),   //0-59
      .N0(100),  //0-99
      .W2(7),    //from output size
      .W1(6),
      .W0(7)
  ) u_kirks (  //Like the soft drink. Get it?
      .clk(clk),
      .rst(rst),
      .enable(enable_1cs),
      .count2(minutes),
      .count1(seconds),
      .count0(centiseconds)
  );


  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND / 100)
      // 1/100th of a second
  ) u_RRG (
      .clk (clk),
      .run (enable && !rst),  //this is because without
      //the additional not operator, the rate gen would
      //tick away in the background.
      //Hence if we were to release rst while enable
      //was engaged, then the first tick could come early
      .tick(pulse_1cs)
  );

endmodule
