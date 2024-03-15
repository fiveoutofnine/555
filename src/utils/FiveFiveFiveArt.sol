// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Base64} from "solady/utils/Base64.sol";
import {DynamicBufferLib} from "solady/utils/DynamicBufferLib.sol";
import {LibString} from "solady/utils/LibString.sol";

import {FiveFiveFiveData} from "./FiveFiveFiveData.sol";

/// @title 10000km ran in 555 (1000 × ⁵⁄₉) day-streak commemorative NFT visual
/// art.
/// @notice A library for generating SVG and HTML output for {FiveFiveFive}.
library FiveFiveFiveArt {
    using DynamicBufferLib for DynamicBufferLib.DynamicBuffer;
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice Starting string for the `<style>` tag in the inner HTML.
    string internal constant STYLE_HEADER =
        "<style>@font-face{font-family:A;src:url(data:font/woff2;utf-8;base64,d"
        "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)}@font-face{font"
        "-family:B;src:url(data:font/woff2;utf-8;base64,d09GMgABAAAAAA+EABAAAAA"
        "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"
        "ut1Am+rE9pexd/ibebVAAAA)}@font-face{font-family:C;src:url(data:font/wo"
        "ff2;utf-8;base64,d09GMgABAAAAAAsAABAAAAAAFwQAAAqhAAEAAAAAAAAAAAAAAAAAA"
        "AAAAAAAAAAAGhQbgw4cjGgGYD9TVEFURAB8EQgKkkiPPQtUAAE2AiQDgSQEIAWDXgcgDAc"
        "bERRRVJKGSvYjIXPTUzMucYqgtV7UxLFlh6jJvOaDeP77sfTc95eSlACFK0vWAKRQqBpZI"
        "atQWELX8ei6uaJN9/4fe4g5pUTcWic0IR+aESXxJ+JfM0nVaUrVsTpJxaz/AXIV3rf2amd"
        "ymYAElIDCxGcDQkW4GLP4/tsAbWEvW6brldBdvqpQaSSpRlYxqqpWsquvMECqRla5WkG6G"
        "tYWE0QHsSKWCksp4j17vO8tCDABgLCBIAgY5SYEtmvPEBmYXjreTIMpAvBNcfTF0400cIG"
        "1OgSsHkNyGRSElYXlJOIWNTVuCLOCHffaBxykvor4C28nryosIBgcF8mUDVt27DlwJNSHS"
        "F9iGA4EIWAwLHgVuWUIWYbYBDZhGCBh2rOwcUAAosuRTjcLDPDS5wbVoGOeRB98NCqjz/r"
        "9iZPHa5vB8RStrAPxP2J4weBxpaWuEVKAcATCAZgAFAIbF0nAlDlL1myBsBeBzi1TRrgBT"
        "0FvaQj0Qgm24poP11iiGlDNNaXW1ZXu1u6ZGqP3B8IGggsH0vWBQkFAaNocFk3i6oyW6Hy"
        "B5zAGxcrqbtchskwGMWX1dxzESqc4vcoa2bUAO3Jx1Moam1WPkzBxVihr4pxBuDEVB63Km"
        "jyfC55nMihRxtRFtx9IKhl005XToYxGsFwN5zgXPaqQhHCZedV2EAgwE56xo8ItxIbN3pz"
        "ViGmcrRhLbBqbs4C1qm9E2N7CmVhMz/Fo1KSQECigDMwexDLkOLCMB5aIurgaZD2TgN+pG"
        "ZjHOf2pWZrPSZBrgfwO4kiUaDfNKvtd8cyvmMcrKSlIc2ZkU07lS3ExUUXUkCqrUbWodsO"
        "hbIDqBhBgARxWozIPqm4gwEI4vKqrOqOg2goEWAQHUgugVELA4i0/DjZyoZSWeBou64tOi"
        "tJSL0eIrLn4MVrmk7Cg4WJNaXnaA5Znfm3TCm8JL6/PLc+0cOWa/EGIqAWVG4xW+SdYUAg"
        "bHKa02l/ChoG4g4rTmi074aHhjCO01i9BqMqVqHZ4HfNjsCBqkOTIKK335dhQAA8nhtMGP"
        "wgHBkA6EDlmb4Rwn/WdOEh8OMQIJchcFJgPhznjCkFhdAU3xbidA3tQkR0dxM2D6Pp2voN"
        "ZdKW45WTMGFMghnkAWyNcrVKleogaJgFsU6TsJtkuIUFptL0sQoKdpRQRwA4NQsLczTbj8"
        "4KdEIwnLxgEYYEcGCR/l5A/G8PGo2UC+CBZRzzLrVtU1pGehIfoB+QLFuiv6i0D3pj69pm"
        "6vQOF1QAU4iFoQABw8NDQLFATL5m6rv9yMPq0uoAAeriAJQTQuQQwowMrLnT3bGUzMgO4e"
        "YlGwhxCkJ86QObmC9AgWOwA4/8ACmjADDgEzECoBGYxh2MTCxYqQjz9EmtxmrhFPBUsESR"
        "UOPtO9MdvuuG6y0J+fHp089HiHxMhfR8o2JmMaC0evPMyUMdAew/cAx5KvYI4WIHhGgQEW"
        "zNc108rayrdp26Lfocpk7hhK10siIu7LjUVCLgBy/ua9J1EGI5nu8EOXe9dfPy9x/zpPXe"
        "wcQZj7vR7+Ni7OnKaQT7ujpbpEDBkGV7RMa1XR5lowX226PVorM61nESLLdM0GpmgKvf3W"
        "plWPGjvTJcYjOGnVC5OTdNISxgrzDyPf1sfpj1AJ1Or6npttkCXNPD1emcJjMnmHuNCGhi"
        "j1TJYJ87gE2g/f4zpzOlop5js9e3TdDqKn1ZUxH6Hx1GFFmAq559oJbVaGKPRMEZVz9SQn"
        "kPkagqN1euzp6USZEzvsnX1umnP8PHP+dOfYuOeUBGl7WgTDlmESvncugPgWsWXk+i4m8S"
        "kXp9wiQxqeevODfwYZtK+TofG3tuYzCbX6Wrg62259GMa57K5DmuoiEp314Jop4DhtzNn3"
        "HtMD5mtDLKA9tGDRxld3kDG9z13JEP36qXfX7/O+LFXNzRjj8H8A78mb7xaOOZ/ddG5g1O"
        "vv14Mo6C66Ox+iHsBwIUIYF8SvEz0+jdUlFF4LWXm0T/sTTGsXHrCvv50x9GsqkWlFZUrL"
        "gyftePPjsbtw4rnlRbKZizLqCrbPqBmEp7vS2w8+jt0puqsaMmKv7AItqnfr/YyvywysuA"
        "kdKn46UsgYo5Q5TNnz1/WOj9y/O0tC1oP1laeYEbWnFYpOyD/WOJ8R29OGLecp0iKExw5N"
        "7TxmNuerhA4B+f2RybshWgQTkHcQv2jMR1OgurVF0V9Fu495DR791+7tcGi0YfWLuj5NRn"
        "yzMKoZZ3qlJq94u3bAs+c2R2feFjHaj3SVHO6o7Xy5MGGluGLUhvakpZRTdWnj7bCbvwxv"
        "hsAB8v5eo7UHMRZVsqhIF8ztf+TkarjjcSo/sbjKpXwFe5TtmAPG9kK60C+VkanqPA/RgX"
        "upR8m385j1qPqj8TA0cWldTNHlSrmja5Lagq06/VMnyC8mOGZypPMiKU61eX0/tYRTPf9W"
        "nD36ik7mjR/puzJxsX9vk7dcTpvxPgLBe0bBOWfLQa3DcmeMf/BCZ7vsCMF9a0qRd2eJqa"
        "z+17dAvWA+thkRVLBjFG1A5oTksu88JJZoyDGrgf5CniYh7EHefBMkI+xu368SnVg/LF65"
        "cSjB49NOA7KHB5vR4/dgd4k8DSbeCW7aSEUvjFhJHkFjCwxZbyULu8qz++UJMZXSilZa0a"
        "fHpTfMPdkFtN5TFo5LSdvbGelCW+i2awpZfktc69lQh+zkWoZvRAreoyntWZmFo2qoXLG1"
        "hZHVvof0HjFJhlUtq5Clv+EqIyaHfLyVZXKhu0XiyHELG9rzKTRkivzdjdzDHOX7np63Hz"
        "q8/vlKYNGjVNv4rkN2k6V1nblFq8sq1VuvVAyeV/BaGWmdHRtXoIiJIaywqQdSnCeIMs/A"
        "AzFXW3nLd3b220+5cqKlMGjx57cyPMYtJkqLyH9IEUT9sWXhMZQkZIRdGGaIjo8x7cOzNa"
        "Dci68H80A2y9wV86yy/gP1el2fvyh+nDkM1ptog66WXrC5ASwOcAGgFUGTEp/rQGz0n9by"
        "ZwsyJKsrHNo4U5HANMAs1JcTeZkQZYFVs8ZczD8x3OAdn8MiMeqhnM6uW0s+XBeR1S/5A2"
        "3FlWvFA+Xtc/rlhb7SJC60Mf6Z+f48WO5F1rSXowNpKykffADGWDXzczlNXVRA4DjbXf7X"
        "LK0sY8EjoqQ12kNAa3zYJHfXV7h5Li/XKcxAHz9dWw+4NsRqe678c+IBdUCAHowgIC/NWM"
        "LHzpKvnzRemr/6daOuYXNcbK6G2pd39ax3i2Xev9sHAMwqusfiveIwBxFrDOy061KHqaVv"
        "InkdYYp7oSjO4NRpYVzG/7vAJ+2KjvZcfUK5Cf4a764BQTqcc7/CbsQMGYaHOrwADwBls2"
        "IvTnNGFNdzbgAB7OEu5klwpMmNvs47ofMQJAQaTZHJiFjF88jB3j8AVIp1evQqEqFSs3EQ"
        "gSNYjHZFiouPhCtmUIjMammlaoplAbGyVo0rqRk7ZuIeankuHy9JjECBapQ5bxYixIBSin"
        "VQSKu04TRqshTvZMkh1IoU6XJOpkUKiSuVcw/b6gAQYJFi5Upy1BZYot19gdKJTp3FSWaW"
        "PV5fc/8BSkWLliQCApBSiJBTu4+DWadiww5zelw/f6GW6jt/Sz/J+7uzAQAAAA=)}pre{f"
        "ont-family:A;background:#161616;width:280px;padding:0 8px;margin:0;hei"
        "ght:188px;display:flex;}code{font-size:12px;margin:auto}";

    // -------------------------------------------------------------------------
    // `render` function
    // -------------------------------------------------------------------------

    /// @notice Renders the JSON output representing the 555 token with the
    /// token's corresponding image (SVG) data, animation (HTML) data, and
    /// metadata.
    /// @param _day 0-indexed day.
    /// @return JSON output representing the 555 token.
    function render(uint256 _day) internal pure returns (string memory) {
        uint256 id = _day + 1;
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

        uint24 BACKGROUND_COLOR = 0x000000;
        uint24 TEXT_COLOR = 0xededed;
        uint24 SUBTEXT_COLOR = 0xa0a0a0;
        uint24 PRIMARY_COLOR = 0x0090ff;
        uint24 INTENT_ONE_COLOR = 0x4cc38a;
        uint24 INTENT_TWO_COLOR = 0xf0c000;
        uint24 INTENT_THREE_COLOR = 0xff8b3e;
        uint24 INTENT_FOUR_COLOR = 0xff6369;
        uint24 LABEL_COLOR = 0xff8b3e;

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
                STYLE_HEADER,
                ".f{color:#",
                uint256(TEXT_COLOR).toHexStringNoPrefix(3),
                "}.i{color:#",
                uint256(SUBTEXT_COLOR).toHexStringNoPrefix(3),
                "}.v{color:#",
                uint256(PRIMARY_COLOR).toHexStringNoPrefix(3),
                "}.e{color:#", // e
                uint256(LABEL_COLOR).toHexStringNoPrefix(3),
                "}.o{color:#",
                uint256(INTENT_ONE_COLOR).toHexStringNoPrefix(3),
                "}.u{color:#",
                uint256(INTENT_TWO_COLOR).toHexStringNoPrefix(3),
                "}.t{color:#",
                uint256(INTENT_THREE_COLOR).toHexStringNoPrefix(3),
                "}.O{color:#",
                uint256(INTENT_FOUR_COLOR).toHexStringNoPrefix(3),
                "}.F{font-family:A}.n{font-family:B}.I{position:absolute;margin"
                ":auto 0;border-radius:100%;top:6px;width:12px;height:12px}</st"
                "yle>"
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
                unicode'dadada;padding-left:6px;padding-right:6px"><code style='
                unicode'"font-family:C;margin:auto;color:#484848">1000 × ⁵⁄₉ = '
                unicode'555 — 36×11</code><div style="background:#ed6a5e;left:6'
                unicode'px" class="I"></div><div style="background:#f5bf4f;left'
                unicode':22px" class="I"></div><div style="background:#62c555;l'
                unicode'eft:38px" class="I"></div></div><pre><code class="F v">'
                unicode'┌─<span class="n e">day</span>─╥─<span class="n e">mile'
                unicode'age</span>─╥─<span class="n e">location</span>─────────'
                unicode"┐\n│ ",
                id < 10
                    ? '<span class="F i">00</span>'
                    : id < 100
                        ? '<span class="F i">0</span>'
                        : "",
                '<span class="n f">',
                id.toString(),
                unicode'</span> ║ <span class="n f">',
                km < 10 ? " " : "",
                km.toString(),
                '<span class="F i">.</span>',
                m < 10 ? "0" : "",
                m.toString(),
                unicode'<span class="F i">km</span></span> ║ <span class="n f">',
                locationName,
                "</span>",
                LibString.repeat(" ", 17 - locationLength),
                unicode"│\n└─────╨─────────╨──────────────────┘\n┌─<span class="
                unicode'"n e">7d<span class="F v">─</span>workload</span>──────'
                unicode"───────",
                workloadKm < 100 ? unicode"─" : "",
                '<span class="n f">',
                workloadKm.toString(),
                '<span class="F i">.</span>',
                workloadM < 10 ? "0" : "",
                workloadM.toString(),
                unicode'<span class="F i">km</span></span>─┐\n│ <span class="F '
                unicode'f">080 <span class="o">',
                getWorkloadSegment(workloadBars < 6 ? workloadBars : 6),
                '</span><span class="u">',
                workloadBars > 11 ? unicode"▮▮▮▮▮▮" : "",
                workloadBars < 7 ? unicode"______" : "",
                workloadBars > 6 && workloadBars < 12
                    ? getWorkloadSegment(workloadBars - 6)
                    : "",
                '</span><span class="t">',
                workloadBars > 17 ? unicode"▮▮▮▮▮▮" : "",
                workloadBars < 13 ? unicode"______" : "",
                workloadBars > 12 && workloadBars < 18
                    ? getWorkloadSegment(workloadBars - 12)
                    : "",
                '</span><span class="O">',
                workloadBars > 23 ? unicode"▮▮▮▮▮▮" : "",
                workloadBars < 19 ? unicode"______" : "",
                workloadBars > 18 && workloadBars < 24
                    ? getWorkloadSegment(workloadBars - 18)
                    : "",
                unicode"</span> 192</span> │\n└────────────────────────────────"
                unicode'──┘\n┌─<span class="n e">bytebeat</span>───────────────'
                unicode'──────────┐\n│ ► <span class="n f">gonna fly now <span '
                unicode'class="F i">from</span> rocky</span>       │\n│ <span c'
                unicode'lass="F i"><span class="n f">32</span>kHz <span class="'
                unicode'i f">31</span>.<span class="n f">25</span>kbps    [<spa'
                unicode'n class="f">0</span>:<span class="f">00</span> / <span '
                unicode'class="f">0</span>:<span class="f">25</span>]</span> │',
                unicode'\n│ <span class="F i"><span class="f">━</span>─────────'
                unicode'───────────────</span> <span class="F f" id="i" style="'
                unicode"background:#",
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
                uint256(BACKGROUND_COLOR).toHexStringNoPrefix(3),
                '">',
                innerHTMLBuffer.data,
                unicode'<audio id="f">Your browser does not support the audio e'
                unicode"lement.</audio><script>g=0;v='repeat';e='charCodeAt';o="
                unicode"u=>1-u**2/2+u**4/24-u**6/720;T=O=>o((O%4)-2)*(((O&3)>>2"
                unicode')-1);F=n=>n.split``.map(x=>"1"[v]((y=x[e](0))&63)+"0"[v'
                unicode"](y>>6)).join``;I=n=>n.split``.map(x=>String.fromCharCo"
                unicode'de((y=x[e](0))&4095)[v](y>>12)).join``;G=F(I("⁇⁃၇⁃၇⁃ぇ⁃'
                unicode'၇⁃၇⁃ቇ၇⁃၇၃၇၃၏⁇ぃ၇ၓ၃။ၯ၃။ၯ၃။ၯ၃။ቿ⁃။⁃ቛ⁃၇၃၇၃၏灇ဠူ"));H=I('
                unicode'"쀠䀠ꀵ‹䀵쀴쀴怴္〼쀹ှ぀쀵္〼쀹ှ぀쀹怹့ဵ〷ဵ့瀹䀵〴〲䀰怵");J=I("ꀵ‹䀵'
                unicode'ꀹ‼쀹쀹ꀹ၅え큊が큅え큊が쁅恅့ဵ〷ဵ့瀹쁁⁁⁆쁅쁅聅");K=F(I("ኀ⿀ၯ၏ဿ'
                unicode'၀⁇၏⁃假၏⁃假။ぃ假။ぃ၇䁃ၛ၃၇။၇၃၇ၛ၃၇䁃၇⁃䁇ဠူ"));L=I("퀠퀠耠쁀䀺'
                unicode'耹耹‷‵䀷⁁⁂⁃‷‹‷䀹⁃⁄⁅‹‷‵〷ှ၁ှ⁂⁃‷‹‷〹၀၃၀⁄၅၀္ဵ耷耹逺䁆〺‹恅쀹쀹");'
                unicode'M=F(I("ᾀ⽀၏ဠၟ큏恏቏⁃၇၃၇၃၏ぇ၃။၇၃ဠဴ"));N=I("퀠퀠퀠瀠䁆쁅䁅쁆䁆쁈'
                unicode'䁈쁆䁆쁈䁈聊聈ꁊ큈큈쁈");O=F(`CŃŃŃ${"ʃÀʃӀʃÀ"[v](6)}ŃŃŃŃŃŃʃÀ`)'
                unicode';document.getElementById("i").addEventListener("click",'
                unicode'()=>{for(s="",t=0;t<776*2**10;t++){f=(t>>10)%776;i=f>>2'
                unicode";E=(x,y=0)=>.392*(t+12*T(t/1600))*2**(x/12-y)&32;V=(G[f"
                unicode']*E(J[e](i)-48)+(i>15&&G[f])*E(H[e](i)-48)+(i>165)*E("5'
                unicode'79:<>@ACEFGIKLN"[e]((f>>1)-332)-48)+(i>173)*E(21)+(K[f]'
                unicode")*E(L[e](i)-48,2)+M[f]*E(N[e](i)-48,2)+(i>58&&i<178&&O["
                unicode"f-236])*((2e11*(t/(1<<14))**2)&255)/5)%256|0;s+=String."
                unicode'fromCharCode(V)}a=document.getElementById("f");a.src="d'
                unicode"ata:audio/wav;base64,UklGRi4gDABXQVZFZm10IBAAAAABAAEAAH"
                unicode'0AAAB9AAABAAgAZGF0YQAgDACA"+btoa(s);a.play()})</script>'
                unicode"</body></html>"
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
                m < 10 ? "0" : "",
                m.toString(),
                "km on day ",
                id.toString(),
                '.","image_data":"data:image/svg+xml;charset=utf-8;base64,',
                Base64.encode(svgData),
                '","animation_data":"data:text/html;charset=utf-8;base64,',
                Base64.encode(htmlData),
                '"}'
            );
        }
        return string(svgData);

        /* return
            string.concat(
                "data:json/application;base64,",
                Base64.encode(jsonData)
            ); */
    }

    function getWorkloadSegment(
        uint256 _count
    ) internal pure returns (string memory) {
        return
            string.concat(
                LibString.repeat(unicode"▮", _count),
                LibString.repeat(unicode"_", 6 - _count)
            );
    }
}
