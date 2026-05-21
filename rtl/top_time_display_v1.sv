//Top level time display module
//time initialised to 00:00:00
//tick rate controlled by switch


`timescale 1ns / 1ps

module top_time_display_v1 #(
    parameter int CYCLES_PER_SECOND = 50_000_000
) (
    input logic CLOCK_50,
    input logic [1:0] SW,
    output logic [6:0] HEX5,
    output logic [6:0] HEX4,
    output logic [6:0] HEX3,
    output logic [6:0] HEX2,
    output logic [6:0] HEX1,
    output logic [6:0] HEX0
);

  logic ticker;

  //variable clock logic registers
  logic ticker_1Hz;
  logic ticker_25Hz;
  logic ticker_1kHz;


  //hms logic registers
  logic [4:0] hours;
  logic [5:0] minutes;
  logic [5:0] seconds;

  //Binary bcd logic registers
  logic [3:0] hr_ten;
  logic [3:0] hr_one;

  logic [3:0] min_ten;
  logic [3:0] min_one;

  logic [3:0] sec_ten;
  logic [3:0] sec_one;

  always_comb begin
    unique case (SW)
      2'b00: ticker = ticker_1Hz;
      2'b01: ticker = ticker_25Hz;
      2'b10: ticker = ticker_1kHz;
      2'b11: ticker = 1'b1;  //due to restartable_rate_generator edge case
    endcase
  end

  hms_counter u_time_hms (
      //ports
      .clk(CLOCK_50),
      .enable(ticker),
      .hours(hours),
      .minutes(minutes),
      .seconds(seconds)
  );

  restartable_rate_generator #(
      //params
      .CYCLE_COUNT(CYCLES_PER_SECOND)
  ) u_1Hz (
      //ports
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(ticker_1Hz)
  );

  restartable_rate_generator #(
      //params
      .CYCLE_COUNT(CYCLES_PER_SECOND / 25)
  ) u_25Hz (
      //ports
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(ticker_25Hz)
  );

  restartable_rate_generator #(
      //params
      .CYCLE_COUNT(CYCLES_PER_SECOND / 1000)
  ) u_1kHz (
      //ports
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(ticker_1kHz)
  );

  binary_to_bcd u_hour (
      //ports
      .bin ({2'b0, hours}),
      .tens(hr_ten),
      .ones(hr_one)
  );

  binary_to_bcd u_min (
      //ports
      .bin ({1'b0, minutes}),
      .tens(min_ten),
      .ones(min_one)
  );

  binary_to_bcd u_sec (
      //ports
      .bin ({1'b0, seconds}),
      .tens(sec_ten),
      .ones(sec_one)
  );

  seven_segment u_H_ten (
      //ports
      .digit(hr_ten),
      .blank(1'b0),
      .segments(HEX5)
  );

  seven_segment u_H_one (
      //ports
      .digit(hr_one),
      .blank(1'b0),
      .segments(HEX4)
  );

  seven_segment u_M_ten (
      //ports
      .digit(min_ten),
      .blank(1'b0),
      .segments(HEX3)
  );

  seven_segment u_M_one (
      //ports
      .digit(min_one),
      .blank(1'b0),
      .segments(HEX2)
  );

  seven_segment u_S_ten (
      //ports
      .digit(sec_ten),
      .blank(1'b0),
      .segments(HEX1)
  );

  seven_segment u_S_one (
      //ports
      .digit(sec_one),
      .blank(1'b0),
      .segments(HEX0)
  );
endmodule
