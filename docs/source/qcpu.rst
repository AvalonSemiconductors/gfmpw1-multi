.. _qcpu:

QCPU MCU
========

This design is a general-purpose 8-bit microcontroller. On top of a RISC CPU core, it also contains the following I/O peripherals:

* 2 8-bit GPIO ports, each line individually programmable
* 1 External interrupt source
* 1 interrupt-capable 16-bit timer
* 1 PWM generator
* 1 programmable frequency generator

The internal 64 bytes of RAM in the multiplexer are used as data memory, and an external QSPI flash is used as program memory.

Registers
=========

QCPU posesses a set of 16 8-bit general-purpose scratchpad registers, designated r0 - r15. r0, however, is the "zero register" and hard-wired to 0. It will always read 0 and writes to it will be discarded.

There are also several special-purpose registers (not including IO device registers, which are accessed in a special way and described later):

======== ============================
Mnemonic Name
======== ============================
PC       14-bit Program Counter
IOADDR   8-bit IO Address
IO       Interface to the I/O devices
======== ============================

Instruction Formats
===================

All instructions are a constant 16-bits wide, to allow for embedding of register addresses and immediate values. The following base encodings exist:

Immediate
---------

The immediate value is loaded into the specified register, unless that register is r0. The opcode for this is instead used for another instruction.

.. wavedrom::

    { "reg": [
        {"name": "Reg", "bits": 4},
        {"name": "0", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "1", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "Immediate (!= 0)", "bits": 8}],
    "config": {"hspace": 700}
    }

Reg/Reg
-------

Specifies one of 15 operations to be performed between both registers. R1 and R2 are the source operands, and R1 is the destination operand. An opcode of all ones is reserved, that code is used for the EXT instruction type.
For some opcodes, the R2 slot is used not as a register index, but a small immediate value ranged 0 - 15.

.. wavedrom::

    { "reg": [
        {"name": "Opcode", "bits": 4},
        {"name": "1", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "1", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "R2/Imm", "bits": 4},
        {"name": "R1", "bits": 4}],
    "config": {"hspace": 700}
    }

The following valid opcodes are available:

====== ===================
Opcode Operation
====== ===================
0      R1 + R2
1      R1 + R2 + C
2      R1 - R2
3      R1 - R2 - ~C
4      R1 & R2
5      R1 | R2
6      R1 ^ R2
7      ~R2
8      R1 + Imm
9      R1 + Imm + C
10     R1 - Imm
11     R1 - Imm - ~C
12     {R2, R1} = PC + 2
13     PC = {R2, R1}
14     Compare R1, R2
====== ===================

Of note are the special operations 12 and 13, which can store and load the program counter value, allowing for subroutine calls. There is also a compare operation, which sets the flags as if R1 - R2 was executed, but does not write the result back into R1. Neither register is modified.

Jump
----

Unconditional jump. The specified immediate address is loaded into PC.

.. wavedrom::

    { "reg": [
        {"name": "dest[13:8]", "bits": 6},
        {"name": "0", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "dest[7:0]", "bits": 8}],
    "config": {"hspace": 700}
    }

Conditional Branch
------------------

The immediate value is sign-extended to 14 bits and added to the PC only if the specified condition is true.

.. wavedrom::

    { "reg": [
        {"name": "relative dest[10:8]", "bits": 3},
        {"name": "Cond", "bits": 2},
        {"name": "1", "bits": 1},
        {"name": "1", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "relative dest[7:0]", "bits": 8}],
    "config": {"hspace": 700}
    }

The following conditions may be checked:

===== ==============
Code  Condition
===== ==============
0     C == 0
1     C == 1
2     Z == 0
3     Z == 1
===== ==============

Load
----

Loads one byte from data memory into a register by adding the value of an index register onto a base address to obtain the address to load from.

.. wavedrom::

    { "reg": [
        {"name": "Base Address", "bits": 6},
        {"name": "1", "bits": 1},
        {"name": "1", "bits": 1},
        {"name": "Index Reg", "bits": 4},
        {"name": "Reg", "bits": 4}],
    "config": {"hspace": 700}
    }

Store
-----

Stores a register value into data memory using the same address calculation as the Load instruction.

.. wavedrom::

    { "reg": [
        {"name": "Base Address", "bits": 6},
        {"name": "0", "bits": 1},
        {"name": "1", "bits": 1},
        {"name": "Index Reg", "bits": 4},
        {"name": "Reg", "bits": 4}],
    "config": {"hspace": 700}
    }

EXT
---

Provides 16 additional operations to the CPU, operating directly on a register or using a small immediate value range 0 - 15.

.. wavedrom::

    { "reg": [
        {"name": "1", "bits": 1},
        {"name": "1", "bits": 1},
        {"name": "1", "bits": 1},
        {"name": "1", "bits": 1},
        {"name": "1", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "1", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "R1 / Imm", "bits": 4},
        {"name": "Opcode", "bits": 4}],
    "config": {"hspace": 700}
    }

The following operations are available:

====== =====================
Opcode Operation
====== =====================
0      R1 = R1 >> 1
1      R1 = R1 >> 1 | C << 7
2      R1 = R1 << 1
3      R1 = R1 << 1 | C
4      R1 = R1 ROR 1
5      R1 = R1 ROL 1
6      IOADDR = R1
7      IO = R1
8      R1 = IO
9      Compare r1, Imm
10     WAIT
11     Return from Interrupt
12     r1, r2 = r1 * R1
13     R1 = Flags
14     Flags = R1
15     {r2,r1} = ROM[{r3,r2}]
====== =====================

Note that "R1" refers to the register index provided with the instruction code, while "r1" and "r2" refer to the literal register indexes 1 and 2.

Immediate Load IOADDR
---------------------

There is one final instruction that results from forming the opcode of Immediate, but with a target register of r0. This opcode will instead load the immediate value into the IOADDR register.

.. wavedrom::

    { "reg": [
        {"name": "0", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "1", "bits": 1},
        {"name": "0", "bits": 1},
        {"name": "Immediate", "bits": 8}],
    "config": {"hspace": 700}
    }
