# BeMicro CV "Hello World" #

The BeMicro CV (originally) shipped with no design files.  This is the
typical first Does-It-Work kind of design which runs a counter on the
LEDs. Note, the LED pin assignment given in the documentation is wrong
and corrected in this design.

This also adds a small serial (RS232) input/output engine:

 * TX is on GPIO 1, that is J1 pin 1

 * RX is on GPIO 2, that is J1 pin 2

 * Speed set to 115200 bps

To use connect a USB BUB (or similar), RX to J1-1, TX to J1-2 and
ensure that it's configured for 3.3 V signaling.

Suggestions and contributions welcome.

Coming soon: use of external DDR SDRAM and a RISC-V processor
