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

   wire          tx_tready;
   wire   [ 7:0] tx_tdata;
   wire          tx_tvalid;

   wire   [ 7:0] rx_tdata;
   wire          rx_tvalid;
   wire          rx_tready;

   rs232tx tx
      (.clock		(clk_50)
      ,.serial_out	(gpio1)
      ,.tdata		(tx_tdata)
      ,.tvalid		(tx_tvalid)
      ,.tready		(tx_tready)
      );
   defparam
     tx.frequency	= 50_000_000,
     tx.bps      	=    115_200;

   rs232rx rx
      (.clock		(clk_50)
      ,.serial_in	(gpio2)
      ,.tdata		(rx_tdata)
      ,.tvalid		(rx_tvalid)
      ,.tready		(rx_tready)
      );
   defparam
     rx.frequency	= 50_000_000,
     rx.bps      	=    115_200;


   assign tx_tdata 	= rx_tdata + 1;
   assign rx_tvalid	= tx_tvalid;

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
