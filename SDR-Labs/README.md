# Digital Communications (ECE_K510) — SDR Laboratory Material

Handouts and **GNU Radio** flowgraphs for the hands-on laboratory exercises of the *Digital
Communications* course. You will use **GNU Radio 3.10** and an **RTL-SDR** dongle (receive only).
Transmission is performed only by the instructor.

> **Language note:** the lab handouts (PDF) are currently written in **Greek**. The flowgraphs, code
> and setup instructions use standard GNU Radio / English technical terms.

## Getting started

1. **Install the tools** (Ubuntu, Windows or macOS): see [`setup/SETUP.md`](setup/SETUP.md) (Ubuntu and
   macOS) and the Lab 0 handout (Windows, using radioconda and Zadig).
2. Open the handout (PDF) of the exercise and follow it together with the `.grc` flowgraphs of the
   same exercise.

## Contents

| Lab | Handout | Flowgraphs |
|---|---|---|
| **Lab 0** — Introduction to SDR & GNU Radio | [`lab0_handout.pdf`](lab0-intro-sdr/student/handout/lab0_handout.pdf) (Greek) | [`grc/`](lab0-intro-sdr/student/grc) |
| Lab 1 — Sampling & PCM | _coming soon_ | |
| Lab 2 — OOK / FSK | _coming soon_ | |
| Lab 3 — PSK / QAM | _coming soon_ | |
| Lab 4 — OFDM / DVB-T | _coming soon_ | |

## Requirements

- GNU Radio 3.10 (with GNU Radio Companion)
- An RTL-SDR dongle with an antenna (SDR flowgraphs only; the simulation flowgraphs run without hardware)
- Ubuntu, Windows or macOS (Intel or Apple Silicon)

## Checking your environment (Ubuntu)

```bash
./setup/check_environment.sh
```

The script checks `gnuradio-companion`, the SDR driver Python module, `rtl_test` and `hackrf_info`.
Without a connected device, `[WARN]` lines for "device not connected" are expected.
