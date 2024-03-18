// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title The interface for {FiveFiveFive}
/// @author fiveoutofnine
interface IFiveFiveFive {
    // -------------------------------------------------------------------------
    // Errors
    // -------------------------------------------------------------------------

    /// @notice Emitted when the sender didn't supply enough funds.
    error InsufficientFunds();

    /// @notice Emitted when the minting period has ended.
    error MintingEnded();

    /// @notice Emitted when a token hasn't been minted.
    error TokenUnminted();

    /// @notice Reverts if the sender isn't the owner of the token.
    error Unauthorized();

    // -------------------------------------------------------------------------
    // Structs
    // -------------------------------------------------------------------------

    /// @notice Struct containing 24-bit RGB color values for the theme to
    /// render the token URI with.
    /// @param background The background color behind the terminal window.
    /// @param terminalBackground The background color of the terminal window.
    /// @param primary The color inner frames' borders and highlights.
    /// @param text The color of the primary text.
    /// @param subtext The color of the secondary text.
    /// @param label The color of the inner frames' labels.
    /// @param intent1 The color of the most positive intent.
    /// @param intent2 The color of the second most positive intent.
    /// @param intent3 The color of the second most negative intent.
    /// @param intent4 The color of the most negative intent.
    /// @param modified Whether the theme has been modified by the owner.
    struct Theme {
        uint24 background;
        uint24 terminalBackground;
        uint24 primary;
        uint24 text;
        uint24 subtext;
        uint24 label;
        uint24 intent1;
        uint24 intent2;
        uint24 intent3;
        uint24 intent4;
        bool modified;
    }

    // -------------------------------------------------------------------------
    // Events
    // -------------------------------------------------------------------------

    /// @notice Emitted when the base URI is set.
    /// @param baseURI The new base URI.
    event SetBaseURI(string baseURI);

    /// @notice Emitted when some token's theme is set.
    /// @param id The ID of the token.
    /// @param theme The theme of the token.
    event SetTokenTheme(uint256 indexed id, Theme indexed theme);

    // -------------------------------------------------------------------------
    // Storage
    // -------------------------------------------------------------------------

    /// @dev If `baseURI` is unset, `tokenURI` will directly return the URI
    /// generated onchain via {FiveFiveFiveArt._tokenURI(uint256)}. Otherwise,
    /// it will return `baseURI + tokenId`.
    /// @return The base URI for the token collection.
    function baseURI() external view returns (string memory);

    // -------------------------------------------------------------------------
    // Functions
    // -------------------------------------------------------------------------

    /// @notice Mints the next mintable token to the sender.
    /// @dev The ID of the token MUST automatically increment by 1 every time,
    /// unless the token ID is 374, 458, or 554, in which case it MUST increment
    /// by 2. This is because they are special days minted in the constructor.
    function mint() external payable;

    /// @notice Sets the base URI for the token collection.
    /// @dev This function can only be called by the contract owner.
    /// @param _baseURI The new base URI for the token collection.
    function setBaseURI(string calldata _baseURI) external;

    /// @notice Withdraws the contract's balance to some address.
    /// @param _to The address to withdraw the contract's balance to.
    function withdraw(address _to) external;

    // -------------------------------------------------------------------------
    // Color theming
    // -------------------------------------------------------------------------

    /// @notice Returns the token theme for a token.
    /// @param _id The ID of the token to get the theme for.
    /// @return The token theme for the token.
    function getTokenTheme(uint256 _id) external view returns (Theme memory);

    /// @notice Sets the token theme for a token given 24-bit RGB color values.
    /// @dev This function can only be called by the token's owner. `modified`
    /// MUST be set to `true` the first time this function is called for a
    /// token.
    /// @param _background The background color behind the terminal window.
    /// @param _terminalBackground The background color of the terminal window.
    /// @param _primary The color inner frames' borders and highlights.
    /// @param _text The color of the primary text.
    /// @param _subtext The color of the secondary text.
    /// @param _label The color of the inner frames' labels.
    /// @param _intent1 The color of the most positive intent.
    /// @param _intent2 The color of the second most positive intent.
    /// @param _intent3 The color of the second most negative intent.
    /// @param _intent4 The color of the most negative intent.
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
    ) external;

    // -------------------------------------------------------------------------
    // Onchain audio generation
    // -------------------------------------------------------------------------

    /// @notice Returns the WAV file header for the audio file for 1 full cycle
    /// of the token's sound with the parameters the token's sound was generated
    /// with:
    ///     * Size: 776.044921875kB (794670 bytes)
    ///     * Number of channels: 1
    ///     * Sample rate: 32000Hz
    ///     * Bits/sample: 8 bits/sample
    function getAudioWavFileHeader() external pure returns (bytes memory);

    /// @notice Returns the sound value at a given time tick in the audio.
    /// @dev {FiveFiveFive}'s audio was generated at a sample rate of 32000Hz,
    /// which means that `_tick` increments by 1 every 1/32000 seconds.
    /// @param _tick The number of samples since the beginning of the audio at
    /// a frequency of 32000Hz to get the sound value at.
    /// @return The sound value at the given time tick, a value in the range
    /// `[0, 255]` (higher means louder).
    function getSoundValueAtSample(uint256 _tick) external pure returns (uint8);

    // -------------------------------------------------------------------------
    // Metadata
    // -------------------------------------------------------------------------

    /// @notice Returns the contract URI for this contract.
    /// @return The contract URI for this contract.
    function contractURI() external view returns (string memory);
}
