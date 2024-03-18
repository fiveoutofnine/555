// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";
import {Base64} from "solady/utils/Base64.sol";
import {DynamicBufferLib} from "solady/utils/DynamicBufferLib.sol";
import {LibString} from "solady/utils/LibString.sol";
import {FixedPointMathLib as Math} from "solady/utils/FixedPointMathLib.sol";

import {FiveFiveFiveAudio} from "src/utils/FiveFiveFiveAudio.sol";

/// @notice A script to create and write the WAV audio file of the arrangement of
/// "Gonna Fly Now" by Bill Conti 100% with smart contracts.
/// @dev You must run this script with a high `--memory-limit` option (e.g.
/// `50_000_000_000` works).
contract GenerateAudioOutputScript is Script {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;
    using LibString for uint256;
    using Math for int256;
    using Math for uint256;

    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice The total number of ticks for 1 cycle of the audio.
    /// @dev Note that the length of the WAV file is written into the header
    /// returned by {FiveFiveFiveAudio.getAudioWavFileHeader} to take in a
    /// maximum of `776*2**10` samples. To change this, update the header
    /// returned accordingly.
    uint256 internal constant TICKS_PER_CYCLE = 776 << 10;

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    /// @notice Calls the {FiveFiveFiveAudio} library to generate the audio data
    /// and writes the WAV file to `./output/wav/rocky.wav`.
    function run() public {
        DynamicBufferLib.DynamicBuffer memory buffer;

        // First, write the WAV file header.
        buffer.p(FiveFiveFiveAudio.getAudioWavFileHeader());

        // Next, we form the audio data by calling `getSoundValueAtSample` for
        // each sample in the range `[0, 776*2**10)` and write each result to
        // `data`.
        bytes memory data = new bytes(TICKS_PER_CYCLE);
        for (uint256 tick; tick < TICKS_PER_CYCLE; ) {
            uint8 soundValue = FiveFiveFiveAudio.getSoundValueAtSample(
                tickOffset + tick
            );
            data[tick] = bytes1(soundValue);

            unchecked {
                ++tick;
            }
        }

        buffer.p(data);
        vm.writeFile("./output/wav/rocky.wav", string(buffer.data));
    }
}
