// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { FixedPointMathLib as Math } from "solady/utils/FixedPointMathLib.sol";

/// @title {FiveFiveFive} NFT auditory art
/// @author fiveoutofnine
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
    // Constants
    // -------------------------------------------------------------------------

    bytes internal constant SYNTH_1_BEATMAP =
        hex"fefeeefeeefeeefefefeeefeeefeeefe00feeefeefeefffefefeeeefeffffeeffe"
        hex"fffffffffffeeffefffffffffffeeffefffffffffffeeffefffffffffffffffe00"
        hex"eeffeeeffffffe00eefeefeefffefefefefefefefeffffffffffffffffffff";

    bytes internal constant SYNTH_1_NOTES =
        hex"05050505050505050505090905050505090909090909090909090c0c0909090909"
        hex"090909090909090909090909090909090909090909090909090909090915181818"
        hex"1a1a1a1a1a1a1a1a1a1a1a1a1a1c1c1c151515151515151515151515151818181a"
        hex"1a1a1a1a1a1a1a1a1a1a1a1a1c1c1c151515151515151515151515151515151515"
        hex"070507070705070909090909090911111111111111111111111111111616151515"
        hex"1515151515151515151515151515151515151515151515151515151515";

    bytes internal constant SYNTH_2_NOTES =
        hex"080808080808080808080808080808081d1d1d1d1d1d1d1d1d1d21211d1d1d1d1c"
        hex"1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c1c21242424"
        hex"212121212121212121212121262828281d1d1d1d1d1d1d1d1d1d1d1d2124242421"
        hex"212121212121212121212126282828212121212121212121212121212121212121"
        hex"1f1d1f1f1f1d1f212121212121211d1d1d1d1c1c1c1a1a1a181818181d1d1d1d1d"
        hex"1d";

    bytes internal constant BASS_1_BEATMAP =
        hex"0000000000000000000000000000000000000000000000fffefffffffffffffffe"
        hex"fffefffefffefffefffefffefffefffefffefffefffefffefffefffefffefffeff"
        hex"fefffefffefffe00eefeefeefffefefefeeffefeefffffffffffffffffffff";

    bytes internal constant BASS_1_NOTES =
        hex"080808080808080808080808080808080808080808080808080808080808080808"
        hex"080808080808080808080808082e2e2e2e2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d"
        hex"2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e303030303030303030303030303030302e"
        hex"2e2e2e2e2e2e2e2e2e2e2e2e2e2e2e303030303030303030303030303030303232"
        hex"323232323232303030303030303032323232323232323232303030303030303030"
        hex"3030303030303030303030303030303030303030303030303030303030";

    bytes internal constant BASS_2_BEATMAP =
        hex"0000000000000000000000000000000000fffffffffffefffefffffffffffffffe"
        hex"fefefffeeefefefefefefffeeefefefefefeffeeeefefefefefeffeeeefeeeeeff"
        hex"ffffeefeffefeefeffffffeefeeeeefeeefefefefeffffffffffffffffffff";

    bytes internal constant BASS_2_NOTES =
        hex"080808080808080808080808080808080808080808080808080808080808080808"
        hex"082828282828282828282828282222222221212121212121212121212121212121"
        hex"1f1f1d1d1f1f1f1f29292a2a2b2b1f1f21211f1f212121212b2b2c2c2d2d21211f"
        hex"1f1d1d1f1f1f2629262a2a2b2b1f1f21211f1f212121282b282c2c2d28211d1f1f"
        hex"1f1f1f1f1f1f21212121212121212222222222222222222e2e2e2e22222221212d"
        hex"2d2d2d2d2d212121212121212121212121212121212121212121212121";

    bytes internal constant SNARE_BEATMAP =
        hex"ee0e0e0e000e0000000e000e000e0000000e000e000e0000000e000e000e000000"
        hex"0e000e000e0000000e000e000e0000000e000e0e0e0e0e0e0e0000";

    bytes internal constant SYNTH_GLISSANDO =
        hex"0507090a0c0e101113151617191b1c1e";

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
        uint256 n64;
        uint256 n16;
        uint256 tickWad;
        assembly {
            _tick := mod(_tick, shl(10, 776))
            n64 := mod(shr(10, _tick), 776)
            n16 := shr(2, n64)
            tickWad := mul(_tick, 1000000000000000000)
        }

        /* assembly {
            // Synth 1
            function get_is_playing(beatmap, idx) -> ret {
                ret := mload(add(add(0x20, beatmap), mul(0x20, shr(3, idx))))
                beat := and(idx, 7)
            }
        } */

        // Synth 1.
        bool synth1b = (uint8(SYNTH_1_BEATMAP[n64 >> 3]) >> (7 - (n64 & 7))) & 1 == 1;
        uint256 synth1 = synth1b ? _synth(tickWad, 1e18 * uint256(uint8(SYNTH_1_NOTES[n16])), 0) : 0;

        // Synth 2.
        bool synth2b;
        assembly { synth2b := and(synth1b, and(gt(n16, 15), lt(n16, 166))) }
        uint256 synth2 = synth2b ? _synth(tickWad, 1e18 * uint256(uint8(SYNTH_2_NOTES[n16])), 2e18) : 0;

        // Bass 1.
        bool bass1b = (uint8(BASS_1_BEATMAP[n64 >> 3]) >> (7 - (n64 & 7))) & 1 == 1;
        uint256 bass1 = bass1b ? _synth(tickWad, 1e18 * uint256(uint8(BASS_1_NOTES[n16])), 4e18) : 0; 

        // Bass 2.
        bool bass2b = (uint8(BASS_2_BEATMAP[n64 >> 3]) >> (7 - (n64 & 7))) & 1 == 1;
        uint256 bass2 = bass2b ? _synth(tickWad, 1e18 * uint256(uint8(BASS_2_NOTES[n16])), 4e18) : 0;

        // Snare.
        bool snareb;
        assembly { snareb := and(gt(n16, 58), lt(n16, 178)) }
        uint256 snarebi = snareb ? n64 - 236 : 0;
        uint256 snareb1 = (uint8(SNARE_BEATMAP[snarebi >> 3]) >> (7 - (snarebi & 7))) & 1;
        assembly { snareb := and(snareb, snareb1) }
        // ((2e11*(t/(1<<14))**2)&255)/5
        uint256 snareV = uint256(2e29).mulWad(tickWad.divWad(1e18 << 14));
        uint256 snare = snareb
            ? ((snareV.mulWad(snareV) / 1e18) & 255) / 10
            : 0;

        // Glissando.
        uint256 glissando = n16 > 165 && n16 < 174
            ? _synth(tickWad, 1e18 * uint256(uint8(SYNTH_GLISSANDO[(n64 >> 1) - 332])), 0)
            : 0;

        // Ending note.
        uint256 ending = n16 > 173 ? _synth(tickWad, 21e18, 0) : 0;

        return uint8(synth1 + synth2 + bass1 + bass2 + snare + glissando + ending);
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------


    /// @notice Returns the sound value of a note of an 8-bit synth wave with
    /// vibrato at a given time tick.
    /// @param _tickWad The time tick at which to get the sound value, as an 18
    /// decimal fixed-point value.
    /// @param _note The note to get the sound value of, where C3 is 5, and 1
    /// corresponds to a semitone, as an 18 decimal fixed-point value.
    /// @param _pitch The number of octaves to transpose the note by, as an 18
    /// decimal fixed-point value.
    /// @return The sound value of the note at the given time tick, a value in
    /// the range `[0, 15]` (higher means louder).
    function _synth(
        uint256 _tickWad,
        uint256 _note,
        int256 _pitch
    ) internal pure returns (uint8) {
        // Next, calculate the vibration and sound value of the note at the
        // given `_tickWad`.
        unchecked {
            int256 vibration = int256(_tickWad) + _sin(_tickWad.divWad(1600e18)).sMulWad(12e18);
            int256 noteSoundValue = int256(2e18).powWad(int256(_note.divWad(12e18)) - _pitch);
            int256 soundValue = int256(0.392e18).sMulWad(vibration).sMulWad(noteSoundValue);
            assembly {
                soundValue := div(soundValue, 1000000000000000000)
            }

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
            a := mod(_x, 4000000000000000000)
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
