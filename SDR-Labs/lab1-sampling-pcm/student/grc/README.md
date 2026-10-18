# lab1-sampling-pcm — flowgraphs

**GNU Radio Companion** flowgraphs (GNU Radio 3.10) for Lab 1, "Sampling & Pulse Code Modulation (PCM)".
Open them with `gnuradio-companion` **from this folder** (so that the relative path `media/test_chirp.wav`
resolves) and press **Run**.

| File | Part | What it does | SDR needed? |
|---|---|---|---|
| `fm_receiver.grc` | A | Mono FM receiver: RF spectrum, waterfall, audio | Yes (RTL-SDR) |
| `aliasing_demo.grc` | B | Down-sampling a tone and reconstructing it: see and hear aliasing | No |
| `audio_sampling.grc` | B | Effect of the anti-alias filter on a test chirp (`media/test_chirp.wav`) | No |
| `quantization_pcm.grc` | C | Uniform mid-rise quantizer, quantization staircase, live SQNR meter | No |
| `delta_modulation.grc` | D | Delta modulator/demodulator: slope overload, granular noise, SQNR vs. step size | No |

If `media/test_chirp.wav` is missing, regenerate it with `python3 make_test_wav.py` (requires NumPy).
The handout is [`../handout/lab1_handout.pdf`](../handout/lab1_handout.pdf) (Greek).
