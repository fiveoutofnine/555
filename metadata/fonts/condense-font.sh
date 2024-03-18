# pip3 install fonttools

pyftsubset ./metadata/fonts/input/FiraCode-Regular.ttf --output-file=./metadata/fonts/output/FiraCode-Regular-Subset.ttf --unicodes-file=./metadata/fonts/output/regular-glyphs.txt
pyftsubset ./metadata/fonts/input/FiraCode-Medium.ttf --output-file=./metadata/fonts/output/FiraCode-Medium-Subset.ttf --unicodes-file=./metadata/fonts/output/medium-glyphs.txt
pyftsubset ./metadata/fonts/input/Inter-Medium.ttf --output-file=./metadata/fonts/output/Inter-Medium-Subset.ttf --unicodes-file=./metadata/fonts/output/inter-medium-glyphs.txt
