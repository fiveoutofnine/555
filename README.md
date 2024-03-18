<img align="right" width="150" height="150" top="100" src="./assets/555-day-204.webp">

# 555 (1000 × ⁵⁄₉) NFTs

A ⁵⁄₉-themed NFT to commemorate me running 10000km in 555 days of running everyday. For each token, in addition to displaying information about the day's run with a themeable color palette, the metadata of each token contains a 100% onchain-generated 24.832 second long audio of a 5-part arrangement of “[**Gonna Fly Now**](https://en.wikipedia.org/wiki/Gonna_Fly_Now)” by [**Bill Conti**](https://en.wikipedia.org/wiki/Bill_Conti), popularly known as the theme song from the movie [**Rocky (1976)**](https://en.wikipedia.org/wiki/Rocky), at 117.1875 BPM.

https://github.com/fiveoutofnine/555/assets/66016924/fe3e8553-bc45-4810-92db-fce5f5437481

## Onchain audio generation

### Bytebeat generation

<details>
    <summary>Definition [<a href='https://dollchan.net/bytebeat'><i>Source</i></a>]</summary>
    <a href='http://canonical.org/~kragen/bytebeat'><b>Bytebeat</b></a> music (or one-liner music) was invented in September 2011. They're generally a piece of rhythmic and somewhat melodic music with no score, no instruments, and no real oscillators. It's simply a single-line formula that defines a waveform as a function of time, processed (usually) 8000 times per second, resulting in an audible waveform with a 256-step resolution from silence (0) to full amplitude (256). If you put that formula into a program with a loop that increments time variable (t), you can generate the headerless unsigned 8 bit mono 8kHz audio stream on output, like in this application. Since these directly output a waveform, they have great performance in compiled languages and can often be ran on even the weakest embedded devices.
    <br/>
</details>

The following is a JavaScript bytebeat format implementation for the audio in this project (24.832 second long audio of a 5-part arrangement of “Gonna Fly Now” by Bill Conti, popularly known as the theme song from the movie Rocky (1976), at 117.1875 BPM):

```js
f=(t>>10)%776,i=f>>2,v='repeat',e='charCodeAt',o=u=>1-u**2/2+u**4/24-u**6/720,T=O=>o((O%4)-2)*(((O&3)>>2)-1),F=n=>n.split``.map(x=>'1'[v]((y=x[e](0))&63)+'0'[v](y>>6)).join``,I=n=>n.split``.map(x=>String.fromCharCode((y=x[e](0))&4095)[v](y>>12)).join``,E=(x,y=0)=>.392*(t+12*T(t/1600))*2**(x/12-y)&32,((x=F(I("⁇⁃၇⁃၇⁃ぇ⁃၇⁃၇⁃ቇ၇⁃၇၃၇၃၏⁇ぃ၇ၓ၃။ၯ၃။ၯ၃။ၯ၃။ቿ⁃။⁃ቛ⁃၇၃၇၃၏灇ဠူ")))[f])*E(I("ꀵ‹䀵ꀹ‼쀹쀹ꀹ၅え큊が큅え큊が쁅恅့ဵ〷ဵ့瀹쁁⁁⁆쁅쁅聅")[e](i)-48)+(i>15&&x[f])*E(I("쀠䀠ꀵ‹䀵쀴쀴怴္〼쀹ှ぀쀵္〼쀹ှ぀쀹怹့ဵ〷ဵ့瀹䀵〴〲䀰怵")[e](i)-48)+(i>165)*E('579:<>@ACEFGIKLN'[e]((f>>1)-332)-48)+(i>173)*E(21)+(F(I("ኀ⿀ၯ၏ဿ၀⁇၏⁃假၏⁃假။ぃ假။ぃ၇䁃ၛ၃၇။၇၃၇ၛ၃၇䁃၇⁃䁇ဠူ"))[f])*E(I("퀠퀠耠쁀䀺耹耹‷‵䀷⁁⁂⁃‷‹‷䀹⁃⁄⁅‹‷‵〷ှ၁ှ⁂⁃‷‹‷〹၀၃၀⁄၅၀္ဵ耷耹逺䁆〺‹恅쀹쀹")[e](i)-48,2)+F(I("ᾀ⽀၏ဠၟ큏恏቏⁃၇၃၇၃၏ぇ၃။၇၃ဠဴ"))[f]*E(I("퀠퀠퀠瀠䁆쁅䁅쁆䁆쁈䁈쁆䁆쁈䁈聊聈ꁊ큈큈쁈")[e](i)-48,2)+(i>58&&i<178&&F(`CŃŃŃ${'ʃÀʃӀʃÀ'[v](6)}ŃŃŃŃŃŃʃÀ`)[f-236])*((2e11*(t/(1<<14))**2)&255)/5
```

