# BeMicro CV "Hello World" #

The BeMicro CV (originally) shipped with no design files.  We try to
compensate here with a collection of useful examples.  Note, the LED
pin assignment given in the documentation is wrong and corrected in
these designs.

## LEDs and serial communication

The first `led_and_serial` is the typical first Does-It-Work kind
of design which runs a counter on the LEDs.

This also adds a small serial (RS232) input/output engine:

 * RX is on GPIO 1, that is, J1 pin 1

 * TX is on GPIO 2, that is, J1 pin 2

 * Speed set to 115,200 bps

To use connect a USB BUB (or similar), RX to J1-1, TX to J1-2, GND to J1-12, and
ensure that it's configured for 3.3 V signaling.  Attach with a serial
console (say, `screen $TTY 115200`, where `TTY` is
`/dev/tty.usbserial-`something on MacOS and `/dev/ttyUSB0` on
Linux). If everything is working, input should be echoed back, except each
character is incremented (`'a'` -> `'b'`, etc.)

This is a silly design, but much more interesting things can be built
on top of this.


## NIOS II with support for the external DDR3 memory

The second design, `nios_ddr3`, comes curtesy of Guy Lemieux
`<guy.lemieux@gmail.com>` and illustrates how to instantiate the
DDR3 controller and a NIOS II example.

Suggestions and contributions welcome.
