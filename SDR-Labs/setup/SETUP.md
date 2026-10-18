# Environment setup (Ubuntu · macOS)

🇬🇷 [Ελληνικά παρακάτω](#ρύθμιση-περιβάλλοντος-ubuntu--macos) · 🇬🇧 English

Instructions for installing the SDR toolchain for the course laboratories (Digital Communications, ECE_K510).
For Windows, see the Lab 0 handout (radioconda + Zadig).

## Ubuntu

### 1. Install packages

```bash
sudo apt update
sudo apt install gnuradio gr-osmosdr rtl-sdr hackrf
```

This installs:
- **gnuradio** — GNU Radio 3.10 and GNU Radio Companion.
- **gr-osmosdr** — the common source/sink driver GNU Radio uses for RTL-SDR and HackRF.
- **rtl-sdr** — user-space tools and library for RTL-SDR dongles (`rtl_test`, etc.).
- **hackrf** — user-space tools and library for HackRF One (`hackrf_info`, etc.).

### 2. Blacklist the kernel DVB-T driver

The Linux kernel recognises RTL-SDR dongles as DVB-T devices and automatically claims them with the
`dvb_usb_rtl28xxu` module, which prevents `librtlsdr` (and therefore `gr-osmosdr`) from accessing them.
It must be blacklisted:

```bash
echo "blacklist dvb_usb_rtl28xxu" | sudo tee /etc/modprobe.d/blacklist-rtlsdr.conf
sudo modprobe -r dvb_usb_rtl28xxu
```

If `modprobe -r` fails because the module is in use, reboot — the blacklist file will prevent it
from being loaded again from the next boot on.

### 3. Anaconda / conda

If Anaconda/Miniconda is installed, the active `base` environment may come first in `PATH` and hide the
system `python3` — and with it the `osmosdr` module of `gr-osmosdr`, which is installed only in the system
Python. We recommend disabling automatic activation of `base`:

```bash
conda config --set auto_activate_base false
```

then open a new terminal (or run `conda deactivate`) before running GNU Radio tools.

### 4. Verify the installation

```bash
./setup/check_environment.sh
```

The script checks: `gnuradio-companion` (and the GNU Radio version), the `osmosdr` Python module,
`rtl_test` and `hackrf_info` (including detection of a connected device), whether `dvb_usb_rtl28xxu` is
loaded, and whether a conda environment is active. Without a connected RTL-SDR/HackRF, the related
`[WARN]` lines for "device not connected" are expected and are not an installation problem; `[FAIL]`
lines mean that something is missing or not working.

## macOS (Intel and Apple Silicon)

On macOS we recommend the self-contained [**radioconda**](https://github.com/ryanvolz/radioconda)
distribution (GNU Radio, SDR drivers and dependencies together). No kernel driver blacklisting and
no Zadig are needed.

1. Download from the radioconda releases the `.sh` installer for your architecture:
   **arm64** (Apple Silicon) or **x86_64** (Intel).
2. Run it in Terminal, accepting the defaults:

   ```bash
   bash ~/Downloads/radioconda-*-MacOSX-*.sh
   ```

3. Open a new Terminal and start GRC: `gnuradio-companion`.
4. Verify manually (`check_environment.sh` is written for Ubuntu):

   ```bash
   gnuradio-companion --version
   rtl_test -t        # with an RTL-SDR connected
   hackrf_info        # with a HackRF connected
   ```

If macOS blocks an executable as "from an unidentified developer":
*System Settings → Privacy & Security → Open Anyway*.

---

# Ρύθμιση περιβάλλοντος (Ubuntu · macOS)

🇬🇧 [English above](#environment-setup-ubuntu--macos) · 🇬🇷 Ελληνικά

Οδηγίες εγκατάστασης του SDR toolchain για τα εργαστήρια του μαθήματος Ψηφιακές Επικοινωνίες (ECE_K510).
Για τα Windows, δείτε το φυλλάδιο του Εργαστηρίου 0 (radioconda + Zadig).

## 1. Εγκατάσταση πακέτων

```bash
sudo apt update
sudo apt install gnuradio gr-osmosdr rtl-sdr hackrf
```

Αυτό εγκαθιστά:
- **gnuradio** — GNU Radio 3.10 και το GNU Radio Companion.
- **gr-osmosdr** — τον κοινό οδηγό πηγής/προορισμού που χρησιμοποιεί το GNU Radio για RTL-SDR
  και HackRF.
- **rtl-sdr** — user-space εργαλεία και βιβλιοθήκη για RTL-SDR dongles (`rtl_test` κ.ά.).
- **hackrf** — user-space εργαλεία και βιβλιοθήκη για HackRF One (`hackrf_info` κ.ά.).

## 2. Αποκλεισμός του πυρηνικού driver DVB-T

Τα RTL-SDR dongles αναγνωρίζονται από τον πυρήνα του Linux ως συσκευές DVB-T και "αρπάζονται"
αυτόματα από το άρθρωμα `dvb_usb_rtl28xxu`, εμποδίζοντας το `librtlsdr` (και άρα το
`gr-osmosdr`) να τα προσπελάσει. Πρέπει να μπει σε blacklist:

```bash
echo "blacklist dvb_usb_rtl28xxu" | sudo tee /etc/modprobe.d/blacklist-rtlsdr.conf
sudo modprobe -r dvb_usb_rtl28xxu
```

Αν το `modprobe -r` αποτύχει επειδή το άρθρωμα είναι σε χρήση, κάντε επανεκκίνηση — το
blacklist αρχείο θα εμποδίσει την επαναφόρτωσή του από το επόμενο boot και μετά.

## 3. Anaconda / conda

Αν είναι εγκατεστημένο το Anaconda/Miniconda, το ενεργό `base` environment μπορεί να
προτάσσεται στο `PATH` και να κρύβει το system `python3` — και άρα και το `osmosdr` module
του `gr-osmosdr`, το οποίο είναι εγκατεστημένο μόνο στο system Python. Συνιστάται να
απενεργοποιηθεί η αυτόματη ενεργοποίηση του `base`:

```bash
conda config --set auto_activate_base false
```

και μετά να ανοίξετε νέο terminal (ή `conda deactivate`) πριν τρέξετε GNU Radio εργαλεία.

## 4. Επαλήθευση εγκατάστασης

Μετά τα παραπάνω βήματα, τρέξτε:

```bash
./setup/check_environment.sh
```

Το script ελέγχει: `gnuradio-companion` (και την έκδοση GNU Radio), το Python module
`osmosdr`, τα `rtl_test` και `hackrf_info` (μαζί με ανίχνευση συνδεδεμένης συσκευής), το
αν είναι φορτωμένο το `dvb_usb_rtl28xxu`, και το αν είναι ενεργό κάποιο conda environment.
Χωρίς συνδεδεμένο RTL-SDR/HackRF, τα σχετικά `[WARN]` για "device not connected" είναι
αναμενόμενα και δεν αποτελούν πρόβλημα εγκατάστασης· `[FAIL]` γραμμές σημαίνουν κάτι
λείπει ή δεν λειτουργεί.

---

# macOS (Intel και Apple Silicon)

Στο macOS προτείνεται η αυτόνομη διανομή [**radioconda**](https://github.com/ryanvolz/radioconda)
(GNU Radio, οδηγοί SDR και εξαρτήσεις μαζί). Δεν χρειάζεται blacklist του πυρηνικού driver ούτε
Zadig.

1. Κατεβάστε από τα releases της radioconda τον installer `.sh` για την αρχιτεκτονική σας:
   **arm64** (Apple Silicon) ή **x86_64** (Intel).
2. Τρέξτε τον στο Terminal, αποδεχόμενοι τις προεπιλογές:

   ```bash
   bash ~/Downloads/radioconda-*-MacOSX-*.sh
   ```

3. Ανοίξτε νέο Terminal και ξεκινήστε το GRC: `gnuradio-companion`.
4. Επαλήθευση χειροκίνητα (το `check_environment.sh` είναι γραμμένο για Ubuntu):

   ```bash
   gnuradio-companion --version
   rtl_test -t        # με συνδεδεμένο RTL-SDR
   hackrf_info        # με συνδεδεμένο HackRF
   ```

Αν το macOS μπλοκάρει κάποιο εκτελέσιμο ως «από μη επαληθευμένο προγραμματιστή»:
*System Settings → Privacy & Security → Open Anyway*.
