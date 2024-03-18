// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";

import {FiveFiveFiveData} from "src/utils/FiveFiveFiveData.sol";

/// @notice A testing script to use during development to print out the mileage
/// and location data for each run from {FiveFiveFiveData}.
contract PrintDataScript is Script {
    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    /// @notice Calls {FiveFiveFiveArt} and retrieves data for a range of days.
    function run() public view {
        for (uint256 i = 325; i < 336; ) {
            uint256 mileage = FiveFiveFiveData.getDayMileage(i);
            (string memory location, ) = FiveFiveFiveData.getDayLocation(i);
            console.log(i, mileage, location);

            unchecked {
                ++i;
            }
        }
    }
}
