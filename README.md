# gfmpw1-multi

Multi-project submission to GFMPW-1. Active design (selected over wishbone) gets access to the user IO pins.
Currently contains the following projects.

## LED Blinker

Blinks two output at varying speed. Exists only to help with the bring-up.

## QCPU

Custom 8-bit microcontroller architecture. Reads instructions from QSPI flash and uses the on-die RAM, freeing up the remaining pins for the following I/O:

* Two 8-bit GPIO Ports
* One UART
* One SPI Port
* One PWM output
* One programmable frequency generator
* Interrupt pin

Also posesses one 16-bit timer on-chip which can also generate interrupts.

The purpose of this design is it to provide a minimal yet powerful CPU that takes up little die space.

## SN76489

Design contributed by (rejunity)[https://github.com/rejunity]. More info at the (original repo)[https://github.com/rejunity/tt05-psg-sn76489].

## SID

C64 SID replica, times two. Implements the same functionality as two Sound Interface Device chips.

## Multiplexer

Simplest setup to allow the multiple designs to share the chip IO. Has a connection to the wishbone bus, so a design can be selected and other settings configured. Also contains 64 bytes of RAM usable by designs, and pre-programmable over wishbone.
