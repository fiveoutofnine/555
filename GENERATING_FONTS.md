# Generating Fonts

> [!NOTE]
> This was adapted from [**this Gist**](https://gist.github.com/fiveoutofnine/48d7f344433bba862c4151a7f3cf318f/).

This file is a step-by-step guide to generating [**optimized font files**](https://github.com/fiveoutofnine/555/blob/c4ef5ab0e110895105a061fd6bc0b174b776dabb/src/utils/FiveFiveFiveConstants.sol#L16).

### 1. Add font files

Add the starting font files to `./metadata/fonts/input/*`. They must be static (i.e. non-variable).

### 2. Generating glyphs

Most of the size reduction comes from removing unused glyphs from the font file. To generate and write a set of unicode characters to `./metadata/fonts/output/*.txt` that we'll read from later when generating the subset font file, run the following command:

```py
python3 ./metadata/fonts/generate-glyphs.py
```

> [!NOTE]
> This command must be run from the root of the project (or you can update the base path accordingly).

> [!TIP]
> Change the font file names/formats and characters to meet your need.

### 3. Generating the subset font files

To generate and write the subset font files to `./metadata/fonts/output/*.-Subset.ttf`, run the following command:

```sh
source ./metadata/fonts/condense-font.sh
```

> [!NOTE]
> This command must be run from the root of the project (or you can update the base path accordingly).

### 4. `ttf` to `woff2` conversion

Next, we can (usually) get a bit more savings by convering the font files to `woff2` format. I like to use [**this**](https://cloudconvert.com/ttf-to-woff2) online converter.

> [!TIP]
> In addition to generally being smaller in size, the `woff2` format has [**pretty good browser support**](https://caniuse.com/?search=woff2) as of 2024.

### 5. Base64 encoding

To base64 encode the font files and write the result to `./metadata/fonts/output/*-Subset.txt`, you can run the following command:

```sh
python3 ./metadata/fonts/base64-encode-font.py
```

> [!NOTE]
> This command must be run from the root of the project (or you can update the base path accordingly).

You can then use it inside an SVG/HTML as follows:

```svg
<svg {...} >
    <style type="text/css">
        @font-face {
            font-family: Font-Name;
            src: url(BASE64_ENCODED_TXT);
        }
    </style>
    <text font-family="Font-Name">
        some text
    </text>
</svg>
```
