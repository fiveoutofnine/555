// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";

import {FiveFiveFiveData} from "src/utils/FiveFiveFiveData.sol";

contract PrintDataScript is Script {
    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    function run() public {
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
