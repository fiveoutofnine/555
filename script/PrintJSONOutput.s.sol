// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";
import {LibString} from "solady/utils/LibString.sol";

import {IFiveFiveFive} from "src/interfaces/IFiveFiveFive.sol";
import {FiveFiveFiveArt} from "src/utils/FiveFiveFiveArt.sol";

contract PrintJSONOutputScript is Script {
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Script `run()`
    // -------------------------------------------------------------------------

    function run() public {
        for (uint256 i = 0; i < 555; ) {
            vm.writeFile(
                string.concat("./output/txt/", (i + 1).toString(), ".txt"),
                FiveFiveFiveArt.render({
                    _day: i,
                    _theme: IFiveFiveFive.Theme({
                        background: 0x000000,
                        terminalBackground: 0x161616,
                        primary: 0x0090ff,
                        text: 0xededed,
                        subtext: 0xa0a0a0,
                        label: 0xff8b3e,
                        intent1: 0x4cc38a,
                        intent2: 0xf0c000,
                        intent3: 0xff8b3e,
                        intent4: 0xff6369,
                        modified: false
                    })
                })
            );

            unchecked {
                ++i;
            }
        }
    }
}
