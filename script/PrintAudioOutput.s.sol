// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";
import {Base64} from "solady/utils/Base64.sol";
import {DynamicBufferLib} from "solady/utils/DynamicBufferLib.sol";
import {LibString} from "solady/utils/LibString.sol";
import {FixedPointMathLib as Math} from "solady/utils/FixedPointMathLib.sol";

import {FiveFiveFiveAudio} from "src/utils/FiveFiveFiveAudio.sol";

contract PrintAudioOutputScript is Script {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;
    using LibString for uint256;
    using Math for int256;
    using Math for uint256;

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    function run() public {
        DynamicBufferLib.DynamicBuffer memory buffer;

        // FirwtFirst, write the WAV file header.
        buffer.p(FiveFiveFiveAudio.getAudioWavFileHeader());

        // Next, we form the audio data by calling `getSoundValueAtSample` for
        // each sample in the range `[0, 794624]` and concatenating the result.
        uint256 tickOffset = 0 << 10;

        // Iterate through ticks `[0, 776*2**10)`, and write the sound value at
        // each tick to `data`.
        bytes memory data = new bytes(776 << 10);
        for (uint256 tick; tick < (776 << 10); ) {
            uint8 soundValue = FiveFiveFiveAudio.getSoundValueAtSample(
                tickOffset + tick
            );
            data[tick] = bytes1(soundValue);

            unchecked {
                ++tick;
            }
        }

        buffer.p(data);
        vm.writeFile("./output/wav/audio.wav", string(buffer.data));

        // Write WAV data to the buffer.
        /* buffer.p(
            abi.encodePacked(
                "data:audio/wav;base64,",
                Base64.encode(FiveFiveFiveAudio.getAudioWavFileHeader()),
                Base64.encode(data)
            )
        );
        vm.writeFile("./output/wav/audio.txt", string(buffer.data)); */
    }
}
