import numpy as np
from scipy.signal import butter, filtfilt
from scipy.signal import group_delay

def pcm_encode(signal, num_bits):
    """
    Encode a signal using PCM.

    Parameters:
    - signal: Input signal array.
    - num_bits: Number of bits per sample for quantization.

    Returns:
    - encoded_signal: Array of quantization indices.
    - quantized_signal: Quantized signal values.
    - quantization_error: Difference between original and quantized signal.
    """
    # Determine the maximum and minimum amplitude of the signal
    max_val = np.max(signal)
    min_val = np.min(signal)
    
    # Define quantization levels
    num_levels = 2 ** num_bits
    q_levels = np.linspace(min_val, max_val, num_levels)
    q_step = q_levels[1] - q_levels[0]
    
    # Quantize the signal
    quantized_signal = np.zeros_like(signal)
    encoded_signal = np.zeros_like(signal, dtype=int)
    
    for i, sample in enumerate(signal):
        # Find the closest quantization level
        index = np.argmin(np.abs(q_levels - sample))
        quantized_signal[i] = q_levels[index]
        encoded_signal[i] = index  # This represents the digital code
    
    # Calculate quantization error
    quantization_error = signal - quantized_signal
    
    return encoded_signal, quantized_signal, quantization_error, q_levels

def pcm_decode(encoded_signal, q_levels):
    """
    Decode a PCM encoded signal.

    Parameters:
    - encoded_signal: Array of quantization indices.
    - q_levels: Array of quantization levels.

    Returns:
    - reconstructed_signal: Reconstructed signal array.
    """
    # Reconstruct the signal from encoded data
    reconstructed_signal = q_levels[encoded_signal]
    
    return reconstructed_signal





def dpcm_encode(signal, step_size=0.1, bit_depth=4):
    """
    Encode a signal using DPCM (first order predictor).

    Parameters:
    - signal: Input signal array.
    - step_size: Quantization step size.
    - bit_depth: Number of bits used for quantizing differences.

    Returns:
    - encoded_signal: List of quantized differences.
    - predictor_values: List of predictor values used during encoding.
    """
    encoded_signal = []
    predictor_values = []
    predictor = 0  # Initial predicted value
    max_level = 2 ** (bit_depth - 1) - 1
    min_level = -2 ** (bit_depth - 1)

    for sample in signal:
        # Calculate difference between actual sample and prediction
        diff = sample - predictor

        # Quantize the difference
        quantized_diff = int(round(diff / step_size))

        # Clamp quantized_diff to prevent overflow
        quantized_diff = max(min(quantized_diff, max_level), min_level)

        # Dequantize the difference
        dequantized_diff = quantized_diff * step_size

        # Update predictor
        predictor += dequantized_diff

        # Store values
        encoded_signal.append(quantized_diff)
        predictor_values.append(predictor)

    return encoded_signal, predictor_values

def dpcm_decode(encoded_signal, step_size=0.1, bit_depth=4):
    """
    Decode a DPCM encoded signal.

    Parameters:
    - encoded_signal: List of quantized differences.
    - step_size: Quantization step size.
    - bit_depth: Number of bits used for quantizing differences.

    Returns:
    - reconstructed_signal: Reconstructed signal array.
    """
    reconstructed_signal = []
    predictor = 0  # Initial predicted value

    for quantized_diff in encoded_signal:
        # Dequantize the difference
        dequantized_diff = quantized_diff * step_size

        # Update predictor
        predictor += dequantized_diff

        # Store the reconstructed sample
        reconstructed_signal.append(predictor)

    return reconstructed_signal


