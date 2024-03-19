// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test} from "forge-std/Test.sol";

import {IFiveFiveFive} from "src/interfaces/IFiveFiveFive.sol";
import {FiveFiveFive} from "src/FiveFiveFive.sol";

/// @notice Unit tests for {FiveFiveFive}.
contract FiveFiveFiveTest is Test {
    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice Address of fiveoutofnine.eth, the contract owner.
    address constant FIVEOUTOFNINE = 0xA85572Cd96f1643458f17340b6f0D6549Af482F5;

    /// @notice Price to mint a token.
    /// @dev Equivalent to (⁵⁄₉) / 10 ETH. Must be greater than 1 for testing.
    uint256 constant PRICE = 0.055_555_555_555_555_555 ether;

    // -------------------------------------------------------------------------
    // Immutable storage
    // -------------------------------------------------------------------------

    /// @notice Address of the minter.
    address internal immutable minter;

    /// @notice Address of the owner.
    address internal immutable owner;

    // -------------------------------------------------------------------------
    // Contracts
    // -------------------------------------------------------------------------

    /// @notice The 555 contract.
    FiveFiveFive internal nft;

    // -------------------------------------------------------------------------
    // Setup
    // -------------------------------------------------------------------------

    /// @notice Sets and labels addresses for `minter`.
    constructor() {
        // Set addresses.
        minter = makeAddr("minter");
        owner = FIVEOUTOFNINE;
        // Label addresses.
        vm.label(minter, "Minter");
        vm.label(owner, "Owner (fiveoutofnine.eth)");
    }

    /// @notice Deploys an instance of {FiveFiveFive}.
    function setUp() public {
        // Deploy the contract.
        nft = new FiveFiveFive();
        vm.label(address(nft), "`FiveFiveFive`");

        // Deal 10,000 ether to the minter.
        vm.deal(minter, 10_000 ether);
    }

    // -------------------------------------------------------------------------
    // `mint`
    // -------------------------------------------------------------------------

    /// @notice Test that the `mint` function reverts when the value is
    /// insufficient.
    function test_mint_InsufficientFunds_Reverts() public {
        vm.startPrank(minter);

        vm.expectRevert(IFiveFiveFive.InsufficientFunds.selector);
        unchecked {
            // Mint with 1 wei less than the required amount.
            nft.mint{ value: PRICE - 1 }();
        }
    }

    /// @notice Test that minting after the NFT has been minted 500 times (i.e.
    /// reached total supply of 555) reverts.
    function test_mint_AllPublicMinted_Reverts() public {
        vm.startPrank(minter);

        // The NFT should mint to the sender for the first `555 - 55 = 500`
        // calls (max supply 555, and 55 minted in the constructor).
        for (uint256 i; i < 500; ) {
            nft.mint{ value: PRICE }();
            unchecked {
                assertEq(nft.balanceOf(minter), i + 1);
                ++i;
            }
        }

        vm.expectRevert(IFiveFiveFive.MintingEnded.selector);
        nft.mint{ value: PRICE }();
    }

    // -------------------------------------------------------------------------
    // `withdraw`
    // -------------------------------------------------------------------------

    /// @notice Test that the `mint` function reverts when the value is
    /// insufficient.
    function test_withdraw_NotOwner_Unauthorized() public {
        vm.startPrank(minter);

        vm.expectRevert("UNAUTHORIZED");
        nft.withdraw(owner);
    }

    /// @notice Test that the `withdraw` function transfers the funds to
    /// `owner`.
    function test_withdraw_Owner_Equality() public {
        // First, mint 10 tokens as `minter`.
        vm.startPrank(minter);
        for (uint256 i; i < 10; ) {
            nft.mint{ value: PRICE }();
            unchecked {
                ++i;
            }
        }
        vm.stopPrank();

        // Next, check the balance of the NFT contract, and store the balance of
        // `owner`.
        assertEq(address(nft).balance, 10 * PRICE);
        uint256 startBalance = owner.balance;

        // Withdraw the funds to `owner`.
        vm.prank(owner);
        nft.withdraw(owner);

        // Check that the balance of the NFT contract is 0, and `owner` has
        // increased by 10 * PRICE.
        assertEq(address(nft).balance, 0);
        assertEq(owner.balance, startBalance + 10 * PRICE);
    }
}
