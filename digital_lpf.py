# Second Order Butterworth Low Pass Filter
# Cutoff frequency: 100 Hz
# Audio Sample Rate: 10000Hz
# Difference formula: y[n] = b0*x[n] + b1*x[n-1] + b2*x[n-2] - a1*y[n-1] - a2*y[n-2]
import numpy as np
import scipy.io.wavfile as wav


# Pre-computed coefficients for above filter specifications
b0=0.00094469
b1=0.00188938
b2=0.00094469

a1=-1.911197
a2=0.914976 #0.894948

# Generate a test signal (100Hz & 4000Hz sine wave) of 3 seconds
# Sampling freq = nyquist freq = 2*4000 = 8000Hz, (i guess due to exact point, we lost our signal so taking 10000hz as sampling rate)
fs = 10000
freq_low = 100
freq_high = 4000
duration=3
t = np.linspace(0, duration, int(fs * duration), endpoint=False)

# Test input signal, combine both signal Asin(2 pi f t)
x= 0.5 * np.sin(2 * np.pi * freq_low * t) + 0.5 * np.sin(2 * np.pi * freq_high * t)

# Save the audio to hear
x_scaled = np.clip(x * 32767, -32768, 32767)
x_audio_int16 = x_scaled.astype(np.int16)
# x_audio_int16 = (x * 32767).astype(np.int16)
wav.write("input_signal.wav", fs, x_audio_int16)


# Initialize x[n-1], x[n-2], y[n-1], y[n-2] to 0
x_1=0.0
x_2=0.0
y_1=0.0
y_2=0.0
y = np.zeros(len(x))

# Perform filtering action
for n in range(len(x)):
    xn = x[n]
    yn = b0 * xn + b1 * x_1 + b2 * x_2 - a1 * y_1 - a2 * y_2

    x_2 = x_1
    x_1 = xn

    y_2 = y_1
    y_1 = yn

    y[n]=yn

# Save the y signal
y_audio_int16 = (y*32767).astype(np.int16)
wav.write("filtered_lpf_signal.wav", fs, y_audio_int16)
