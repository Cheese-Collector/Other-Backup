`timescale 1ns / 1ps

//rise is asserted immediately on
//posedge sig_in

//deasserted immediately after negedge sig_in or
//posedge clk captures the high value of sig_in
//whichever comes first

//Rationale
//at 50MHz a button press spans multiple clk cycles.
//without edge detection we get multiple inputs.
//rising_edge_detector converts exactly one press
//to one signal pulse.

//Designed under Mealy FSM to avoid delay.


//---------LOGIC DESCRIPTION----------
//at each rising clk, prev_sig_in checks the value of
//sig_in.

//rise is up if sig_in is up and prev_sig_in is down.
//So when sig_in goes up, comb logic dictates rise immediately
//goes up as long as prev_sig_in is down.
//On the next clock edge ff logic checks the sig_in state
//then assigns it to prev_sig_in. If sig_in was still up
//at this time. Rise immediately goes down.

//If sig_in were to go down before the clock edge then rise
//would follow


module rising_edge_detector (
    input  logic clk,
    input  logic sig_in,
    output logic rise
);


  //previous state
  logic prev_sig_in;
  always_ff @(posedge clk) begin
    prev_sig_in <= sig_in;
  end


  //current output
  always_comb begin
    rise = sig_in && !prev_sig_in;
  end

endmodule
