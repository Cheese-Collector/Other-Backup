`timescale 1ns / 1ps
//simple flipflop
//synchronours set and clear where clear takes
//priority

//Will be used to check if edit mode is on or off



module arming_latch (
    input  logic clk,
    input  logic arm,
    input  logic disarm,
    output logic armed
);

  initial armed = '0;

  always_ff @(posedge clk) begin
    if (disarm) armed <= '0;
    else if (arm) armed <= '1;
  end

endmodule
