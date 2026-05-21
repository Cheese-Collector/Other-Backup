//Converts Binary to BCD (Binary-coded decimal)
//This allows us to store a number by its decimal
//digits. One nibble per digit.

//This method uses a double-dabble approach.
//It is cheaper and faster than a typical division.

`timescale 1ns / 1ps

module binary_to_bcd (
    input  logic [6:0] bin,   //Binary input, 0-99
    output logic [3:0] tens,  //Decimal tens digit (BCD)
    output logic [3:0] ones   //Decimal ones digit (BCD)
);
  logic [6:0] combin;
  initial begin
    tens   = 4'b0000;
    ones   = 4'b0000;
    combin = bin;
  end

  always @(bin) begin
    tens   = 4'b0000;
    ones   = 4'b0000;
    combin = bin;
    repeat (7) begin
      if (tens >= 5) tens = tens + 4'b0011;
      if (ones >= 5) ones = ones + 4'b0011;
      tens   = (tens << 1) + {3'b000, ones[3]};
      ones   = (ones << 1) + {3'b000, combin[6]};
      combin = (combin << 1);
    end
  end

endmodule
