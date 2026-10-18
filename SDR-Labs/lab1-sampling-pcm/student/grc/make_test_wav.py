#!/usr/bin/env python3
"""Synthesize a self-contained test WAV for the audio-sampling / aliasing lab.

The lab flowgraph (audio_sampling.grc) reads media/test_chirp.wav. This script
generates that file so the lab does not depend on any external audio.

Two signal types are available:

  * chirp     (default) -- a slow logarithmic-ish sweep from f0 to f1. When the
                signal is decimated *without* an anti-alias filter, every part of
                the sweep above the new Nyquist folds back down: students hear the
                rising tone bounce back and see it in the spectrum. This is the
                clearest way to *hear* aliasing.

  * multitone -- a fixed set of tones (speech band + a few high tones). With the
                anti-alias filter off, the high tones alias into the speech band
                as spurious low-frequency components.

Only the Python standard library plus NumPy are required (no SciPy).

Examples
--------
    python3 make_test_wav.py                 # -> media/test_chirp.wav (chirp)
    python3 make_test_wav.py --kind multitone --out media/test_multitone.wav
    python3 make_test_wav.py --duration 10 --f1 22000
"""
import argparse
import os
import wave

import numpy as np

SAMP_RATE = 48000  # the lab is fixed at 48 kHz mono


def _fade(x, samp_rate, ms=5.0):
    """Apply a short raised-cosine fade in/out to avoid loop-boundary clicks."""
    n = int(samp_rate * ms / 1000.0)
    if n > 0 and 2 * n < len(x):
        ramp = 0.5 * (1.0 - np.cos(np.pi * np.arange(n) / n))
        x[:n] *= ramp
        x[-n:] *= ramp[::-1]
    return x


def make_chirp(duration, f0, f1, amp):
    t = np.arange(int(duration * SAMP_RATE)) / SAMP_RATE
    # Linear frequency sweep f0 -> f1; instantaneous phase is the integral of f(t).
    k = (f1 - f0) / duration
    phase = 2.0 * np.pi * (f0 * t + 0.5 * k * t * t)
    return amp * np.sin(phase)


def make_multitone(duration, amp):
    t = np.arange(int(duration * SAMP_RATE)) / SAMP_RATE
    # A few speech-band tones plus deliberately high tones that will alias.
    tones = [300, 600, 1200, 2400, 5000, 9000, 15000, 20000]
    x = np.zeros_like(t)
    for f in tones:
        x += np.sin(2.0 * np.pi * f * t)
    return amp * x / len(tones)


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--kind", choices=["chirp", "multitone"], default="chirp")
    p.add_argument("--duration", type=float, default=8.0, help="seconds")
    p.add_argument("--f0", type=float, default=300.0, help="chirp start freq (Hz)")
    p.add_argument("--f1", type=float, default=20000.0, help="chirp end freq (Hz)")
    p.add_argument("--amp", type=float, default=0.6, help="peak amplitude (0..1)")
    p.add_argument("--out", default=None, help="output .wav path")
    args = p.parse_args()

    if args.kind == "chirp":
        x = make_chirp(args.duration, args.f0, args.f1, args.amp)
        default_name = "test_chirp.wav"
    else:
        x = make_multitone(args.duration, args.amp)
        default_name = "test_multitone.wav"

    x = _fade(x, SAMP_RATE)
    # Clip for safety, then convert to 16-bit PCM.
    x = np.clip(x, -1.0, 1.0)
    pcm = (x * 32767.0).astype("<i2")

    out = args.out
    if out is None:
        here = os.path.dirname(os.path.abspath(__file__))
        out = os.path.join(here, "media", default_name)
    os.makedirs(os.path.dirname(out), exist_ok=True)

    with wave.open(out, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)          # 16-bit
        w.setframerate(SAMP_RATE)
        w.writeframes(pcm.tobytes())

    print(f"Wrote {out}: {args.kind}, {args.duration:g}s, {SAMP_RATE} Hz mono, "
          f"{len(pcm)} samples")


if __name__ == "__main__":
    main()
