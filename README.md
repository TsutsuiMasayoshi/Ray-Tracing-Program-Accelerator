# CPU-Experiment

2021-CPUexperiment team7

This project focuses on creating a processor that can compile a ray tracing program written in Ocaml. Ver2 contains final processor.


#ISA

Created based on MIPS ISA.

#Compiler

Compiler is modified version of mincaml(http://esumii.github.io/min-caml/). 
Some optimizations are additionally applied.
The optimizations reduced about 70% instructions compared with naive min-caml.


#Core

The core is pipeline processor which has 5 stages (Fetch, Decode, Exec1, Exec2, MemoryAccess).


#Simulator

The simulator behaves in the same way as the core does in software.

It mainly supports to find bugs in the compiler when core implementation does not catch up.

#FPU

The FPU executes floating point calculations.

It contains fadd, fsub, fmul, fdiv, fsqrt, and some easy instructions (compare, neg).

To improve computation efficiency, Newton's method (an approximation method) is used in fdiv and fsqrt.






