module bemicrocv

  (input         clk_50,
   input  [ 2:0] user_dipsw_n,
   input  [ 1:0] user_button_n,
   output [ 7:0] user_led_n,
   output        gpio1,
   input         gpio2);

   reg    [ 7:0] cnt;
   reg    [31:0] divide;

   assign        user_led_n = ~cnt;

   wire          tx_busy;

   wire   [ 7:0] rx_q;
   wire          rx_valid;

   rs232tx rs232tx_inst
      (.clock(clk_50)
      ,.serial_out(gpio1)
      ,.d(rx_q + 1)
      ,.we(rx_valid)
      ,.busy(rs232tx_busy)
      );
   defparam
     rs232tx_inst.frequency = 50_000_000,
     rs232tx_inst.bps       =    115_200;

   rs232rx rs232rx_inst
      (.clock(clk_50)
      ,.serial_in(gpio2)
      ,.q(rx_q)
      ,.valid(rx_valid)
      );
   defparam
     rs232rx_inst.frequency = 50_000_000,
     rs232rx_inst.bps       =    115_200;

   always @(posedge clk_50)
     // Note, this style of loops are very efficient as uses a single
     // bit (the sign bit) for control as opposed to, say, divide == 50_000_000
     // which is quite expensive.  However, as we only roll around when we hit -1
     // we have start at N-2 to get exactly N iterations.

     if (divide[31]) begin
	cnt <= cnt + 1'd1;
	divide <= 50_000_000 - 2;
     end
     else
        divide <= divide - 1;

endmodule
