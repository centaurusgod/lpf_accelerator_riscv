import matplotlib.pyplot as plt
import numpy as np
import scipy.io.wavfile as wav
from pathlib import Path

# Provide the input audio files to plot their frequency spectra
DEFAULT_INPUT_AUDIOS = [
    "output_signal.wav"
]


def plot_aggregate_frequency_spectrum(
    input_audios, output_path="frequency_spectrum.png"
):
    """Plot one frequency-spectrum subplot for each provided WAV file."""
    if isinstance(input_audios, (str, Path)):
        input_audios = [input_audios]

    spectra = []
    for input_audio in input_audios:
        try:
            sample_rate, audio = wav.read(input_audio)
            audio = np.asarray(audio)
            if audio.ndim > 1:
                audio = audio.mean(axis=1)
            if audio.size == 0:
                raise ValueError("audio file is empty")

            # Scale integer PCM samples while leaving floating-point WAV data usable.
            if np.issubdtype(audio.dtype, np.integer):
                scale = max(abs(np.iinfo(audio.dtype).min), np.iinfo(audio.dtype).max)
                audio = audio.astype(float) / scale
            else:
                audio = audio.astype(float)

            sample_count = len(audio)
            frequencies = np.fft.rfftfreq(sample_count, d=1 / sample_rate)
            magnitude = np.abs(np.fft.rfft(audio)) / sample_count
            spectra.append((frequencies, magnitude, Path(input_audio).name))
        except (FileNotFoundError, OSError, ValueError) as error:
            raise ValueError(f"Could not process '{input_audio}': {error}") from error

    if not spectra:
        raise ValueError("Provide at least one WAV file")

    figure, axes = plt.subplots(
        1,
        len(spectra),
        figsize=(5 * len(spectra), 5),
        squeeze=False,
    )

    for axis, (frequencies, magnitude, filename) in zip(axes[0], spectra):
        axis.plot(frequencies, magnitude)
        axis.set_title(filename)
        axis.set_xlabel("Frequency (Hz)")
        axis.set_ylabel("Magnitude")
        axis.set_xlim(20, 5000)
        axis.set_xscale("log")
        axis.set_xticks([100, 500, 1000, 4000])
        axis.get_xaxis().set_major_formatter(plt.ScalarFormatter())
        axis.grid(True, which="both", ls="--", alpha=0.5)

    figure.tight_layout()
    figure.savefig(output_path, dpi=300)
    plt.close(figure)
    print(f"Plot successfully saved to {output_path}")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Plot WAV frequency spectra")
    parser.add_argument(
        "input_audios",
        nargs="*",
        default=DEFAULT_INPUT_AUDIOS,
        help="one or more WAV files; defaults to the project demo files",
    )
    parser.add_argument(
        "-o",
        "--output",
        help="output image path; defaults to freq_spec_<first input name>.png",
    )
    arguments = parser.parse_args()
    output_path = arguments.output
    if output_path is None:
        input_name = Path(arguments.input_audios[0]).stem
        output_path = f"freq_spec_{input_name}.png"

    plot_aggregate_frequency_spectrum(arguments.input_audios, output_path)
