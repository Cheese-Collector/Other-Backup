`timescale 1ns / 1ps

module binary_to_bcd (
    input   logic [6:0] bin,    //Binary input, 0-99
    output  logic [3:0] tens,   //Decimal tens digit (BCD)
    output  logic [3:0] ones    //Decimal ones digit (BCD)
);