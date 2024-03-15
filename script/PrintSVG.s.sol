// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";
import {LibString} from "solady/utils/LibString.sol";

import {FiveFiveFiveArt} from "src/utils/FiveFiveFiveArt.sol";

contract PrintDataScript is Script {
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    function run() public {
        for (uint256 i = 1; i < 2; ) {
            vm.writeFile(
                string.concat("./output/txt/", i.toString(), ".txt"),
                FiveFiveFiveArt.render(i)
            );

            unchecked {
                ++i;
            }
        }
    }
}
