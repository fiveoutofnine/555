BASE_PATH = "./metadata/fonts/"

REGULAR_CHARACTERS = "┌─╥┐│ 0.km║└╨┘080▮.192►fromkHzkbps[:/]━PLAY123456789"
MEDIUM_CHARACTERS = "daymileagelocation0123456789new york city san francisco" +\
    " seoul huntington beach westminister milan luštica bay shanghai paris r" +\
    "eykjavík selfoss scotts valley redwood city jeju kagoshima denver7dwork" +\
    "loadbytebeatgonnaflynowrocky"
INTER_MEDIUM_CHARACTERS = "1000 × ⁵⁄₉ = 555 — 36×11"

with open(f"{BASE_PATH}output/regular-glyphs.txt", "w") as f:
    f.write('\n'.join([f"U+{str(hex(ord(char))[2:]).zfill(4).upper()}" for char in sorted(list(set(REGULAR_CHARACTERS)))]))

with open(f"{BASE_PATH}output/medium-glyphs.txt", "w") as f:
    f.write('\n'.join([f"U+{str(hex(ord(char))[2:]).zfill(4).upper()}" for char in sorted(list(set(MEDIUM_CHARACTERS)))]))

with open(f"{BASE_PATH}output/inter-medium-glyphs.txt", "w") as f:
    f.write('\n'.join([f"U+{str(hex(ord(char))[2:]).zfill(4).upper()}" for char in sorted(list(set(INTER_MEDIUM_CHARACTERS)))]))
