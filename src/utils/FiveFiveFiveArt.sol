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

    // -------------------------------------------------------------------------
    // `render` function
    // -------------------------------------------------------------------------

    /// @notice Renders the JSON output representing the 555 token with the
    /// token's corresponding image (SVG) data, animation (HTML) data, and
    /// metadata.
    /// @param _id ID of the token.
    /// @return JSON output representing the 555 token.
    function render(uint256 _id) internal pure returns (string memory) {
        uint256 DISTANCE = 21_10;
        uint256 WORKLOAD = 144_85;
        uint24 BACKGROUND_COLOR = 0x000000;
        uint24 TEXT_COLOR = 0xededed;
        uint24 SUBTEXT_COLOR = 0xa0a0a0;
        uint24 PRIMARY_COLOR = 0x0090ff;
        uint24 INTENT_ONE_COLOR = 0x4cc38a;
        uint24 INTENT_TWO_COLOR = 0xf0c000;
        uint24 INTENT_THREE_COLOR = 0xff8b3e;
        uint24 INTENT_FOUR_COLOR = 0xff6369;
        uint24 LABEL_COLOR = 0xff8b3e;

        (uint256 km, uint256 m) = (DISTANCE / 100, DISTANCE % 100);
        (uint256 workloadKm, uint256 workloadM) = (
            WORKLOAD / 100,
            WORKLOAD % 100
        );
        uint256 workload = (WORKLOAD - 80_00) / 467;

        // Generate styles.
        DynamicBufferLib.DynamicBuffer memory stylesBuffer;
        stylesBuffer.p(
            abi.encodePacked(
                '<style>pre{font-family:"Fira Code",monospace;background:#161616;width:280px;padding:0 8px;height:188px;display:flex;}code{font-size:12px;margin:auto}.a{color:#',
                uint256(TEXT_COLOR).toHexStringNoPrefix(3),
                "}.b{color:#",
                uint256(SUBTEXT_COLOR).toHexStringNoPrefix(3),
                "}.c{color:#",
                uint256(PRIMARY_COLOR).toHexStringNoPrefix(3),
                "}.d{color:#",
                uint256(INTENT_ONE_COLOR).toHexStringNoPrefix(3),
                "}.e{color:#",
                uint256(INTENT_TWO_COLOR).toHexStringNoPrefix(3),
                "}.f{color:#",
                uint256(INTENT_THREE_COLOR).toHexStringNoPrefix(3),
                "}.g{color:#",
                uint256(INTENT_FOUR_COLOR).toHexStringNoPrefix(3),
                "}.h{font-weight:400}.i{font-weight:600}.j{position:absolute;margin:auto 0;border-radius:100%;top:6px;width:12px;height:12px}</style>"
            )
        );

        // Generate inner HTML.
        DynamicBufferLib.DynamicBuffer memory innerHTMLBuffer;
        innerHTMLBuffer.p(
            abi.encodePacked(
                '<div style="background:#',
                uint256(BACKGROUND_COLOR).toHexStringNoPrefix(3),
                unicode";border-radius:8px;width:fit-content;height:fit-content"
                unicode';overflow:hidden;border:1px solid #343434"><div style="'
                unicode"position:relative;display:flex;height:24px;background:#"
                unicode'dadada;padding-left:6px;padding-right:6px"><code class='
                unicode'"i" style="margin:auto;color:#484848">1000 × ⁵⁄₉ = 555 '
                unicode'— 36×11</code><div style="background:#ed6a5e;left:6px" '
                unicode'class="j"></div><div style="background:#f5bf4f;left:22p'
                unicode'x" class="j"></div><div style="background:#62c555;left:'
                unicode'38px" class="j"></div></div><pre><code class="h c">┌─<s'
                unicode'pan class="i e">day</span>─╥─<span class="i e">mileage<'
                unicode'/span>─╥─<span class="i e">location</span>─────────┐\n│'
                unicode" ",
                _id < 10
                    ? '<span class="h b">00</span>'
                    : _id < 100
                        ? '<span class="h b">0</span>'
                        : "",
                '<span class="i a">',
                _id.toString(),
                unicode'</span> ║ <span class="i a">',
                km < 10 ? " " : "",
                km.toString(),
                '<span class="h b">.</span>',
                m < 10 ? "0" : "",
                m.toString(),
                unicode'<span class="h b">km</span></span> ║ <span class="i a">',
                "montenegro", // TODO
                unicode"</span>       │\n└─────╨─────────╨──────────────────┘\n"
                unicode'┌─<span class="i e">7d<span class="h c">─</span>workloa'
                unicode'd</span>─────────────<span class="i a">',
                workloadKm < 100 ? unicode"─" : "",
                workloadKm.toString(),
                '<span class="h b">.</span>',
                workloadM < 10 ? "0" : "",
                workloadM.toString(),
                unicode'<span class="h b">km</span></span>─┐\n│ <span class="h '
                unicode'a">080 <span class="d">',
                // TODO
                unicode'▮▮▮▮▮▮</span><span class="e">▮▮▮▮▮▮</span><span class="f">▮▮▮▮▮.</span><span class="g">......',
                unicode"</span> 192</span> │\n└────────────────────────────────"
                unicode'──┘\n┌─<span class="i e">bytebeat</span>───────────────'
                unicode'──────────┐\n│ ► <span class="i a">gonna fly now <span '
                unicode'class="h b">from</span> rocky</span>       │\n│ <span c'
                unicode'lass="h b"><span class="i a">32</span>kHz <span class="'
                unicode'i a">31</span>.<span class="i a">25</span>kbps    [<spa'
                unicode'n class="a">0</span>:<span class="a">01</span> / <span '
                unicode'class="a">0</span>:<span class="a">25</span>]</span> │',
                unicode'\n│ <span class="h b">─<span class="a">━</span>────────'
                unicode'───────────────</span> <span class="h a" style="backgro'
                unicode"und:#",
                uint256(PRIMARY_COLOR).toHexStringNoPrefix(3),
                unicode'">[PLAY]</span> │\n└──────────────────────────────────┘'
                unicode"</code></pre></div>"
            )
        );

        // Construct SVG data.
        bytes memory svgData;
        {
            svgData = abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" width="512" height="51'
                '2" viewBox="0 0 512 512" fill="none"><foreignObject width="512'
                '" height="512">',
                stylesBuffer.data,
                '<div style="background:#',
                uint256(BACKGROUND_COLOR).toHexStringNoPrefix(3),
                ";display:flex;width:512px;height:512px;align-items:center;just"
                'ify-content:center;">',
                innerHTMLBuffer.data,
                "</div></foreignObject></svg>"
            );
        }

        // Construct HTML data.
        bytes memory htmlData;
        {
            htmlData = abi.encodePacked(
                "<html><head><title>555 | Day #",
                _id.toString(),
                "</title>",
                stylesBuffer.data,
                '</head><body style="width:100%;height:100%;display:flex;justif'
                "y-content:center;align-items:center;background:#",
                uint256(BACKGROUND_COLOR).toHexStringNoPrefix(3),
                '">',
                innerHTMLBuffer.data,
                unicode'<audio id="a">Your browser does not support the audio e'
                unicode"lement.</audio><script>g=0;v='repeat';e='charCodeAt';o="
                unicode'u=>1-u**2/2+u**4/24-u**6/720;T=O=>o((O%4)-2)*(((O&3)>>2)-1);F=n=>n.split``.map(x=>"1"[v]((y=x[e](0))&63)+"0"[v](y>>6)).join``;I=n=>n.split``.map(x=>String.fromCharCode((y=x[e](0))&4095)[v](y>>12)).join``;G=F(I("⁇⁃၇⁃၇⁃ぇ⁃၇⁃၇⁃ቇ၇⁃၇၃၇၃၏⁇ぃ၇ၓ၃။ၯ၃။ၯ၃။ၯ၃။ቿ⁃။⁃ቛ⁃၇၃၇၃၏灇ဠူ"));H=I("쀠䀠ꀵ‹䀵쀴쀴怴္〼쀹ှ぀쀵္〼쀹ှ぀쀹怹့ဵ〷ဵ့瀹䀵〴〲䀰怵");J=I("ꀵ‹䀵ꀹ‼쀹쀹ꀹ၅え큊が큅え큊が쁅恅့ဵ〷ဵ့瀹쁁⁁⁆쁅쁅聅");K=F(I("ኀ⿀ၯ၏ဿ၀⁇၏⁃假၏⁃假။ぃ假။ぃ၇䁃ၛ၃၇။၇၃၇ၛ၃၇䁃၇⁃䁇ဠူ"));L=I("퀠퀠耠쁀䀺耹耹‷‵䀷⁁⁂⁃‷‹‷䀹⁃⁄⁅‹‷‵〷ှ၁ှ⁂⁃‷‹‷〹၀၃၀⁄၅၀္ဵ耷耹逺䁆〺‹恅쀹쀹");M=F(I("ᾀ⽀၏ဠၟ큏恏቏⁃၇၃၇၃၏ぇ၃။၇၃ဠဴ"));N=I("퀠퀠퀠瀠䁆쁅䁅쁆䁆쁈䁈쁆䁆쁈䁈聊聈ꁊ큈큈쁈");O=F(`CŃŃŃ${"ʃÀʃӀʃÀ"[v](6)}ŃŃŃŃŃŃʃÀ`);document.getElementById("b").addEventListener("click",()=>{for(s="",t=0;t<776*2**10;t++){f=(t>>10)%776;i=f>>2;E=(x,y=0)=>.392*(t+12*T(t/1600))*2**(x/12-y)&32;V=(G[f]*E(J[e](i)-48)+(i>15&&G[f])*E(H[e](i)-48)+(i>165)*E("579:<>@ACEFGIKLN"[e]((f>>1)-332)-48)+(i>173)*E(21)+(K[f])*E(L[e](i)-48,2)+M[f]*E(N[e](i)-48,2)+(i>58&&i<178&&O[f-236])*((2e11*(t/(1<<14))**2)&255)/5)%256|0;s+=String.fromCharCode(V)}a=document.getElementById("a");a.src="data:audio/wav;base64,UklGRi4gDABXQVZFZm10IBAAAAABAAEAAH0AAAB9AAABAAgAZGF0YQAgDACA"+btoa(s);a.play()})</script></body></html>'
            );
        }

        // Construct JSON.
        bytes memory jsonData;
        {
            jsonData = abi.encodePacked(
                '{"name":"555 | Day #',
                _id.toString(),
                unicode'","description":"⁵⁄₉ ran ',
                km.toString(),
                ".",
                m < 10 ? "0" : "",
                m.toString(),
                "km on day ",
                _id.toString(),
                '.","image_data":"data:image/svg+xml;charset=utf-8;base64,',
                Base64.encode(svgData),
                '","animation_data":"data:text/html;charset=utf-8;base64,',
                Base64.encode(htmlData),
                '"}'
            );
        }

        return
            string.concat(
                "data:json/application;base64,",
                Base64.encode(jsonData)
            );
    }
}
