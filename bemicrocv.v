module bemicrocv

  (input         clk_50,
   input  [ 2:0] user_dipsw_n,
   input  [ 1:0] user_button_n,
   output [ 7:0] user_led_n);

   reg    [ 7:0] cnt;
   reg    [31:0] divide;

   assign        user_led_n = ~cnt;

   always @(posedge clk_50)
     // Note, this style of loops are very efficient as uses a single
     // bit (the sign bit) for control as opposed to, say, divide == 50_000_000
     // which is quite expensive.  However, as we only roll around when we hit -1
     // we have start at N-2 to get exactly N iterations.

     if (divide[31]) begin
	cnt <= cnt + 1'd1;
	divide <= 50_000_00 - 2;
     end
     else
        divide <= divide - 1;

endmodule
