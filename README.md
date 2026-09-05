# Index
1. Brief & Working
2. Images and Outputs (to provide summary beforehand)
    - Image output from DigitalJS
3. Perfomance Comparison
    - Instruction Cycle : Accelerated Vs Non-Accelerated Simple Graph
    - Instruction Comparison
3. Constructin & Working 
    - Focus brief on riscv construction providing link to reference
4. Derivation Of 2nd Order Butterworth Low pass filter
    - Starting equation, 
    - Filter Design Problem
    - Bilinear Transformation 7 Z-transform
    - Difference equation
    - Direct Form-I
5. Consturciton of Filter in Verilog
    - Floating Point vs Fixed Point 
    - Mention riscv32I so to work in existing work instead of implementing floating units
    - perofmring conversions etc
    - Show the loss in precision 58.xx vs 56 as output
5. References



# Single Cycle RISC-V Processor (32bit) Integer Subset
- RiscV32 (I) Implementation with Butterworth Second Order Low Pass Filter as Hardware Accelerator being interfaced on Memory Mapped 0x00000000H.
- Processes audio via dedicated accelerator (consisting of parallel adders and multipliers and delay registers) instead of sequential eexcution by processor

![Single Cycle RISC-V Processor](single_cycle_risc/single_cycle_processor.png)


Note: Few unnecessary wires/regs are being used for output, because simulating on digitaljs
it was harder to see what was the value in different regs eg, alu_output, Program Counter etc.


# References
# RISCV 32 vard
https://moodle.insa-lyon.fr/pluginfile.php/132782/course/section/74012/riscv-card.pdf

# fixed point vs floating point
https://www.geeksforgeeks.org/computer-organization-architecture/fixed-point-representation/



# Calculate the filter coeffiecients (trn into fixed point Q2.14 1 bit sign, 1 bit integer, 14 bit fraction)
- our filter ranges (-1, +1.99)
coeff * 2^14 scale
b0=0.00094469, 15.4778, Round 15, BIN: 0000 0000 0000 1111
b1=0.00188938, 30.9556, Round: 31, BIN: 0000 0000 0001 1111
b2=0.00094469, 15.4778, Round: 15, BIN: 0000 0000 0000 1111

a1=-1.911197, -31313.0516, Round:31313,  BIN(2's complement): 1000 0101 1010 1111
a2=0.914976, 14990.9667, Round: 14991, BIN: 0011 1010 1000 1111


# Loading files into memory in verilog
- https://projectf.io/posts/initialize-memory-in-verilog/#:~:text=Verilog%20allows%20you%20to%20initialize%20memory%20from,file%20containing%20binary%20values%20separated%20by%20whitespace.