def adpcm_encode(signal, initial_step_size=0.1, bit_depth=4):
    """
    Encode a signal using ADPCM.

    Parameters:
    - signal: Input signal array.
    - initial_step_size: Initial quantization step size.
    - bit_depth: Number of bits used for quantizing differences.

    Returns:
    - encoded_signal: List of quantized differences.
    - step_sizes: List of step sizes over time.
    """
    encoded_signal = []
    step_sizes = []
    predictor = 0  # Initial predictor value
    step_size = initial_step_size
    max_level = 2 ** (bit_depth - 1) - 1
    min_level = -2 ** (bit_depth - 1)

    for sample in signal:
        # Calculate the difference between the actual sample and the predictor
        diff = sample - predictor

        # Quantize the difference
        quantized_diff = int(round(diff / step_size))
        quantized_diff = max(min(quantized_diff, max_level), min_level)

        # Dequantize the difference
        dequantized_diff = quantized_diff * step_size

        # Update the predictor
        predictor += dequantized_diff

        # Adapt the step size
        # Increase step size when the quantized difference is large
        threshold = (2 ** (bit_depth - 1)) / 2
        increase_factor = 1.5
        decrease_factor = 0.9

        if abs(quantized_diff) > threshold:
            step_size *= increase_factor # Increase step size
        else:
            step_size *= decrease_factor # Decrease step size


        # Limit the step size to prevent it from becoming too small or too large
        step_size = max(step_size, initial_step_size / 5)
        step_size = min(step_size, initial_step_size * 5)

        # Store the quantized difference and step size
        encoded_signal.append(quantized_diff)
        step_sizes.append(step_size)

    return encoded_signal, step_sizes

def adpcm_decode(encoded_signal, initial_step_size=0.1, bit_depth=4):
    """
    Decode an ADPCM encoded signal.

    Parameters:
    - encoded_signal: List of quantized differences.
    - initial_step_size: Initial quantization step size.
    - bit_depth: Number of bits used for quantizing differences.

    Returns:
    - reconstructed_signal: Reconstructed signal array.
    """
    reconstructed_signal = []
    predictor = 0  # Initial predictor value
    step_size = initial_step_size

    for quantized_diff in encoded_signal:
        # Dequantize the difference
        dequantized_diff = quantized_diff * step_size

        # Update the predictor
        predictor += dequantized_diff

        # Adapt the step size
        threshold = (2 ** (bit_depth - 1)) / 2
        increase_factor = 1.5
        decrease_factor = 0.9

        if abs(quantized_diff) > threshold:
            step_size *= increase_factor # Increase step size
        else:
            step_size *= decrease_factor # Decrease step size

        # Limit the step size
        step_size = max(step_size, initial_step_size / 5)
        step_size = min(step_size, initial_step_size * 5)

        # Store the reconstructed sample
        reconstructed_signal.append(predictor)

    return reconstructed_signal



def delta_modulation_encode(signal, delta):
    """
    Encode a signal using Delta Modulation.

    Parameters:
    - signal: Input signal array.
    - delta: Step size.

    Returns:
    - encoded_bits: List of bits (0 or 1).
    - predictor_values: List of predictor values (reconstructed signal at encoder).
    """
    encoded_bits = []
    predictor_values = []
    predictor = 0  # Initial predictor value

    for sample in signal:
        # Compare input signal with predictor
        if sample >= predictor:
            bit = 1
            predictor += delta
        else:
            bit = 0
            predictor -= delta

        # Store the bit and predictor value
        encoded_bits.append(bit)
        predictor_values.append(predictor)

    return encoded_bits, predictor_values

def delta_modulation_decode(encoded_bits, delta):
    """
    Decode a Delta Modulated signal.

    Parameters:
    - encoded_bits: List of bits (0 or 1).
    - delta: Step size.

    Returns:
    - reconstructed_signal: Reconstructed signal array.
    """
    reconstructed_signal = []
    predictor = 0  # Initial predictor value

    for bit in encoded_bits:
        if bit == 1:
            predictor += delta
        else:
            predictor -= delta

        reconstructed_signal.append(predictor)

    return reconstructed_signal


def sigma_delta_modulation_encode(signal):
    """
    Encode a signal using Sigma-Delta Modulation.

    Parameters:
    - signal: Input signal array.

    Returns:
    - encoded_bits: List of bits (0 or 1).
    - integrator_output: List of integrator outputs.
    - quantizer_output: List of quantizer outputs.
    """
    encoded_bits = []
    integrator_output = []
    quantizer_output = []
    integrator = 0
    previous_quantized = 0

    for sample in signal:
        # Integrate the difference between input and feedback
        integrator += sample - previous_quantized

        # Quantize the integrator output
        if integrator >= 0:
            quantized = 1
        else:
            quantized = -1

        # Store the outputs
        encoded_bits.append(1 if quantized > 0 else 0)
        integrator_output.append(integrator)
        quantizer_output.append(quantized)

        # Feedback
        previous_quantized = quantized

    return encoded_bits, integrator_output, quantizer_output

