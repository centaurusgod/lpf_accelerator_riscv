import matplotlib.pyplot as plt
import numpy as np
import scipy.io.wavfile as wav

# 1. Load the generated audio files
fs_in, x_audio = wav.read("input_signal.wav")
fs_out, y_audio = wav.read("filtered_lpf_signal.wav")
fs_hw, y_hw_audio = wav.read("single_cycle_risc/single_lpf_accelerator_output.wav")

# Convert back to normalized float [-1.0, 1.0] for FFT processing
x = x_audio / 32767.0
y = y_audio / 32767.0
y_hw = y_hw_audio / 32767.0

# 2. Compute FFT and Frequency Axis
N = len(x)
freqs = np.fft.rfftfreq(N, d=1 / fs_in)

# Compute Magnitude Spectrum (normalized)
X_mag = np.abs(np.fft.rfft(x)) / N
Y_mag = np.abs(np.fft.rfft(y)) / N
Y_hw_mag = np.abs(np.fft.rfft(y_hw)) / N

# 3. Plot Frequency Spectrum (3-panel layout)
fig, axes = plt.subplots(1, 3, figsize=(15, 5))

plots = [
    (axes[0], X_mag, "b", "Input Spectrum (100 Hz + 4000 Hz)"),
    (axes[1], Y_mag, "r", "Python LPF Output"),
    (axes[2], Y_hw_mag, "g", "Verilog Hardware Output"),
]

for ax, mag, color, title in plots:
    ax.plot(freqs, mag, color=color)
    ax.set_title(title)
    ax.set_xlabel("Frequency (Hz)")
    ax.set_ylabel("Magnitude")
    ax.set_xlim(20, 5000)
    
    # Enable log scale for balanced visibility of low & high frequencies
    ax.set_xscale("log") 
    
    # Custom ticks to highlight specific signal frequencies
    ax.set_xticks([100, 500, 1000, 4000])
    ax.get_xaxis().set_major_formatter(plt.ScalarFormatter()) # Keep standard numbers
    ax.grid(True, which="both", ls="--", alpha=0.5)

plt.tight_layout()
plt.savefig("frequency_spectrum.png", dpi=300)
print("Plot successfully saved to frequency_spectrum.png")