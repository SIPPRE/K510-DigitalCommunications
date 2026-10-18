#!/usr/bin/env bash
#
# check_environment.sh
#
# Verifies that the SDR toolchain needed for the K510-SDR-Labs exercises
# (GNU Radio 3.10, gr-osmosdr, RTL-SDR tools, HackRF tools) is installed
# and working, and prints clear OK/FAIL/WARN lines for each check. Also
# warns about two common local misconfigurations: the dvb_usb_rtl28xxu
# kernel module claiming RTL-SDR dongles, and an active conda environment
# shadowing the system python3. See setup/SETUP.md for details.
#
# Exit status: 0 if all required checks pass, 1 if any required check fails.

set -uo pipefail

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
NC=$'\033[0m'

FAILED=0

ok()   { printf '  %s[ OK ]%s %s\n'   "$GREEN"  "$NC" "$1"; }
fail() { printf '  %s[FAIL]%s %s\n'  "$RED"    "$NC" "$1"; FAILED=1; }
warn() { printf '  %s[WARN]%s %s\n'  "$YELLOW" "$NC" "$1"; }

section() { printf '\n== %s ==\n' "$1"; }

# ---------------------------------------------------------------------------
section "gnuradio-companion"

if command -v gnuradio-companion >/dev/null 2>&1; then
    ok "gnuradio-companion found at $(command -v gnuradio-companion)"

    if command -v gnuradio-config-info >/dev/null 2>&1; then
        GR_VERSION="$(gnuradio-config-info --version 2>/dev/null)"
        if [ -n "$GR_VERSION" ]; then
            ok "GNU Radio version: $GR_VERSION"
            case "$GR_VERSION" in
                3.10*) ok "GNU Radio 3.10 detected (expected version)" ;;
                *)     warn "Expected GNU Radio 3.10, found $GR_VERSION" ;;
            esac
        else
            warn "Could not determine GNU Radio version via gnuradio-config-info"
        fi
    else
        warn "gnuradio-config-info not found; cannot verify GNU Radio version"
    fi
else
    fail "gnuradio-companion not found in PATH (install: sudo apt install gnuradio)"
fi

# ---------------------------------------------------------------------------
section "gr-osmosdr (Python bindings)"

PYTHON_BIN="$(command -v python3 || true)"
if [ -z "$PYTHON_BIN" ]; then
    fail "python3 not found in PATH"
else
    if "$PYTHON_BIN" -c "import osmosdr" >/dev/null 2>&1; then
        ok "gr-osmosdr Python module (osmosdr) importable"
    else
        fail "gr-osmosdr Python module (osmosdr) not importable (install: sudo apt install gr-osmosdr)"
    fi
fi

# ---------------------------------------------------------------------------
section "rtl_test (RTL-SDR, student RX)"

if command -v rtl_test >/dev/null 2>&1; then
    ok "rtl_test found at $(command -v rtl_test)"

    RTL_OUTPUT="$(timeout 3 rtl_test -t 2>&1)"
    if printf '%s' "$RTL_OUTPUT" | grep -qi "Found [1-9][0-9]* device"; then
        ok "RTL-SDR device detected and responding"
    elif printf '%s' "$RTL_OUTPUT" | grep -qi "No supported devices found"; then
        warn "rtl_test runs correctly, but no RTL-SDR dongle is currently connected"
    else
        warn "rtl_test ran but produced an unexpected response; connect a device and re-run to confirm"
    fi
else
    fail "rtl_test not found in PATH (install: sudo apt install rtl-sdr)"
fi

# ---------------------------------------------------------------------------
section "hackrf_info (HackRF One, προαιρετικό)"

if command -v hackrf_info >/dev/null 2>&1; then
    ok "hackrf_info found at $(command -v hackrf_info)"

    HACKRF_OUTPUT="$(timeout 3 hackrf_info 2>&1)"
    if printf '%s' "$HACKRF_OUTPUT" | grep -qi "Found HackRF"; then
        ok "HackRF One detected and responding"
    elif printf '%s' "$HACKRF_OUTPUT" | grep -qi "No HackRF boards found"; then
        warn "hackrf_info runs correctly, but no HackRF board is currently connected"
    else
        warn "hackrf_info ran but produced an unexpected response; connect the board and re-run to confirm"
    fi
else
    fail "hackrf_info not found in PATH (install: sudo apt install hackrf)"
fi

# ---------------------------------------------------------------------------
section "dvb_usb_rtl28xxu kernel module"

if command -v lsmod >/dev/null 2>&1; then
    if lsmod | grep -q '^dvb_usb_rtl28xxu'; then
        warn "dvb_usb_rtl28xxu is loaded; it will claim RTL-SDR dongles before librtlsdr can. Blacklist it (see setup/SETUP.md) and run 'sudo modprobe -r dvb_usb_rtl28xxu' or reboot."
    else
        ok "dvb_usb_rtl28xxu is not loaded"
    fi
else
    warn "lsmod not available; cannot check for the dvb_usb_rtl28xxu kernel module"
fi

# ---------------------------------------------------------------------------
section "Conda environment"

if [ -n "${CONDA_DEFAULT_ENV:-}" ]; then
    warn "Conda environment '$CONDA_DEFAULT_ENV' is active; it may shadow the system python3 and hide gr-osmosdr. Run 'conda deactivate' or 'conda config --set auto_activate_base false' (see setup/SETUP.md)."
else
    ok "No conda environment active"
fi

# ---------------------------------------------------------------------------
section "Summary"

if [ "$FAILED" -eq 0 ]; then
    printf '%sAll required tools are installed.%s Any WARN above is informational (e.g. no SDR device plugged in).\n' "$GREEN" "$NC"
else
    printf '%sOne or more required tools are missing or not working.%s See FAIL lines above.\n' "$RED" "$NC"
fi

exit "$FAILED"
