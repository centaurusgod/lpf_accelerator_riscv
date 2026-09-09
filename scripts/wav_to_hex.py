import scipy.io.wavfile as wav


# Converts the input wav file to hex file
# The hex file will be used in testbench to use as the audio signal in Verilog
def convert_wav_audio_to_hex(wav_filename, hex_filename):
    try:
        sample_rate, data = wav.read(wav_filename)

        # If multi-channel/stereo, extract the first channel
        if len(data.shape) > 1:
            data = data[:, 0]

        # Write samples to text file in hex format
        with open(hex_filename, "w") as f:
            for sample in data:
                # Mask with 0xFFFF to handle negative 16-bit integers in two's complement
                hex_val = f"{(int(sample) & 0xFFFF):04X}"
                f.write(f"{hex_val}\n")

        print(f"Successfully exported {len(data)} samples to '{hex_filename}'.")

    except Exception as e:
        print(f"Error converting WAV to hex: {e}")


# Change the input and output filenames as needed
convert_wav_audio_to_hex("input_signal.wav", "audio_in.hex")
