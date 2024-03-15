// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Base64} from "solady/utils/Base64.sol";
import {DynamicBufferLib} from "solady/utils/DynamicBufferLib.sol";
import {LibString} from "solady/utils/LibString.sol";

/// @title 10000km ran in 555 (1000 × ⁵⁄₉) day-streak commemorative NFT visual
/// art.
/// @notice A library for generating SVG and HTML output for {FiveFiveFive}.
library FiveFiveFiveArt {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;
    using LibString for uint256;

    string constant STYLES =
        '<style>pre{font-family:"Fira Code",monospace;background:#161616;width:280px;padding:0 8px;height:188px;display:flex;}code{font-size:12px;margin:auto}.a{color:#ededed}.b{color:#a0a0a0}.c{color:#0090ff}.d{color:#ff6369}.e{color:#ff8b3e}.f{color:#f0c000}.g{color:#4CC38A}.h{font-weight:400}.i{font-weight:600}.j{position:absolute;margin:auto 0;border-radius:100%;top:6px;width:12px;height:12px}</style>';

    // -------------------------------------------------------------------------
    // `render` function
    // -------------------------------------------------------------------------

    /// @notice Renders the JSON output representing the 555 token with the
    /// token's corresponding image (SVG) data, animation (HTML) data, and
    /// metadata.
    /// @param _id ID of the token.
    /// @return JSON output representing the 555 token.
    function render(uint256 _id) internal pure returns (string memory) {
        // Construct JSON.
        bytes memory jsonData;
        {
            jsonData = abi.encodePacked(
                '{"name":"555 | Day #',
                _id.toString(),
                '"}'
            );
        }

        return
            string.concat(
                "data:json/application;charset=utf-8;base64,",
                Base64.encode(jsonData)
            );
    }

    function _getInnerHTML(uint256 _id) internal pure returns (string memory) {
        return
            unicode'<div style="background:#000;border-radius:8px;width:fit-content;height:fit-content;overflow:hidden;border:1px solid #343434"><div style="position:relative;display:flex;height:24px;background:#dadada;padding-left:6px;padding-right:6px"><code class="i" style="margin:auto;color:#484848">1000 × ⁵⁄₉ = 555 — 36×11</code><div style="background:#ed6a5e;left:6px" class="j"></div><div style="background:#f5bf4f;left:22px" class="j"></div><div style="background:#62c555;left:38px" class="j"></div></div><pre><code class="h c">┌─<span class="i e">day</span>─╥─<span class="i e">mileage</span>─╥─<span class="i e">location</span>─────────┐\n│ <span class="h b">0</span><span class="i a">27</span> ║ <span class="i a">21<span class="h b">.</span>10<span class="h b">km</span></span> ║ <span class="i a">montenegro</span>       │\n└─────╨─────────╨──────────────────┘\n┌─<span class="i e">7d<span class="h c">─</span>workload</span>─────────────<span class="i a">144<span class="h b">.</span>85<span class="h b">km</span></span>─┐\n│ <span class="h a">100 <span class="d">▮▮▮▮▮▮</span><span class="e">▮▮▮▮▮▮</span><span class="f">▮▮▮▮▮.</span><span class="g">......</span> 200</span> │\n└──────────────────────────────────┘\n┌─<span class="i e">bytebeat</span>─────────────────────────┐\n│ ► <span class="i a">gonna fly now <span class="h b">from</span> rocky</span>       │\n│ <span class="h b"><span class="i a">32</span>kHz <span class="i a">31</span>.<span class="i a">25</span>kbps    [<span class="a">0</span>:<span class="a">01</span> / <span class="a">0</span>:<span class="a">25</span>]</span> │\n│ <span class="h b">─<span class="a">━</span>───────────────────────</span> <span class="h a" style="background:#0090ff">[PLAY]</span> │\n└──────────────────────────────────┘</code></pre></div>';
    }
}
