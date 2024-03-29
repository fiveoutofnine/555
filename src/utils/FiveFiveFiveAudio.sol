// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {FixedPointMathLib as Math} from "solady/utils/FixedPointMathLib.sol";

/// @title {FiveFiveFive} NFT auditory art
/// @author fiveoutofnine
/// @notice A library for generating onchain audio for {FiveFiveFive}, which is
/// a 24.832 second long audio of a 5-part arrangement of "Gonna Fly Now" by
/// Bill Conti, popularly known as the theme song from the movie Rocky (1976),
/// at 117.1875 BPM.
/// @dev The metadata returned by {FiveFiveFive} doesn't use this library for
/// practical reasons. However, the same result can be yielded by calling
/// {getSoundValueAtSample} for each sample in the range `[0, 794623]` and
/// concatenating the result, prefixed with the header returned by
/// {getAudioWavFileHeader}.
library FiveFiveFiveAudio {
    using Math for int256;
    using Math for uint256;

    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice A beatmap of when the 1st synth line is active in the audio,
    /// where each `1` bit represents a 1/64th note, or 1024 ticks, being
    /// played.
    /// @dev The beatmap ranges the entire length of 1 cycle for 1/64th notes
    /// with indices in `[0, 775]`, where the `i`th MSb is the corresponding
    /// data.
    bytes internal constant SYNTH_1_BEATMAP =
        hex"fefeeefeeefeeefefefeeefeeefeeefe00feeefeefeefffefefeeeefeffffeeffe"
        hex"fffffffffffeeffefffffffffffeeffefffffffffffeeffefffffffffffffffe00"
        hex"eeffeeeffffffe00eefeefeefffefefefefefefefeffffffffffffffffffff";

    /// @notice A bitpacked value of 8-bit words representing the notes of the
    /// 1st synth line, where each note is a 1/16th note, or 4096 ticks.
    /// @dev A value of `0x05` corresponds to C3, and 1 corresponds to a
    /// semitone. To attain the intended note value, it requires no
    /// transpositions, so the `_pitch` parameter passed into `_synth` should be
    /// set to `0`. Also, this value ranges the entire length of 1 cycle for
    /// 1/16th notes with indices in `[0, 193]`, where the `i`th MSb is the
    /// corresponding data.
    bytes internal constant SYNTH_1_NOTES =
        hex"05050505050505050505090905050505090909090909090909090c0c0909090909"
        hex"090909090909090909090909090909090909090909090909090909090915181818"
        hex"1a1a1a1a1a1a1a1a1a1a1a1a1a1c1c1c151515151515151515151515151818181a"
        hex"1a1a1a1a1a1a1a1a1a1a1a1a1c1c1c151515151515151515151515151515151515"
        hex"070507070705070909090909090911111111111111111111111111111616151515"
        hex"1515151515151515151515151515151515151515151515151515151515";

    /// @notice A bitpacked value of 8-bit words representing the notes of the
    /// 2nd synth line, where each note is a 1/16th note, or 4096 ticks.
    /// @dev A value of `0x1d` corresponds to C3, and 1 corresponds to a
    /// semitone. To attain the intended note value, it must be transposed down
    /// by 2 octaves, so the `_pitch` parameter passed into `_synth` should be
    /// set to `2e18`. Also, this value ranges 1/16th notes with indices in
    /// `[16, 165]`, where the `i`th MSb is the corresponding data.
    bytes internal constant SYNTH_2_NOTES =
        hex"080808080808080808080808080808081d1d1d1d1d1d1d1d1d1d21211d1d1d1d1c"
        hex"1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c21242424"
        hex"212121212121212121212121262828281d1d1d1d1d1d1d1d1d1d1d1d2124242421"
        hex"212121212121212121212126282828212121212121212121212121212121212121"
        hex"1f1d1f1f1f1d1f212121212121211d1d1d1d1c1c1c1a1a1a181818181d1d1d1d1d"
        hex"1d";

    /// @notice A beatmap of when the 1st bass line is active in the audio,
    /// where each `1` bit represents a 1/64th note, or 1024 ticks, being
    /// played.
    /// @dev The beatmap ranges the entire length of 1 cycle for 1/64th notes
    /// with indices in `[0, 775]`, where the `i`th MSb is the corresponding
    /// data.
    bytes internal constant BASS_1_BEATMAP =
        hex"0000000000000000000000000000000000000000000000fffefffffffffffffffe"
        hex"fffefffefffefffefffefffefffefffefffefffefffefffefffefffefffefffeff"
        hex"fefffefffefffe00eefeefeefffefefefeeffefeefffffffffffffffffffff";

    /// @notice A bitpacked value of 8-bit words representing the notes of the
    /// 1st bass line, where each note is a 1/16th note, or 4096 ticks.
    /// @dev A value of `0x35` corresponds to C3, and 1 corresponds to a
    /// semitone. To attain the intended note value, it must be transposed down
    /// by 4 octaves, so the `_pitch` parameter passed into `_synth` should be
    /// set to `4e18`. Also, this value ranges the entire length of 1 cycle for
    /// 1/16th notes with indices in `[0, 193]`, where the `i`th MSb is the
    /// corresponding data.
    bytes internal constant BASS_1_NOTES =
        hex"080808080808080808080808080808080808080808080808080808080808080808"
        hex"080808080808080808080808082e2e2e2e2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d"
        hex"2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e303030303030303030303030303030302e"
        hex"2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e303030303030303030303030303030303232"
        hex"323232323232303030303030303032323232323232323232303030303030303030"
        hex"3030303030303030303030303030303030303030303030303030303030";

    /// @notice A beatmap of when the 2nd bass line is active in the audio,
    /// where each `1` bit represents a 1/64th note, or 1024 ticks, being
    /// played.
    /// @dev The beatmap ranges the entire length of 1 cycle for 1/64th notes
    /// with indices in `[0, 775]`, where the `i`th MSb is the corresponding
    /// data.
    bytes internal constant BASS_2_BEATMAP =
        hex"0000000000000000000000000000000000fffffffffffefffefffffffffffffffe"
        hex"fefefffeeefefefefefefffeeefefefefefeffeeeefefefefefeffeeeefeeeeeff"
        hex"ffffeefeffefeefeffffffeefeeeeefeeefefefefeffffffffffffffffffff";

    /// @notice A bitpacked value of 8-bit words representing the notes of the
    /// 2nd bass line, where each note is a 1/16th note, or 4096 ticks.
    /// @dev A value of `0x35` corresponds to C3, and 1 corresponds to a
    /// semitone. To attain the intended note value, it must be transposed down
    /// by 4 octaves, so the `_pitch` parameter passed into `_synth` should be
    /// set to `4e18`. Also, this value ranges the entire length of 1 cycle for
    /// 1/16th notes with indices in `[0, 193]`, where the `i`th MSb is the
    /// corresponding data.
    bytes internal constant BASS_2_NOTES =
        hex"080808080808080808080808080808080808080808080808080808080808080808"
        hex"082828282828282828282828282222222221212121212121212121212121212121"
        hex"1f1f1d1d1f1f1f1f29292a2a2b2b1f1f21211f1f212121212b2b2c2c2d2d21211f"
        hex"1f1d1d1f1f1f2629262a2a2b2b1f1f21211f1f212121282b282c2c2d28211d1f1f"
        hex"1f1f1f1f1f1f21212121212121212222222222222222222e2e2e2e22222221212d"
        hex"2d2d2d2d2d212121212121212121212121212121212121212121212121";

    /// @notice A beatmap of when the snare line is active in the audio, where
    /// where each `1` bit represents a 1/64th note, or 1024 ticks, being
    /// played.
    /// @dev The beatmap ranges 1/64th notes with indices in `[236, 711]`,
    /// where the `i - 236`th MSb is the corresponding data.
    bytes internal constant SNARE_BEATMAP =
        hex"ee0e0e0e000e0000000e000e000e0000000e000e000e0000000e000e000e000000"
        hex"0e000e000e0000000e000e000e0000000e000e0e0e0e0e0e0e0000";

    /// @notice A bitpacked value of 8-bit words representing the notes of the
    /// ending glissando synth line, where each note is a 1/32nd note, or 2048
    /// ticks.
    /// @dev A value of `0x05` corresponds to C3, and 1 corresponds to a
    /// semitone. To attain the intended note value, it requires no
    /// transpositions, so the `_pitch` parameter passed into `_synth` should be
    /// set to `0`. Also, this value ranges 1/32nd notes with the indicies in
    /// `[332, 347]`, where the `i - 332`th MSb is the corresponding data.
    bytes internal constant SYNTH_GLISSANDO =
        hex"0507090a0c0e101113151617191b1c1e";

    // -------------------------------------------------------------------------
    // Functions
    // -------------------------------------------------------------------------

    /// @notice Returns the WAV file header for the audio file for 1 full cycle
    /// of the token's sound with the parameters the token's sound was generated
    /// with:
    /// * Size: 776.044921875kB (794670 bytes)
    /// * Number of channels: 1
    /// * Sample rate: 32000Hz
    /// * Bits/sample: 8 bits/sample
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
        uint256 tickWad;
        uint256 n64;
        uint256 n16;
        uint256 n64x;
        uint256 n64y;
        assembly {
            _tick := mod(_tick, shl(10, 776)) // `_tick % (776 << 10)`
            n64 := mod(shr(10, _tick), 776) // `(_tick >> 10) % 776`
            n16 := shr(2, n64) // `n64 >> 2`
            tickWad := mul(_tick, 1000000000000000000) // `_tick * 1e18`
            n64x := shr(3, n64) // `n64 >> 3`
            n64y := sub(7, and(n64, 7)) // `7 - (n64 & 7)`
        }

        unchecked {
            // Get whether each line is active at the given `_tick`.
            bool synth1Active = (uint8(SYNTH_1_BEATMAP[n64x]) >> n64y) & 1 > 0;
            bool synth2Active;
            bool bass1Active = (uint8(BASS_1_BEATMAP[n64x]) >> n64y) & 1 > 0;
            bool bass2Active = (uint8(BASS_2_BEATMAP[n64x]) >> n64y) & 1 > 0;
            bool snareActive = n16 > 58 && n16 < 178;
            uint256 snareN64;
            assembly {
                synth2Active := and(synth1Active, and(gt(n16, 15), lt(n16, 166)))
                snareN64 := mul(snareActive, sub(n64, 236))
            }
            snareActive = snareActive && (uint8(SNARE_BEATMAP[snareN64 >> 3]) >> (7 - (snareN64 & 7))) & 1 > 0;

            // If the line is active, compute the sound value of the note at the
            // given `_tick`.
            uint256 synth1 = synth1Active ? _synth(tickWad, _getNote(SYNTH_1_NOTES, n16), 0) : 0;
            uint256 synth2 = synth2Active ? _synth(tickWad, _getNote(SYNTH_2_NOTES, n16), 2e18) : 0;
            uint256 bass1 = bass1Active ? _synth(tickWad, _getNote(BASS_1_NOTES, n16), 4e18) : 0; 
            uint256 bass2 = bass2Active ? _synth(tickWad, _getNote(BASS_2_NOTES, n16), 4e18) : 0;
            uint256 snare;
            if (snareActive) {
                snare = uint256(2e29).mulWad(tickWad.divWad(1e18 << 14));
                snare = ((snare.mulWad(snare) / 1e18) & 255) / 10;
            }
            uint256 glissando = n16 > 165 && n16 < 174
                ? _synth(tickWad, 1e18 * uint256(uint8(SYNTH_GLISSANDO[(n64 >> 1) - 332])), 0)
                : 0;
            uint256 ending = n16 > 173 ? _synth(tickWad, 21e18, 0) : 0;

            // Finally, add all the lines together and return the result.
            return uint8(synth1 + synth2 + bass1 + bass2 + snare + glissando + ending);
        }
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    /// @notice Returns the note value of a note at a given 1/16th note index
    /// of a given bitpacked value as an 18 decimal fixed-point number.
    /// @param _data The bitpacked value of 8-bit words representing the notes
    /// of a line.
    /// @param _n16 The 1/16th note index of the note to get the value of.
    /// @return The note value, as an 18 decimal fixed-point number.
    function _getNote(bytes memory _data, uint256 _n16) internal pure returns (uint256) {
        unchecked {
            return 1e18 * uint256(uint8(_data[_n16]));
        }
    }

    /// @notice Returns the sound value of a note of an 8-bit synth wave with
    /// vibrato at a given time tick.
    /// @dev Altogether, in pseudo-code, the function is equivalent to
    /// `0.392 * (tick + 12 * sin(tick / 1600)) * 2 ** (note / 12 - pitch)`.
    /// @param _tickWad The time tick at which to get the sound value, as an 18
    /// decimal fixed-point value.
    /// @param _note The note to get the sound value of, where C3 is 5, and 1
    /// corresponds to a semitone, as an 18 decimal fixed-point value.
    /// @param _pitch The number of octaves to transpose the note by, as an 18
    /// decimal fixed-point value.
    /// @return The sound value of the note at the given time tick, a value in
    /// the range `[0, 15]` (higher means louder).
    function _synth(uint256 _tickWad, uint256 _note, int256 _pitch) internal pure returns (uint8) {
        // Next, calculate the vibration and sound value of the note at the
        // given `_tickWad`.
        unchecked {
            // Equivalent to `tick + 12 * sin(tick / 1600)`.
            int256 vibration = int256(_tickWad) + _sin(_tickWad.divWad(1600e18)).sMulWad(12e18);
            // Equivalent to `2**(note / 12 - pitch)`.
            int256 noteSoundValue = int256(2e18).powWad(int256(_note.divWad(12e18)) - _pitch);
            // Equivalent to `0.392 * vibration * noteSoundValue`.
            int256 soundValue = int256(0.392e18).sMulWad(vibration).sMulWad(noteSoundValue);
            assembly {
                // Equivalent to `soundValue / 1e18`.
                soundValue := div(soundValue, 1000000000000000000)
            }

            // Here, we truncate the sound value with `& 32` and then halve it.
            return uint8(uint256(soundValue.abs()) & 32) >> 1;
        }
    }

    /// @notice An approximation of the `sin` function (with transformations)
    /// that composes the helper function {FiveFiveFiveAudio._cos}.
    /// @dev Since the Taylor series approximation of `cos` is only accurate for
    /// half the domain, this function gets the other half by negating the
    /// result depending on which half of the domain the input is in.
    /// @param _x An 18 decimal fixed-point value.
    /// @return The approximated value of `sin(_x)` as an 18 decimal fixed-point
    /// value.
    function _sin(uint256 _x) internal pure returns (int256) {
        // `a` is the term to pass into the `_cos` function (before translating
        // right by 2), and `b` is the coefficient to negate the result of the
        // `_cos` function.
        int256 a;
        int256 b;
        assembly {
            // Equivalent to `_x % 4e18`.
            a := mod(_x, 4000000000000000000)
            // Equivalent to `(_x / 1e18) & 3 > 2 ? -1 : 1`.
            b := add(mul(gt(and(div(_x, 1000000000000000000), 3), 2), sub(not(0), 1)), 1)
        }

        // Whether to negate the result of the `_cos` function (because we only
        // get half the range from the Taylor series approximation).
        unchecked {
            return b * _cos(a - 2e18);
        }
    }

    /// @notice Returns a 4-term Taylor series approximation for the `cos`
    /// function.
    /// @dev Altogether, in pseudo-code, the function is equivalent to
    /// `1 - x**2/2! + x**4/4! - x**6/6!`.
    /// @param _x An 18 decimal fixed-point value.
    /// @return The approximated value of `cos(_x)` as an 18 decimal fixed-point
    /// value.
    function _cos(int256 _x) internal pure returns (int256) {
        // First, calculate the 2nd, 4th, and 6th powers of `_x`.
        int256 x2 = _x.sMulWad(_x);
        int256 x4 = x2.sMulWad(x2);
        int256 x6 = x2.sMulWad(x4);

        // Next, calculate the 1st, 2nd, and 3rd terms of the Taylor series
        // expansion of `cos(x)` around `x = 0`.
        int256 t1 = x2.sDivWad(2e18);
        int256 t2 = x4.sDivWad(24e18);
        int256 t3 = x6.sDivWad(720e18);

        // Finally, calculate the value of `cos(x)` using the Taylor series
        // expansion.
        unchecked {
            return 1e18 - t1 + t2 - t3;
        }
    }
}
