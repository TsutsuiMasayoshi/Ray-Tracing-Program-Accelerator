# CPU-Experiment
<img src="https://user-images.githubusercontent.com/62000880/220345740-7381e092-c809-4ec5-a02d-b590341f5081.png" width=750>


Source codes of 2021-CPU　experiment team7.

This project focuses on creating a processor that can compile a ray tracing program written in Ocaml. Ver2 contains final processor.

## Final Output
<img src="https://user-images.githubusercontent.com/62000880/220346663-7df40f88-6fb5-4740-a595-38fdc1e3be3f.png" width=600>



## ISA

Created based on MIPS ISA.

## Compiler

Compiler is modified version of mincaml(http://esumii.github.io/min-caml/). 
Some optimizations are additionally applied.
The optimizations reduced about 70% instructions compared with naive min-caml.


## Core

The core is pipeline processor which has 5 stages (Fetch, Decode, Exec1, Exec2, MemoryAccess).


## Simulator

The simulator behaves in the same way as the core does in software.

It mainly supports to find bugs in the compiler when core implementation does not catch up.

## FPU
<img src="https://user-images.githubusercontent.com/62000880/220345752-4478fd2c-c459-4ab8-a1ea-355fb3d628f7.png" width=600>
The FPU executes floating point calculations.

It contains fadd, fsub, fmul, fdiv, fsqrt, and some easy instructions (compare, neg).

To improve computation efficiency, Newton's method (an approximation method) is used in fdiv and fsqrt.






