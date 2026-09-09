# Second Order Butterworth Low Pass Filter
# Cutoff frequency: 100 Hz
# Audio Sample Rate: 10000Hz
# Difference formula: y[n] = b0*x[n] + b1*x[n-1] + b2*x[n-2] - a1*y[n-1] - a2*y[n-2]
import numpy as np
import scipy.io.wavfile as wav


def save_filtered_audio(input_filename, output_filename):
    fs, x = wav.read(input_filename)
    # Normalize to [-1, 1]
    x = x / 32767.0

    # Pre-computed coefficients for above filter specifications
    # Note: Replace the coefficients by recalculating them if you change the filter specifications
    b0 = 0.00094469
    b1 = 0.00188938
    b2 = 0.00094469

    a1 = -1.911197
    a2 = 0.914976  # 0.894948

    # Initialize x[n-1], x[n-2], y[n-1], y[n-2] to 0
    x_1 = 0.0
    x_2 = 0.0
    y_1 = 0.0
    y_2 = 0.0
    y = np.zeros(len(x))

    # Perform filtering action
    for n in range(len(x)):
        xn = x[n]
        yn = b0 * xn + b1 * x_1 + b2 * x_2 - a1 * y_1 - a2 * y_2

        x_2 = x_1
        x_1 = xn

        y_2 = y_1
        y_1 = yn

        y[n] = yn

    # Save the y signal
    y_audio_int16 = (y * 32767).astype(np.int16)

    if output_filename is None:
        output_filename = input_filename.replace(".wav", "_lpf.wav")

    wav.write(output_filename, fs, y_audio_int16)
