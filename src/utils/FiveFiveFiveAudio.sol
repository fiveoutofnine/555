// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { FixedPointMathLib as Math } from "solady/utils/FixedPointMathLib.sol";

/// @title 10000km ran in 555 (1000 × ⁵⁄₉) day-streak commemorative NFT auditory
/// art.
/// @notice A library for generating onchain audio for {FiveFiveFive}, which is
/// a 24.832 second long audio 5-part arrangement of "Gonna Fly Now" by Bill
/// Conti, popularly known as the theme song from the movie Rocky (1976) at
/// 117.1875 BPM.
/// @dev The metadata returned by {FiveFiveFive} doesn't use this library for
/// practical reasons. However, the same result can be yielded by calling
/// {getSoundValueAtSample} for each sample in the range `[0, 794624]` and
/// concatenating the result, prefixed with the header returned by
/// {getAudioWavFileHeader}.
library FiveFiveFiveAudio {
    using Math for int256;
    using Math for uint256;

    // -------------------------------------------------------------------------
    // Functions
    // -------------------------------------------------------------------------

    /// @notice Returns the WAV file header for the audio file for 1 full cycle
    /// of the token's sound with the parameters the token's sound was generated
    /// with:
    ///     * Size: 776.044921875kB (794670 bytes)
    ///     * Number of channels: 1
    ///     * Sample rate: 32000Hz
    ///     * Bits/sample: 8 bits/sample
    function getAudioWavFileHeader() internal pure returns (bytes memory) {
        // Note: base-64 encoding the following hex string yields:
        // "UklGRi4gDABXQVZFZm10IBAAAAABAAEAAH0AAAB9AAABAAgAZGF0YQAgDACA".
        return
        // "RIFF" chunk descriptor
        hex"52" hex"49" hex"46" hex"46" // "RIFF" in ASCII
        hex"2e" hex"20" hex"0c" hex"00" // Size of the file (length of data chunk + 46 for the header) = 794624 + 46 = 794670
        hex"57" hex"41" hex"56" hex"45" // "WAVE" in ASCII
        // "fmt " sub-chunk
        hex"66" hex"6d" hex"74" hex"20" // "fmt " in ASCII
        hex"10" hex"00" hex"00" hex"00" // Length of sub-chunk 1 = 16
        hex"01" hex"00" hex"01" hex"00" // Audio format = 1 (PCM), Number of channels = 1
        hex"00" hex"7d" hex"00" hex"00" // Sample rate = 32000Hz
        hex"00" hex"7d" hex"00" hex"00" // Byte rate (sample rate * bits/sample * channels) = (32000 * 8 * 1) / 8 = 32000 bytes/sec
        hex"01" hex"00" hex"08" hex"00" // Block align = 1, bits/sample = 8
        // "data" sub-chunk
        hex"64" hex"61" hex"74" hex"61" // "data" in ASCII
        hex"00" hex"20" hex"0c" hex"00" // Length of data chunk = (776 * 2**10 * 8 / 8) = 794624 bytes
        hex"80"; // Sample 1
    }

    /// @notice Returns the sound value at a given time tick in the audio.
    /// @dev {FiveFiveFive}'s audio was generated at a sample rate of 32000Hz,
    /// which means that `_tick` increments by 1 every 1/32000 seconds. A full
    /// cycle of the audio is 776 * 2**10 = 794624 samples long, so `_tick`
    /// wraps around every 794624 samples (i.e. same values for equivalent
    /// `_tick % 794624`).
    /// @param _tick The number of samples since the beginning of the audio at
    /// a frequency of 32000Hz to get the sound value at.
    /// @return The sound value at the given time tick, a value in the range
    /// `[0, 255]` (higher means louder).
    function getSoundValueAtSample(uint256 _tick) internal pure returns (uint8) {
        // TODO
        return uint8(_tick);
    }
}