def sigma_delta_modulation_decode(encoded_bits):
    """
    Decode a Sigma-Delta Modulated signal.

    Parameters:
    - encoded_bits: List of bits (0 or 1).

    Returns:
    - reconstructed_signal: Reconstructed signal array.
    """
    reconstructed_signal = []
    integrator = 0

    for bit in encoded_bits:
        quantized = 1 if bit == 1 else -1

        # Integrate the quantized values
        integrator += quantized

        # Store the reconstructed signal
        reconstructed_signal.append(integrator)

    # Normalize the reconstructed signal
    reconstructed_signal = np.array(reconstructed_signal)
    reconstructed_signal = reconstructed_signal - np.mean(reconstructed_signal)
    reconstructed_signal = reconstructed_signal / np.max(np.abs(reconstructed_signal))

    return reconstructed_signal



def lowpass_filter(data, cutoff, fs, order=5):
    """
    Apply a low-pass Butterworth filter to the data.

    Parameters:
    - data: Input signal array.
    - cutoff: Cutoff frequency in Hz.
    - fs: Sampling frequency in Hz.
    - order: Order of the filter.

    Returns:
    - y: Filtered signal.
    """
    nyq = 0.5 * fs  # Nyquist Frequency
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    y = filtfilt(b, a, data)

    # estimate group delay to compensate
    w, gd = group_delay((b, a), fs)
    average_gd = int(np.mean(gd))


    return y,average_gd

def adaptive_delta_modulation_encode(signal, delta_min=0.05, delta_max=1.0, alpha=1.5):
    """
    Encode a signal using Adaptive Delta Modulation.

    Parameters:
    - signal: Input signal array.
    - delta_min: Minimum step size.
    - delta_max: Maximum step size.
    - alpha: Step size increment factor.

    Returns:
    - encoded_bits: List of bits (0 or 1).
    - predictor_values: List of predictor values (reconstructed signal at encoder).
    - step_sizes: List of step sizes over time.
    """
    encoded_bits = []
    predictor_values = []
    step_sizes = []
    predictor = 0  # Initial predictor value
    delta = delta_min  # Initial step size

    prev_bit = None

    for sample in signal:
        # Compare input signal with predictor
        if sample >= predictor:
            bit = 1
            predictor += delta
        else:
            bit = 0
            predictor -= delta

        # Adjust the step size
        if prev_bit is not None:
            if bit == prev_bit:
                delta = min(delta * alpha, delta_max)
            else:
                delta = max(delta / alpha, delta_min)
        prev_bit = bit

        # Store the bit, predictor value, and step size
        encoded_bits.append(bit)
        predictor_values.append(predictor)
        step_sizes.append(delta)

    return encoded_bits, predictor_values, step_sizes

def adaptive_delta_modulation_decode(encoded_bits, delta_min=0.05, delta_max=1.0, alpha=1.5):
    """
    Decode an Adaptive Delta Modulated signal.

    Parameters:
    - encoded_bits: List of bits (0 or 1).
    - delta_min: Minimum step size.
    - delta_max: Maximum step size.
    - alpha: Step size increment factor.

    Returns:
    - reconstructed_signal: Reconstructed signal array.
    - step_sizes: List of step sizes over time.
    """
    reconstructed_signal = []
    predictor = 0  # Initial predictor value
    delta = delta_min  # Initial step size
    step_sizes = []

    prev_bit = None

    for bit in encoded_bits:
        # Update predictor based on bit
        if bit == 1:
            predictor += delta
        else:
            predictor -= delta

        # Adjust the step size
        if prev_bit is not None:
            if bit == prev_bit:
                delta = min(delta * alpha, delta_max)
            else:
                delta = max(delta / alpha, delta_min)
        prev_bit = bit

        # Store the reconstructed sample and step size
        reconstructed_signal.append(predictor)
        step_sizes.append(delta)

    return reconstructed_signal, step_sizes
