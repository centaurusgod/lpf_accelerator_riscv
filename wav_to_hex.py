import scipy.io.wavfile as wav
import numpy as np

# Load the generated WAV file
sample_rate, data = wav.read("input_signal.wav")

# If multi-channel/stereo, extract the first channel
if len(data.shape) > 1:
    data = data[:, 0]

# Write samples to text file in hex format
with open("audio_in.hex", "w") as f:
    for sample in data:
        # Mask with 0xFFFF to handle negative 16-bit integers in two's complement
        hex_val = f"{(int(sample) & 0xFFFF):04X}"
        f.write(f"{hex_val}\n")

print(f"Successfully exported {len(data)} samples to 'audio_in.hex'.")
