# lab2-ook-fsk — flowgraphs

**GNU Radio Companion** flowgraphs (GNU Radio 3.10) for Lab 2, "Digital Modulation OOK & FSK".
Open them with `gnuradio-companion` and press **Run**. The instructor transmits on the 433 MHz ISM
band (OOK at **433.92 MHz**, FSK at **433.97 MHz**); you only receive.

| File | Part | What it does | SDR needed? |
|---|---|---|---|
| `ook_rx.grc` | A | OOK / Morse receiver: envelope detector, Schmitt threshold, CW audio tone | Yes (RTL-SDR) |
| `fsk_rx.grc` | B | FSK receiver: quadrature demod, symbol sync (M&M), live ASCII decode, eye diagram | Yes (RTL-SDR) |

Set **"Ρυθμός Morse / bit (baud)"** (and, for FSK, **"Απόκλιση Δf"**) to match the values announced
by the instructor, otherwise nothing will decode.

For the introductory experiment (Section 0, "signal hunting" on the ISM band) you reuse
`fm_receiver.grc` from **Lab 1**, after widening its tuning range to 433–434.5 MHz as described in
the handout.

The handout is [`../handout/lab2_handout.pdf`](../handout/lab2_handout.pdf) (Greek).
