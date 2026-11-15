# lab3-psk-qam — flowgraphs

**GNU Radio Companion** flowgraphs (GNU Radio 3.10) for Lab 3, "Digital Modulation PSK & QAM".
Open them with `gnuradio-companion` and press **Run**. The instructor transmits on the 433 MHz ISM
band (QPSK at **434.02 MHz**, 16-QAM at **434.07 MHz**); you only receive.

| File | Part | What it does | SDR needed? |
|---|---|---|---|
| `psk_sim.grc` | A | QPSK link simulation (TX → channel model → RX) with live sliders for noise, carrier frequency error and clock error | No |
| `psk_rx.grc` | A | QPSK receiver: FLL, matched filter, symbol sync (Gardner), Costas loop, BER/SER meter with CSV logging | Yes (RTL-SDR) |
| `qam_sim.grc` | B | 16-QAM link simulation, same structure as `psk_sim.grc` for a fair comparison, with EVM meter | No |
| `qam_rx.grc` | B | 16-QAM receiver with EVM (Error Vector Magnitude) meter | Yes (RTL-SDR) |

Start with the two simulations: they need no hardware and show how each receiver stage works.
In them, constellation **"2. RX πριν τη διόρθωση"** is a demonstration branch with no carrier
correction at all, and **"3. RX μετά τη διόρθωση"** is the output of the full receiver.

In `psk_rx.grc` the **"Καταγραφή σημείου"** button appends a measurement line to
`../results/psk_measurements.csv` (the folder is created automatically).

The symbol rate of the receivers is read at start-up: after changing it, **Kill + Run**.

The handout is [`../handout/lab3_handout.pdf`](../handout/lab3_handout.pdf) (Greek).
