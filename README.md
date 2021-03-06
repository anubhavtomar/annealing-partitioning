# annealing-partitioning

Simulated an approach to hardware/software partitioning for a Fast Fourier Transform (FFT) algorithm. Through configuration-level analysis and cost-performance trade-offs we can study the design process and large design spaces can be explored. Using the simulated annealing partitioning technique we separate the software digital design into hardware and software nodes. Nodes implemented in hardware run faster providing better efficiency and reduce load on the software block.

We also compare experimentally, the results for the straightforward implementation of the selected application and the implementation based on hardware/software partitioning.

Language : C++, Perl

#### Execution steps for Mac OS
```
perl asmblr.pl fft-asm.txt _fpmul
```
Copy ```fft-asm.txt-process-graph.txt``` file from ```PerScript``` to main directory.
```
g++ main.cpp
./a.out
```
