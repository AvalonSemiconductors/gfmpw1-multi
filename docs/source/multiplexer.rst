.. _multiplexer:

Multiplexer
===========

All project design I/O is routed through the Project Multiplexer. It makes sure that only the selected design has its outputs routed to the I/O pins.
The Multiplexer can be talked to by the management controller over its wishbone interface. This is how the active project selection is changed, as well as other properties of the Multiplexer configured.

I/O Routing and design selection
--------------------------------

Every design has access to up to 33 bi-directional I/O lines, mapped to ``mprj_io[37:5]``. To accomplish this, the pad io_in, io_out and io_oeb are routed to the designs as follows:

* All designs can directly read from ``io_in[37:5]``
* Two sets of wires, ``io_out[32:0]`` and ``io_oeb[32:0]``, leave each design and are routed into the Multiplexer
* As the name implies, the Multiplexer only passes one set of io outs and output enables to the chip pads

Additionally, ``mprj_io[0]`` is used as a dedicated reset line for the current design. The reset is a separate input into each design, thus allowing the Multiplexer to hold all non-selected designs in reset.

Custom Settings Register
------------------------

A 32-bit wide register named simply "custom_settings" is also accessible via wishbone. Its contents are readable by all designs on-die, and allow additional settings be set on the selected design without the need to use IO pins for this purpose.

On-die RAM
----------

The multiplexer also contains 64 bytes of on-die RAM, accessible by the selected design. If design 0 is selected, the RAM contents can be accessed and modified by the management controller, allowing memory contents to be pre-programmed.

Wishbone address map
--------------------

========== =================== ==========================
Address    Designation         Meaning
========== =================== ==========================
0x30800000 reg_mprj_proj_sel   Project selection register
0x30400000 reg_mprj_counter    Timer for debugging
0x30200000 reg_mprj_settings   Custom Settings Register
0x30100000 reg_mprj_sram       64-byte RAM start
0x301000FC reg_mprj_sram + 252 64-byte RAM end
========== =================== ==========================

**Note:** for implementation convenience, the SRAM is addressed by the wishbone bus as 64 32-bit words of which only the first 8 bits are used.

Design address map
------------------

======= =================================
Address Name
======= =================================
0       None - All outputs high-impedance
1       LED Blinker
2       SID
3       SN76489
4       QCPU Microcontroller
5       MC14500 bit-serial processor
6       AY8913
7       Hellorld!
8       TBB1143
9       AS-11
10      Tholin RISCV (RV32IM)
11      Diceroll
12      UE14500 / UE-1
======= =================================

The default state after power-up is design address == 0, with all design IO in high-impedance. This is to not potentially damage any project-specific hardware connected to the chip pins through wrong signals from a different design, no matter how brief.

Project Selection Register
--------------------------

The project selection register contains some additional options besides project selection. It is layed out as such:

.. wavedrom::

    { "reg": [
        {"name": "OE", "bits": 1},
        {"name": "RST", "bits": 1},
        {"name": "SELECT", "bits": 4},
        {"type": 1, "bits": 26}],
    "config": {"hspace": 700}
    }

OE is the "Override Enable". When set, some internal signals can be overriden through the wishbone bus. Currently, this only consists of "RST" which, when set together with "OE", forces the selected design into reset, no matter the state of ``mprj_io[0]``.
