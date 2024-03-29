// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Base64} from "solady/utils/Base64.sol";
import {LibString} from "solady/utils/LibString.sol";
import {Owned} from "solmate/auth/Owned.sol";
import {ERC721} from "solmate/tokens/ERC721.sol";

import {IFiveFiveFive} from "./interfaces/IFiveFiveFive.sol";
import {FiveFiveFiveArt} from "./utils/FiveFiveFiveArt.sol";
import {FiveFiveFiveAudio} from "./utils/FiveFiveFiveAudio.sol";

/// @title 555 (1000 × ⁵⁄₉) NFTs
/// @author fiveoutofnine
/// @notice A ⁵⁄₉-themed NFT to commemorate me running 10000km in 555 days of
/// running everyday. For each token, in addition to displaying information
/// about the day's run with a themeable color palette, the metadata of each
/// token contains a 100% onchain-generated 24.832 second long audio of a 5-part
/// arrangement of “Gonna Fly Now” by Bill Conti, popularly known as the theme
/// song from the movie Rocky (1976), at 117.1875 BPM.
contract FiveFiveFive is IFiveFiveFive, ERC721, Owned {
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice Address of fiveoutofnine.eth, the contract owner.
    address constant FIVEOUTOFNINE = 0xA85572Cd96f1643458f17340b6f0D6549Af482F5;

    /// @notice Price to mint a token.
    /// @dev Equivalent to (⁵⁄₉) / 10 ETH.
    uint256 constant PRICE = 0.055_555_555_555_555_555 ether;

    /// @notice Description of the collection.
    string constant COLLECTION_DESCRIPTION =
        unicode"A ⁵⁄₉-themed NFT to commemorate me running 10000km in 555 days "
        unicode"of running everyday. For each token, in addition to displaying "
        unicode"information about the day's run with a themeable color palette,"
        unicode" the metadata of each token contains a 100% onchain-generated 2"
        unicode"4.832 second long audio of a 5-part arrangement of “Gonna Fly N"
        unicode"ow” by Bill Conti, popularly known as the theme song from the m"
        unicode"ovie Rocky (1976), at 117.1875 BPM.";

    // -------------------------------------------------------------------------
    // Storage
    // -------------------------------------------------------------------------

    /// @inheritdoc IFiveFiveFive
    string public override baseURI;

    /// @notice The next token ID to be minted.
    /// @dev The valid tokens to be minted are `[1, 555]`. Since `[1, 52]` are
    /// minted in the constructor, the next token ID to be minted is 53. Note
    /// that, in addition to the first 52, tokens 375, 459, and 555 are also
    /// minted in the constructor. Thus, when `mint()` is called when
    /// `_nextTokenId` is 375, 459, or 555, it will increment by 2 instead of 1.
    uint256 internal _nextTokenId = 53;

    /// @notice A mapping of token IDs to their themes.
    mapping(uint256 => Theme) internal _themes;

    // -------------------------------------------------------------------------
    // Constructor + functions
    // -------------------------------------------------------------------------

    constructor()
        ERC721(unicode"555 (1000 × ⁵⁄₉)", "555")
        Owned(FIVEOUTOFNINE)
    {
        // shanefan.eth gets #1.
        _mint(0xaFDc1A3EF3992f53C10fC798d242E15E2F0DF51A, 1);
        _mint(FIVEOUTOFNINE, 2);
        _mint(FIVEOUTOFNINE, 3);
        _mint(FIVEOUTOFNINE, 4);
        _mint(FIVEOUTOFNINE, 5);
        _mint(FIVEOUTOFNINE, 6);
        _mint(FIVEOUTOFNINE, 7);
        _mint(FIVEOUTOFNINE, 8);
        _mint(0x00cDa37BfC3Dd20349Aa901Fe8646688218d8772, 9);
        _mint(0x0734d56DA60852A03e2Aafae8a36FFd8c12B32f1, 10);
        _mint(0x16cCd2a1346978e27FDCbda43569E251C4227341, 11);
        _mint(0x1a8906a0EBB799ED4C0e385d7493D11701700d3a, 12);
        _mint(0x1B7688538170E98856ea86D0a68C7e407D49C5C3, 13);
        _mint(0x230d31EEC85F4063a405B0F95bdE509C0d0A8b5D, 14);
        _mint(0x2Abc80332a8DFa064bD2f361E8B72d76ef8637C5, 15);
        _mint(0x2BdA41589fc6b86D17F9ADb4Cc90313799D5F6e5, 16);
        _mint(0x317Bc38b66566566529C41462bA774F489b4a63f, 17);
        _mint(0x34aA3F359A9D614239015126635CE7732c18fDF3, 18);
        _mint(0x4a69B81A2cBEb3581C61d5087484fBda2Ed39605, 19);
        _mint(0x5C227217875D0Bc94AeeE8798aF9de3935CFf0f2, 20);
        _mint(0x5DFfD5527551888c2AC47f799c4Dc8e830dECeE7, 21);
        _mint(0x61E2029e46A9d2584bad8093b19bc53572E95d5D, 22);
        _mint(0x655aF72e1500EB8A8d1c90856Ae3B8f148A78471, 23);
        _mint(0x66810420d110919a0E8b550fDE3fE24D50ef0e26, 24);
        _mint(0x66BF25e328156eF5d08404094Ae2532D8592F87D, 25);
        _mint(0x6dacb7352B4eC1e2B979a05E3cF1F126AD641110, 26);
        _mint(0x75d4bdBf6593ed463e9625694272a0FF9a6D346F, 27);
        _mint(0x79d31bFcA5Fda7A4F15b36763d2e44C99D811a6C, 28);
        _mint(0x7eD52863829AB99354F3a0503A622e82AcD5F7d3, 29);
        _mint(0x849151d7D0bF1F34b70d5caD5149D28CC2308bf1, 30);
        _mint(0x85C153AAe1f101Af08151863306d9e0b823eA1B5, 31);
        _mint(0x88F09Bdc8e99272588242a808052eb32702f88D0, 32);
        _mint(0x8E10FF7D1195484a3FDd5B19D48E2F394a88FaD3, 33);
        _mint(0x8FC68A56f9682312953a1730Ae62AFD1a99FdC4F, 34);
        _mint(0x91031DCFdEa024b4d51e775486111d2b2A715871, 35);
        _mint(0xa35156ca4294c13fe256B10091F3D6595E3Bf7d7, 36);
        _mint(0xB0623C91c65621df716aB8aFE5f66656B21A9108, 37);
        _mint(0xB95777719Ae59Ea47A99e744AfA59CdcF1c410a1, 38);
        _mint(0xBad58e133138549936D2576ebC33251bE841d3e9, 39);
        _mint(0xbC955ed49f1Cd4595953873Bbf9B90AfAF45E996, 40);
        _mint(0xc95C558dAA63b1A79331B2AB4a2a7af375384d3B, 41);
        _mint(0xD7029BDEa1c17493893AAfE29AAD69EF892B8ff2, 42);
        _mint(0xd7B8865970528b0cC372cE380D64a864039c2B9e, 43);
        _mint(0xDbAacdcadD7c51a325B771ff75B261a1e7baE11c, 44);
        _mint(0xDC40CbF86727093c52582405703e5b97D5C64B66, 45);
        _mint(0xE340b00B6B622C136fFA5CFf130eC8edCdDCb39D, 46);
        _mint(0xEee718c1e522ecB4b609265db7A83Ab48ea0B06f, 47);
        _mint(0xF196b0B975b0fD11dF1936C3A35Cf10ea218f283, 48);
        _mint(0xF1b0E893ea21e95763577CeC398ea0af5dB79037, 49);
        _mint(0xF2829E74C8a8709e170E21979A482f88C607B632, 50);
        _mint(0xf32dd1Bd55bD14d929218499a2E7D106F72f79c7, 51);
        _mint(0xFaaDaaB725709f9Ac6d5C03d9C6A6F5E3511FD70, 52);
        // kaki.eth gets #375, the only marathon+ day (50.02km).
        _mint(0x4fd9D0eE6D6564E80A9Ee00c0163fC952d0A45Ed, 375);
        // fiveoutofnine.eth gets #459, 1:19:16 HM PB.
        _mint(FIVEOUTOFNINE, 459);
        // fiveoutofnine.eth gets #555.
        _mint(FIVEOUTOFNINE, 555);
    }

    /// @inheritdoc IFiveFiveFive
    function mint() external payable override {
        uint256 tokenId = _nextTokenId;

        // Minting is complete.
        if (tokenId > 554) revert MintingEnded();
        // Revert if the sender didn't supply enough funds.
        if (msg.value < PRICE) revert InsufficientFunds();

        // Increment the next token ID;
        unchecked {
            _nextTokenId = tokenId + (tokenId == 374 || tokenId == 458 ? 2 : 1);
        }

        // Mint token.
        _mint(msg.sender, tokenId);
    }

    /// @inheritdoc IFiveFiveFive
    function setBaseURI(string calldata _baseURI) external override onlyOwner {
        // Set new base URI.
        baseURI = _baseURI;

        // Emit event.
        emit SetBaseURI(_baseURI);
    }

    /// @inheritdoc IFiveFiveFive
    function withdraw(address _to) external override onlyOwner {
        (bool success, ) = payable(_to).call{value: address(this).balance}("");
        require(success);
    }

    // -------------------------------------------------------------------------
    // Color theming
    // -------------------------------------------------------------------------

    /// @inheritdoc IFiveFiveFive
    function getTokenTheme(uint256 _id) external view override returns (Theme memory) {
        // Revert if the token hasn't been minted.
        if (_ownerOf[_id] == address(0)) revert TokenUnminted();

        Theme memory theme = _themes[_id];
        // Return the default theme if the theme was never set.
        if (!theme.modified) {
            return
                Theme({
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
                });
        }

        return theme;
    }

    /// @inheritdoc IFiveFiveFive
    function setTokenTheme(
        uint256 _id,
        uint24 _background,
        uint24 _terminalBackground,
        uint24 _primary,
        uint24 _text,
        uint24 _subtext,
        uint24 _label,
        uint24 _intent1,
        uint24 _intent2,
        uint24 _intent3,
        uint24 _intent4
    ) external override {
        // Revert if the sender is not the owner of the token.
        if (_ownerOf[_id] != msg.sender) revert Unauthorized();

        // Set new token theme.
        Theme memory theme = Theme({
            background: _background,
            terminalBackground: _terminalBackground,
            primary: _primary,
            text: _text,
            subtext: _subtext,
            label: _label,
            intent1: _intent1,
            intent2: _intent2,
            intent3: _intent3,
            intent4: _intent4,
            modified: true
        });
        _themes[_id] = theme;

        // Emit event.
        emit SetTokenTheme(_id, theme);
    }

    // -------------------------------------------------------------------------
    // Onchain audio generation
    // -------------------------------------------------------------------------

    /// @inheritdoc IFiveFiveFive
    function getAudioWavFileHeader() external pure returns (bytes memory) {
        return FiveFiveFiveAudio.getAudioWavFileHeader();
    }

    /// @inheritdoc IFiveFiveFive
    function getSoundValueAtSample(uint256 _tick) external pure returns (uint8) {
        return FiveFiveFiveAudio.getSoundValueAtSample(_tick);
    }

    // -------------------------------------------------------------------------
    // ERC721Metadata
    // -------------------------------------------------------------------------

    /// @notice Returns the adjusted URI for a given token ID.
    /// @dev Reverts if the token ID does not exist. Additionally, if `baseURI`
    /// is unset, `tokenURI` will directly return the URI generated onchain via
    /// {_tokenURI(uint256)}. Otherwise, it will return `baseURI + tokenId`.
    /// @param _id The token ID.
    /// @return The adjusted URI for the given token ID.
    function tokenURI(uint256 _id) public view override returns (string memory) {
        // Revert if the token hasn't been minted.
        if (_ownerOf[_id] == address(0)) revert TokenUnminted();

        return
            bytes(baseURI).length == 0
                ? _tokenURI(_id)
                : string.concat(baseURI, _id.toString());
    }

    /// @notice Returns the URI for a given token ID, as generated onchain.
    /// @param _id The token ID.
    /// @return The URI for the given token ID.
    function _tokenURI(uint256 _id) internal view returns (string memory) {
        Theme memory theme = _themes[_id];

        // Use the default theme if the theme was never set.
        if (!theme.modified) {
            theme = Theme({
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
            });
        }

        return FiveFiveFiveArt.render({ _day: _id - 1, _theme: theme });
    }

    // -------------------------------------------------------------------------
    // Contract metadata
    // -------------------------------------------------------------------------

    /// @inheritdoc IFiveFiveFive
    function contractURI() external pure override returns (string memory) {
        return
            string.concat(
                "data:application/json;charset=utf-8;base64,",
                Base64.encode(
                    abi.encodePacked(
                        unicode'{"name":"555 (1000 × ⁵⁄₉)","description":"',
                        COLLECTION_DESCRIPTION,
                        '"}'
                    )
                )
            );
    }
}
