module bemicrocv

  (input        clk_50,
   input  [2:0] user_dipsw_n,
   input  [1:0] user_button_n,
   output [7:0] user_led_n);

   reg [7:0]    cnt;
   reg [31:0]   divide;

   assign       user_led_n = ~cnt;
   // {user_button_n, user_dipsw_n, ~cnt};

   always @(posedge clk_50)
     if (divide[31]) begin
	cnt <= cnt + 1 'd 1;
	divide <= 50_000_00-2;
     end
     else
       divide <= divide - 1;

endmodule
