// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Base64} from "solady/utils/Base64.sol";
import {LibString} from "solady/utils/LibString.sol";
import {Owned} from "solmate/auth/Owned.sol";
import {ERC721} from "solmate/tokens/ERC721.sol";

import {IFiveFiveFive} from "./interfaces/IFiveFiveFive.sol";
import {FiveFiveFiveArt} from "./utils/FiveFiveFiveArt.sol";
import {FiveFiveFiveAudio} from "./utils/FiveFiveFiveAudio.sol";

/// @title 10000km ran in 555 (1000 × ⁵⁄₉) day-streak commemorative NFTs
/// @author fiveoutofnine
/// @notice A ⁵⁄₉-themed NFT to commemorate me running 10000km in 555 days of
/// running everyday. For each token, in addition to displaying information
/// about the day's run, the metadata of each token contains a 100%
/// onchain-generated 24.832 second long audio 5-part arrangement of "Gonna Fly
/// Now" by Bill Conti, popularly known as the theme song from the movie Rocky
/// (1976) at 117.1875 BPM.
contract FiveFiveFive is IFiveFiveFive, ERC721, Owned {
    using LibString for uint256;

    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice Description of the collection.
    string constant COLLECTION_DESCRIPTION =
        unicode"A ⁵⁄₉-themed NFT to commemorate me running 10000km in 555 days "
        unicode"of running everyday. For each token, in addition to displaying "
        unicode"information about the day's run, the metadata of each token con"
        unicode"tains a 100% onchain-generated 24.832 second long audio 5-part "
        unicode'arrangement of "Gonna Fly Now" by Bill Conti, popularly known a'
        unicode"s the theme song from the movie Rocky (1976) at 117.1875 BPM.";

    /// @notice Price to mint a token.
    /// @dev Equivalent to (⁵⁄₉) / 10 ETH.
    uint256 constant PRICE = 0.055555555555555555 ether;

    // -------------------------------------------------------------------------
    // Storage
    // -------------------------------------------------------------------------

    /// @inheritdoc IFiveFiveFive
    string public override baseURI;

    // -------------------------------------------------------------------------
    // Constructor + functions
    // -------------------------------------------------------------------------

    /// @param _owner Initial owner of the contract.
    constructor(
        address _owner
    ) ERC721("10000km in 555 everydays", "555") Owned(_owner) {}

    /// @inheritdoc IFiveFiveFive
    function mint(uint256 _id) external payable override {
        // Revert if the token ID is invalid.
        if (_id < 1 || _id > 555) revert InvalidTokenId();
        // Revert if the sender didn't supply enough funds.
        if (msg.value < PRICE) revert InsufficientFunds();

        // Mint token.
        _mint(msg.sender, _id);
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
    // Onchain audio generation
    // -------------------------------------------------------------------------

    /// @inheritdoc IFiveFiveFive
    function getAudioWavFileHeader() external pure returns (bytes memory) {
        return FiveFiveFiveAudio.getAudioWavFileHeader();
    }

    /// @inheritdoc IFiveFiveFive
    function getSoundValueAtSample(
        uint256 _tick
    ) external pure returns (uint8) {
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
    function tokenURI(
        uint256 _id
    ) public view override returns (string memory) {
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
    function _tokenURI(uint256 _id) internal pure returns (string memory) {
        return FiveFiveFiveArt.render({_day: _id - 1});
    }

    // -------------------------------------------------------------------------
    // Contract metadata
    // -------------------------------------------------------------------------

    /// @inheritdoc IFiveFiveFive
    function contractURI() external pure override returns (string memory) {
        return
            string.concat(
                "data:application/json;base64,",
                Base64.encode(
                    abi.encodePacked(
                        '{"name":"10000km in 555 everydays","description":"',
                        COLLECTION_DESCRIPTION,
                        '"}'
                    )
                )
            );
    }
}
