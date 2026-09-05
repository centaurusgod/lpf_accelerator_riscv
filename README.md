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
- Low Pass Filter Diagram
![Low Pass Filter](media/low_pass_filter.png)
- RISCV32 Single Cycle Processor Diagram
![Single Cycle RISC-V Processor](media/riscv_with_lpf_accelerator.png)

- LPF In Action
![LPF In ACTION](media/low_pass_filter_working.mp4)


Note: Few unnecessary wires/regs are being used for output, because simulating on digitaljs
it was harder to see what was the value in different regs eg, alu_output, Program Counter etc.

# Input & Output Demonstration
- 16 bit PCM audio signal, 3 seconds signal Audio In .wav (3 seconds waveform generated from python scipy library consitionf of superimposed 100Hz + 4000 Hz sine signal)
<audio src="audios/input_signal.wav" controls></audio>
- Audio Out (python library that used the difference equation we calculated to perform filtering action and)
<audio src="audios/filtered_lpf_signal.wav" controls></audio>
- Outut signal runnign the test bench single_cycle_risc/test_bench/tb_single_cycle_processor.v
<audio src="audios/single_lpf_accelerator_output.wav" controls></audio>




# Designing Butterworth Low pass Filter ( From Mathematics To Verilog)
The complete derivation for a 2nd-order Butterworth low-pass filter operating at a 10,000 Hz sampling rate with a 100 Hz cutoff frequency requires transitioning from continuous analog poles to discrete digital coefficients.

### 1. Analog Prototype and Pole Selection

A Butterworth filter is defined by having a maximally flat magnitude response in the passband. The magnitude squared response for a normalized analog Butterworth filter ($\Omega_c = 1\text{ rad/s}$) is:


$$\vert{}H(j\Omega)\vert{}^2 = \frac{1}{1 + \Omega^{2N}}$$

To derive the continuous-time transfer function $H(s)$, we evaluate the response along the imaginary axis where $\Omega^2 = -s^2$. Setting the filter order to $N=2$ yields the general s-domain relationship:


$$H(s) \cdot H(-s) = \frac{1}{1 + (-s^2)^2} = \frac{1}{1 + s^4}$$

Setting the denominator to zero ($1 + s^4 = 0$) results in four complex poles:


$$s_k = e^{j\frac{\pi + 2k\pi}{4}} \quad \text{for } k = 0, 1, 2, 3$$

* $s_0 = \frac{1}{\sqrt{2}} + j\frac{1}{\sqrt{2}}$
* $s_1 = -\frac{1}{\sqrt{2}} + j\frac{1}{\sqrt{2}}$
* $s_2 = -\frac{1}{\sqrt{2}} - j\frac{1}{\sqrt{2}}$
* $s_3 = \frac{1}{\sqrt{2}} - j\frac{1}{\sqrt{2}}$

To ensure system stability, all poles must lie in the left-half of the s-plane. Taking the stable poles $s_1$ and $s_2$, the normalized analog transfer function $H_n(s)$ is constructed:


$$H_n(s) = \frac{1}{(s - s_1)(s - s_2)} = \frac{1}{s^2 + \sqrt{2}s + 1}$$

### 2. Frequency Pre-Warping

The system specifications define a digital cutoff frequency $f_c = 100\text{ Hz}$ and a sampling frequency $f_s = 10,000\text{ Hz}$.
The normalized digital cutoff frequency ($\omega_c$) is:


$$\omega_c = 2\pi \frac{f_c}{f_s} = 2\pi \frac{100}{10000} = 0.02\pi \text{ rad/sample}$$

To prevent frequency distortion during digitization, the target frequency is pre-warped into the continuous domain:


$$\Omega_p = \frac{2}{T} \tan\left(\frac{\omega_c}{2}\right)$$


We can simplify algebraic substitution by defining the constant $K = \cot\left(\frac{\omega_c}{2}\right) = \frac{1}{\tan(0.01\pi)} \approx 31.820516$.

### 3. Bilinear Transformation

The Bilinear Transformation maps the analog s-plane to the digital z-plane using the substitution $s = \frac{2}{T}\left(\frac{1 - z^{-1}}{1 + z^{-1}}\right)$. By replacing the pre-warped terms with our constant $K$, the substitution into $H_n(s)$ becomes:


$$H(z) = \frac{1}{\left[ K \left( \frac{1 - z^{-1}}{1 + z^{-1}} \right) \right]^2 + \sqrt{2} K \left( \frac{1 - z^{-1}}{1 + z^{-1}} \right) + 1}$$

Multiplying the numerator and denominator by $(1 + z^{-1})^2$ and expanding the binomial terms yields:


$$H(z) = \frac{1 + 2z^{-1} + z^{-2}}{(K^2 + \sqrt{2}K + 1) + 2(1 - K^2)z^{-1} + (K^2 - \sqrt{2}K + 1)z^{-2}}$$

### 4. Transfer Function & Difference Equation

To reach standard biquad form, divide the entire expression by the constant denominator term $D_0 = (K^2 + \sqrt{2}K + 1)$ to set $a_0 = 1$.
This produces the final digital transfer function:


$$H(z) = \frac{Y(z)}{X(z)} = \frac{b_0 + b_1 z^{-1} + b_2 z^{-2}}{1 + a_1 z^{-1} + a_2 z^{-2}}$$

Applying the Inverse Z-Transform directly to this transfer function yields the time-domain difference equation for hardware execution:


$$Y(z) [1 + a_1 z^{-1} + a_2 z^{-2}] = X(z) [b_0 + b_1 z^{-1} + b_2 z^{-2}]$$

$$y[n] + a_1 y[n-1] + a_2 y[n-2] = b_0 x[n] + b_1 x[n-1] + b_2 x[n-2]$$

$$y[n] = b_0 x[n] + b_1 x[n-1] + b_2 x[n-2] - a_1 y[n-1] - a_2 y[n-2]$$

**Coefficient Calculation Validation**
Calculating the numeric constants based on $K = 31.820516$:

* $K^2 = 1012.5452$
* $\sqrt{2}K = 45.0010$
* $D_0 = K^2 + \sqrt{2}K + 1 = 1058.5462$
* $D_1 = 2(1 - K^2) = -2023.0904$
* $D_2 = K^2 - \sqrt{2}K + 1 = 968.5442$

Dividing by $D_0$ gives the final filter coefficients:

* $b_0 = \frac{1}{1058.5462} = 0.00094469$
* $b_1 = \frac{2}{1058.5462} = 0.00188938$
* $b_2 = \frac{1}{1058.5462} = 0.00094469$
* $a_1 = \frac{-2023.0904}{1058.5462} = -1.911197$
* $a_2 = \frac{968.5442}{1058.5462} = 0.914976$


- As these are floating point values but our processor supports only integer values, How will we do it?

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