[_Visualizer_](https://dollchan.net/bytebeat/#v3b64dVRfSxtBEP8uoeZ2L5fkbi9/VHJHRUyRlgqtbyok2NimaBI0SkSE2cZo1EIe+uhD8w0qxSCRVh9KX3ztJ7g/jakk36GzZ6Knttww+5u52ZnZmWG2AovFN7nAeGDJIGXT1FQ6kkwmlLyxZJpM2TCk1Vwply1LSs6QFt9lVyfRegLForFumFp4XZZZlIXwiEVZTIiJaJKpyqwxY5hFQmZGYjTMqEwQBnWKPmlYo0raKBhmIbJWWs6XM5nISrZEKoYpadLcxgIhm0ZlLrdAVEqDCZ2GJNVTb5pmgtLI+2K+kMko0//08Lq8mi+8jSytFlcmB8necxdTx+J04Exjd96mDFJRNg2VGmZEH2MyKYc0Js+SclRLqHhRZrJMKlGNhTdpUGcKwWBpMk3mAzbfs3nV8nHnkcba37sVrTvewLvOQPzkaQ4t/uW/YP/C83DoOTx67O0KATQtOJ4PUErnlhaoPOWleA0tG9outK6hbcO3HrSREFu85vB6nx84/GPfh3u81uE1C04taDkeR3yFtzi3Be2iAVKX1zCSqGyehmOjNETyphYPBiu+0D1outC8TaAHJ0gdOLGg7XiZWHDucOiJEA807Y7AD3NwhXjiwFcXjjvQepxAIi5iS/Hk2HjKfDoxOZV+Nv38xUtJmBGcaY2GdZ3d2Sd1Yc80lG4aah2AfQFe2RsWXFgcbFFhbFb19z1w6PgAdsEV/GjYkUNfdwZKdzgPrr9Tvmr1oYnUhWaPgwtnXWh3RcdObWi5yEXtP+B1TyP0LnIU+Y7Na/bQ0qvWucU58gf2jug5eMngo3aw/0IUZW514RRj/YEzl+86cIb2OAI3k+KvscJoaFCmc7C/g1ejpsU/93mjg3i/8XgunQEYVkS8/GTw8nsPR7rCefHmyxUjtuvhusvrftzlB11ev+YHfTGw+Kv+MEPsa3w0GMyntCQeaZKZ/FkV35Mt6bL6Ay6rv0Cc3lZJ0O2bnzef0GcwszDTEwtibbGcpuE6iBItldJiuAlkRoMsHqfReEAJrGVXSsu5V9kyblCdqaq6/Rc)

### Generating the audio

The audio file for this project has a sample rate of 32000Hz, and each loop is $776\cdot2^{10}$ samples long, so to generate the audio file, compute the value returned by the expression for $\texttt{t}\in[0, 776\cdot2^{10}-1]$ (you can query any $\texttt{t}$, but this is what's outputted by this project). Then, concatenate the results and prefix it with a [**WAVE file header**](http://soundfile.sapp.org/doc/WaveFormat/).

For practicality, the metadata returned by `tokenURI` accomplishes [**this with JavaScript**](https://github.com/fiveoutofnine/555/blob/797d9ef2890061c1c52c20acb094c9c28e17b017/src/utils/FiveFiveFiveArt.sol#L205-L231), but the same result can be yielded directly from the smart contract via [`getSoundValueAt(uint256 _tick)`](https://github.com/fiveoutofnine/555/blob/797d9ef2890061c1c52c20acb094c9c28e17b017/src/utils/FiveFiveFiveAudio.sol#L183) and [`getAudioFileWavHeader()`](https://github.com/fiveoutofnine/555/blob/797d9ef2890061c1c52c20acb094c9c28e17b017/src/utils/FiveFiveFiveAudio.sol#L152).

This repo provides a Foundry script [`GenerateAudioOutputScript`](https://github.com/fiveoutofnine/555/blob/main/script/GenerateAudioOutput.s.sol) to generate and write the audio file to `./output/wav/rocky.wav`. To run the script, run the following command:

```sh
forge script script/GenerateAudioOutput.s.sol:GenerateAudioOutputScript --via-ir --memory-limit="50000000000"
```

You can listen to the generated output [here](https://github.com/fiveoutofnine/555/blob/main/assets/rocky.wav).

## Deployment

WIP.

## Local development

This project uses [**Foundry**](https://github.com/foundry-rs/foundry) as its development/testing framework.

### Installation

First, make sure you have Foundry installed. Then, run the following commands to clone the repo and install its dependencies:

```sh
git clone https://github.com/fiveoutofnine/555.git
cd 555
forge install
```

### Data value generation

To generate the [**bitpacked mileage and location data**](https://github.com/fiveoutofnine/555/blob/main/src/utils/FiveFiveFiveData.sol) for the metadata renderer to read from (i.e. [`FiveFiveFiveData`](https://github.com/fiveoutofnine/555/blob/main/src/utils/FiveFiveFiveData.sol)), this repo provides 2 Python scripts to run: [`generation-location-data.py`](https://github.com/fiveoutofnine/555/blob/main/metadata/generate-location-data.py) and [`generation-running-data.py`](https://github.com/fiveoutofnine/555/blob/main/metadata/generate-running-data.py). To generate, test, and print them, run the following commands from the root of the project:

```sh
python3 ./metadata/generate-location-data.py
python3 ./metadata/generate-running-data.py
```

Then, after you've added/updated the values, you can run the following command to test print values retrieved via [`PrintDataScript`](https://github.com/fiveoutofnine/555/blob/main/script/PrintData.s.sol):

```sh
forge script script/PrintData.s.sol:PrintDataScript -vvv --via-ir
```

### Font generation

To generate the [**optimized font files**](https://github.com/fiveoutofnine/555/blob/c4ef5ab0e110895105a061fd6bc0b174b776dabb/src/utils/FiveFiveFiveConstants.sol#L16), see [**GENERATING_FONTS.md**](https://github.com/fiveoutofnine/555/blob/main/GENERATING_FONTS.md).

### Sample art (SVG and HTML) and metadata generation

To generate and write the base64-encoded JSON outputs to `./output/txt/{token_id}.txt`, follow the instructions in [`GenerateAudioOutputScript`](https://github.com/fiveoutofnine/555/blob/main/script/GenerateAudioOutput.s.sol) and run the following command:

```sh
forge script script/GenerateAudioOutput.s.sol:GenerateAudioOutput -vvv --via-ir
```
