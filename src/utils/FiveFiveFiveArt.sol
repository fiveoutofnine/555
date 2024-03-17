// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Base64} from "solady/utils/Base64.sol";
import {DynamicBufferLib} from "solady/utils/DynamicBufferLib.sol";
import {LibString} from "solady/utils/LibString.sol";

import {FiveFiveFiveConstants} from "./FiveFiveFiveConstants.sol";
import {FiveFiveFiveData} from "./FiveFiveFiveData.sol";
import {IFiveFiveFive} from "src/interfaces/IFiveFiveFive.sol";

/// @title 10000km ran in 555 (1000 × ⁵⁄₉) day-streak commemorative NFT visual
/// art
/// @notice A library for generating art (SVG and HTML) and metadata for
/// {FiveFiveFive}.
/// @dev The source code for this library is intended to be viewed with
/// `Menlo, Monaco, 'Courier New', monospace`.
/// @author fiveoutofnine
library FiveFiveFiveArt {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // `render` function
    // -------------------------------------------------------------------------

    /// @notice Renders the JSON output representing the 555 token with the
    /// token's corresponding image (SVG) data, animation (HTML) data, and
    /// metadata.
    /// @param _day 0-indexed day.
    /// @param _theme The theme to use for the token.
    /// @return JSON output representing the 555 token.
    function render(
        uint256 _day,
        IFiveFiveFive.Theme memory _theme
    ) public pure returns (string memory) {
        uint256 id = _day + 1;

        // Retrieve data for the day.
        uint256 distance = FiveFiveFiveData.getDayMileage(_day);
        (string memory locationName, uint256 locationLength) = FiveFiveFiveData
            .getDayLocation(_day);
        uint256 workload = distance +
            (_day > 0 ? FiveFiveFiveData.getDayMileage(_day - 1) : 0) +
            (_day > 1 ? FiveFiveFiveData.getDayMileage(_day - 2) : 0) +
            (_day > 2 ? FiveFiveFiveData.getDayMileage(_day - 3) : 0) +
            (_day > 3 ? FiveFiveFiveData.getDayMileage(_day - 4) : 0) +
            (_day > 4 ? FiveFiveFiveData.getDayMileage(_day - 5) : 0) +
            (_day > 5 ? FiveFiveFiveData.getDayMileage(_day - 6) : 0);

        // Split distance and workload into km and m.
        (uint256 km, uint256 m) = (distance / 100, distance % 100);
        (uint256 workloadKm, uint256 workloadM) = (
            workload / 100,
            workload % 100
        );
        uint256 workloadBars = workload > 80_00 ? (workload - 80_00) / 467 : 0;

        // Generate styles.
        DynamicBufferLib.DynamicBuffer memory stylesBuffer;
        stylesBuffer.p(
            abi.encodePacked(
                FiveFiveFiveConstants.getStyleHeader(),
                uint256(_theme.terminalBackground).toHexStringNoPrefix(3),
                ";width:280px;padding:0 8px;margin:0;height:188px;display:flex;"
                "}code{font-size:12px;margin:auto}span{font-variant-ligatures:n"
                "one}.f{color:#",
                uint256(_theme.text).toHexStringNoPrefix(3),
                "}.i{color:#",
                uint256(_theme.subtext).toHexStringNoPrefix(3),
                "}.v{color:#",
                uint256(_theme.primary).toHexStringNoPrefix(3),
                "}.e{color:#",
                uint256(_theme.label).toHexStringNoPrefix(3),
                "}.o{color:#",
                uint256(_theme.intent1).toHexStringNoPrefix(3),
                "}.u{color:#",
                uint256(_theme.intent2).toHexStringNoPrefix(3),
                "}.t{color:#",
                uint256(_theme.intent3).toHexStringNoPrefix(3),
                "}.x{color:#",
                uint256(_theme.intent4).toHexStringNoPrefix(3),
                "}.y{font-family:A}.n{font-family:B}.z{position:absolute;margin"
                ":auto 0;border-radius:100%;top:6px;width:12px;height:12px}</st"
                "yle>"
            )
        );

        // Generate inner HTML.
        DynamicBufferLib.DynamicBuffer memory innerHTMLBuffer;
        innerHTMLBuffer.p(
            abi.encodePacked(
                '<div style="background:#',
                uint256(_theme.background).toHexStringNoPrefix(3),
                unicode";border-radius:8px;width:fit-content;height:fit-content"
                unicode';overflow:hidden;border:1px solid #343434"><div style="'
                unicode"position:relative;display:flex;height:24px;background:#"
                unicode'dadada;padding-left:6px;padding-right:6px"><code style='
                unicode'"font-family:C;margin:auto;color:#484848">1000 × ⁵⁄₉ = '
                unicode'555 — 36×11</code><div style="background:#ed6a5e;left:6'
                unicode'px" class="z"></div><div style="background:#f5bf4f;left'
                unicode':22px" class="z"></div><div style="background:#62c555;l'
                unicode'eft:38px" class="z"></div></div><pre><code class="y v">'
                unicode'┌─<span class="n e">day</span>─╥─<span class="n e">mile'
                unicode'age</span>─╥─<span class="n e">location</span>─────────'
                unicode"┐\n│ ",
                // 0-pad day number to 3 digits.
                id < 10
                    ? '<span class="y i">00</span>'
                    : id < 100
                        ? '<span class="y i">0</span>'
                        : "",
                '<span class="n f">',
                id.toString(),
                unicode'</span> ║ <span class="n f">',
                // 0-pad km portion of distance to 2 digits. Since the largest
                // mileage day is 50.02, we never need to pad to more.
                km < 10 ? " " : "",
                km.toString(),
                '<span class="y i">.</span>',
                // 0-pad m portion of distance to 2 digits. Since the data only
                // has granularity to the 0.01th of a kilometer, we never need
                // to pad to more.
                m < 10 ? "0" : "",
                m.toString(),
                unicode'<span class="y i">km</span></span> ║ <span class="n f">',
                locationName,
                "</span>",
                // Add spaces to align the remaining part of the frame.
                LibString.repeat(" ", 17 - locationLength),
                unicode"│\n└─────╨─────────╨──────────────────┘\n┌─<span class="
                unicode'"n e">7d<span class="y v">─</span>workload</span>──────'
                unicode"───────",
                // Pad km portion of workload to 3 digits. Since no sliding
                // window of 7 day mileage exceeds 1000 km, we never need to pad
                // to more.
                workloadKm < 100 ? unicode"─" : "",
                '<span class="n f">',
                workloadKm.toString(),
                '<span class="y i">.</span>',
                // 0-pad m portion of distance to 2 digits. Since the data only
                // has granularity to the 0.01th of a kilometer, we never need
                // to pad to more.
                workloadM < 10 ? "0" : "",
                workloadM.toString(),
                unicode'<span class="y i">km</span></span>─┐\n│ <span class="y '
                unicode'f">080 <span class="o">',
                // Construct workload gradient bars.
                getWorkloadSegment(workloadBars < 6 ? workloadBars : 6),
                '</span><span class="u">',
                workloadBars > 11 ? unicode"▮▮▮▮▮▮" : "",
                workloadBars < 7 ? '<span class="i">......</span>' : "",
                workloadBars > 6 && workloadBars < 12
                    ? getWorkloadSegment(workloadBars - 6)
                    : "",
                '</span><span class="t">',
                workloadBars > 17 ? unicode"▮▮▮▮▮▮" : "",
                workloadBars < 13 ? '<span class="i">......</span>' : "",
                workloadBars > 12 && workloadBars < 18
                    ? getWorkloadSegment(workloadBars - 12)
                    : "",
                '</span><span class="x">',
                workloadBars > 23 ? unicode"▮▮▮▮▮▮" : "",
                workloadBars < 19 ? '<span class="i">......</span>' : "",
                workloadBars > 18 && workloadBars < 24
                    ? getWorkloadSegment(workloadBars - 18)
                    : "",
                unicode"</span> 192</span> │\n└────────────────────────────────"
                unicode'──┘\n┌─<span class="n e">bytebeat</span>───────────────'
                unicode'──────────┐\n│ ► <span class="n f">gonna fly now <span '
                unicode'class="y i">from</span> rocky</span>       │\n│ <span c'
                unicode'lass="y i"><span class="n f">32</span>kHz <span class="'
                unicode'n f">31</span>.<span class="n f">25</span>kbps    [<spa'
                unicode'n class="f">0</span>:<span id="z" class="f">00</span> /'
                unicode' <span class="f">0</span>:<span class="f">25</span>]</s'
                unicode'pan> │\n│ <span class="y i"><span id="x"></span><span c'
                unicode'lass="f">━</span><span id="y">────────────────────────<'
                unicode'/span></span> <span id="E" class="y f" style="cursor:po'
                unicode"inter;background:#",
                uint256(_theme.primary).toHexStringNoPrefix(3),
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
                uint256(_theme.background).toHexStringNoPrefix(3),
                ";display:flex;width:512px;height:512px;align-items:center;just"
                'ify-content:center;" xmlns="http://www.w3.org/1999/xhtml">',
                innerHTMLBuffer.data,
                "</div></foreignObject></svg>"
            );
        }

        // Construct HTML data.
        bytes memory htmlData;
        {
            htmlData = abi.encodePacked(
                "<html><head><title>555 | Day #",
                id.toString(),
                "</title>",
                stylesBuffer.data,
                '</head><body style="width:100%;height:100%;display:flex;justif'
                "y-content:center;align-items:center;margin:0;background:#",
                uint256(_theme.background).toHexStringNoPrefix(3),
                '">',
                innerHTMLBuffer.data,
                unicode'<audio id="N">Your browser does not support the audio e'
                unicode'lement.</audio><script>h="";D="getElementById";v="repea'
                unicode't";e="charCodeAt";o=u=>1-u**2/2+u**4/24-u**6/720;T=O=>o'
                unicode'((O%4)-2)*(((O&3)>>2)-1);F=n=>n.split``.map(x=>"1"[v](('
                unicode'y=x[e](0))&63)+"0"[v](y>>6)).join``;I=n=>n.split``.map('
                unicode"x=>String.fromCharCode((y=x[e](0))&4095)[v](y>>12)).joi"
                unicode'n``;G=F(I("⁇⁃၇⁃၇⁃ぇ⁃၇⁃၇⁃ቇ၇⁃၇၃၇၃၏⁇ぃ၇ၓ၃။ၯ၃။ၯ၃။ၯ၃။ቿ⁃။⁃'
                unicode'ቛ⁃၇၃၇၃၏灇ဠူ"));H=I("쀠䀠ꀵ‹䀵쀴쀴怴္〼쀹ှ぀쀵္〼쀹ှ぀쀹怹့ဵ〷ဵ့瀹'
                unicode'䀵〴〲䀰怵");J=I("ꀵ‹䀵ꀹ‼쀹쀹ꀹ၅え큊が큅え큊が쁅恅့ဵ〷ဵ့瀹쁁⁁⁆쁅쁅聅'
                unicode'");K=F(I("ኀ⿀ၯ၏ဿ၀⁇၏⁃假၏⁃假။ぃ假။ぃ၇䁃ၛ၃၇။၇၃၇ၛ၃၇䁃၇⁃'
                unicode'䁇ဠူ"));L=I("퀠퀠耠쁀䀺耹耹‷‵䀷⁁⁂⁃‷‹‷䀹⁃⁄⁅‹‷‵〷ှ၁ှ⁂⁃‷‹‷〹၀၃၀⁄'
                unicode'၅၀္ဵ耷耹逺䁆〺‹恅쀹쀹");M=F(I("ᾀ⽀၏ဠၟ큏恏቏⁃၇၃၇၃၏ぇ၃။၇၃ဠဴ"));N'
                unicode'=I("퀠퀠퀠瀠䁆쁅䁅쁆䁆쁈䁈쁆䁆쁈䁈聊聈ꁊ큈큈쁈");O=F(`CŃŃŃ${"ʃÀʃӀ'
                unicode'ʃÀ"[v](6)}ŃŃŃŃŃŃʃÀ`);document[D]("E").addEventListener('
                unicode'"click",()=>{g=0;clearInterval(h);R=()=>{z=String(Math.'
                unicode'min(g,25));document[D]("x").innerHTML="─"[v](Math.min(g'
                unicode',24));document[D]("y").innerHTML="─"[v](Math.max(24-g,0'
                unicode'));document[D]("z").innerHTML=z.padStart(2,"0")};R();fo'
                unicode'r(s="",t=0;t<776*2**10;t++){f=(t>>10)%776;i=f>>2;E=(x,y'
                unicode"=0)=>.392*(t+12*T(t/1600))*2**(x/12-y)&32;V=(G[f]*E(J[e"
                unicode'](i)-48)+(i>15&&G[f])*E(H[e](i)-48)+(i>165)*E("579:<>@A'
                unicode'CEFGIKLN"[e]((f>>1)-332)-48)+(i>173)*E(21)+(K[f])*E(L[e'
                unicode"](i)-48,2)+M[f]*E(N[e](i)-48,2)+(i>58&&i<178&&O[f-236])"
                unicode"*((2e11*(t/(1<<14))**2)&255)/5)%256|0;s+=String.fromCha"
                unicode'rCode(V)}a=document[D]("N");a.src="data:audio/wav;base6'
                unicode"4,UklGRi4gDABXQVZFZm10IBAAAAABAAEAAH0AAAB9AAABAAgAZGF0Y"
                unicode'QAgDACA"+btoa(s);a.play();h=setInterval(()=>{g++;R()},1'
                unicode"000);})</script></body></html>"
            );
        }

        // Construct JSON.
        bytes memory jsonData;
        {
            jsonData = abi.encodePacked(
                '{"name":"555 | Day #',
                id.toString(),
                unicode'","description":"⁵⁄₉ ran ',
                km.toString(),
                ".",
                // 0-pad m portion of distance to 2 digits. Since the data only
                // has granularity to the 0.01th of a kilometer, we never need
                // to pad to more.
                m < 10 ? "0" : "",
                m.toString(),
                "km on day ",
                id.toString(),
                '.","image_data":"data:image/svg+xml;charset=utf-8;base64,',
                Base64.encode(svgData),
                '","animation_data":"data:text/html;charset=utf-8;base64,',
                Base64.encode(htmlData),
                '","attributes":[{"trait_type":"day","value":',
                id.toString(),
                '},{"trait_type":"mileage (km)","value":',
                km.toString(),
                ".",
                m.toString(),
                '},{"trait_type":"location","value":"',
                locationName,
                '"}]}'
            );
        }

        // Return token URI.
        return
            string.concat(
                "data:json/application;base64,",
                Base64.encode(jsonData)
            );
    }

    /// @notice Helper function to render each segment of the workload gradient
    /// bars.
    /// @dev Assumes `_count` is in `[0, 6]`.
    /// @param _count Number of workload gradient bars to render.
    /// @return String representing the workload gradient bars.
    function getWorkloadSegment(
        uint256 _count
    ) internal pure returns (string memory) {
        return
            string.concat(
                LibString.repeat(unicode"▮", _count),
                '<span class="i">',
                LibString.repeat(".", 6 - _count),
                "</span>"
            );
    }
}
