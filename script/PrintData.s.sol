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
        for (uint256 i = 0; i < 10; ) {
            console.log(FiveFiveFiveData.getDayMileage(i));
            unchecked {
                ++i;
            }
        }
    }
}
