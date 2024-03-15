// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title The interface for {FiveFiveFive}
interface IFiveFiveFive {
    // -------------------------------------------------------------------------
    // Errors
    // -------------------------------------------------------------------------

    /// @notice Emitted when the sender didn't supply enough funds.
    error InsufficientFunds();

    /// @notice Emitted when a token hasn't been minted.
    error TokenUnminted();

    // -------------------------------------------------------------------------
    // Events
    // -------------------------------------------------------------------------

    /// @notice Emitted when the base URI is set.
    /// @param baseURI The new base URI.
    event SetBaseURI(string baseURI);

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

    /// @notice Mints the token of ID `_id` to the sender.
    /// @param _id The ID of the token to mint.
    function mint(uint256 _id) external payable;

    /// @notice Sets the base URI for the token collection.
    /// @dev This function can only be called by the contract owner.
    /// @param _baseURI The new base URI for the token collection.
    function setBaseURI(string calldata _baseURI) external;

    /// @notice Withdraws the contract's balance to some address.
    /// @param _to The address to withdraw the contract's balance to.
    function withdraw(address _to) external;

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
