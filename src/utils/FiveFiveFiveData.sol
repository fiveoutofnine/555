// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

library FiveFiveFiveData {
    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice A bitpacked value of 100 times to the kilometer mileage value
    /// ran on each day. Each day's mileage is represented by 12 bits, and the
    /// data for some 0-indexed day `i` is stored at bits
    /// `[12 * i + 4, 12 * i + 16)`.
    /// @dev Since only 12 bits are reserved for each day's mileage, the maximum
    /// mileage that can be represented for a day is `2**12 - 1 = 4095` (i.e.
    /// 40.95km). The only day that MUST be handled separately is the 0-indexed
    /// day 374, which recorded a mileage of 50.02km. Also, note that the hex
    /// dump has a beginning offset of 4 bits.
    bytes internal constant RUNNING_DATA =
        hex"063c96362c4257a37286539c45336306576b97517f484180f6c16f166b72e5798f"
        hex"35dd7265577a3dbb6b870a642827604c916a561f76d53e5bd4c340d62a60b3eb64"
        hex"1b5b89f86681a3e98f3507756929ab286576543aa6a4518492f54dd4f96d251757"
        hex"d5a17f951b4b0b749e26794f02548907a1793254bfd40f73d8cf87336a51697b97"
        hex"e5ad1f58f040e85e37388c3ea79c57c7543278efa3a6412cd3ffe563a6a0854438"
        hex"43e85c2a2c35feee41f64741e36e6604f1bfe4d07d760f49611281151470a77c65"
        hex"a6254e49782db7253a284735c4e12973cdc0f41f52881e474320439c9692f9fe76"
        hex"9698a837096925335642879d26ec79566b38e59c2b05bf5425aa5ac73f7487d33c"
        hex"460064278562086f74d3dc37842b45367461567c5158912489924c33267e04f488"
        hex"06ab6105d273a77e89a78c4bd49146e7417817d07466d17213ea29c39f7ec78c68"
        hex"983f60941940e7584344172cc58483f7ac84b736bc574c7645c272547e5007433e"
        hex"a2e75565dd7465c32ed8b2416876ca284cc198d29ff8df2915157c783f5716be2c"
        hex"d5e841962f3ee7a17d487883e7414277ae3e547e6595444691e366b47183051477"
        hex"33da4b18d04795337933eb62d9644c88b97957c58a265777962e60241581f72bb2"
        hex"a3b770c5787e490e43e75c99c44f7c46e483e6067384c67bc5ad4f27a070660fa9"
        hex"a6b672546445a3abbba53472abf95c229d83e4836426675ff51552fab18db7dd40"
        hex"376d6b24c74b87284b2a2b6517cd67e81456e6267e25df7a365e3ebbde8e6c1d77"
        hex"038a8284134db9c556379154976e6a5b057d1672554ca851753b78e43672572a69"
        hex"07fd5ba7d75de79780979f5f18e18206086d488f4baabe8d5b6a9cf688912b187b"
        hex"38fc8a383abce6cb8566a58fa7f98308189146576fa6f2c9676777876e65b89e78"
        hex"aa527488e577384583e822bf780f78c6c78288bfa3697a9366843eeb0352a94a86"
        hex"88898b371865b848d0c87689a6f15f378a76579e89981c7b79856f171679383a8d"
        hex"25b353773f5b86f685e8936a4a5591d7e771d8407a98728ff8678ab7de8748547f"
        hex"07d541dc9d78381965d70a82371d7fa72484379076f93e5ab872a4c8b7a7a8dc91"
        hex"585d5f0a147e16d4bf371392aa1693e925aba9d39919399208fa7e771e7569466a"
        hex"66576509e58f6853";

    // -------------------------------------------------------------------------
    // Functions
    // -------------------------------------------------------------------------

    /// @notice Returns 100 times the kilometer mileage value ran on a given
    /// day.
    /// @dev Valid values for `_day` are in `[0, 554]`. The function does not
    /// handle invalid `_day` values.
    /// @param _day 0-indexed day to get the mileage for.
    /// @return 100 times the kilometer mileage value ran on day `_day`.
    function getDayMileage(uint256 _day) internal pure returns (uint256) {
        // Handle the special case for day 374.
        if (_day == 374) return 5002;

        // Since 12 bits are reserved for each day's mileage, but we can only
        // retrieve 8 bits at a time from `RUNNING_DATA`, we retrieve 2 bytes
        // separately and combine them to get the mileage for day `_day`. The
        // corresponding mileage data is stored at bits
        // `[12 * _day + 4, 12 * _day + 16)`, so the index of the first byte is
        // `(12 * _day + 4) >> 3`, and the index of the second byte is 1 larger.
        uint256 index;
        assembly {
            // Equivalent to `index = (12 * _day + 4) >> 3`.
            index := shr(3, add(mul(12, _day), 4))
        }
        unchecked {
            uint256 a = uint8(RUNNING_DATA[index]);
            uint256 b = uint8(RUNNING_DATA[index + 1]);

            return
                // If `_day` is even, the relevant data is stored at the first
                // byte's 4 most significant bits, and the second byte's 8 least
                // significant bits. Similarly, if `_day` is odd, the relevant
                // data is stored at the first byte's 8 least significant bits,
                // and the second byte's 4 most significant bits.
                _day & 1 == 0
                    ? ((a & 0xf) << 8) | b
                    : (a << 4) | ((b >> 4) & 0xf);
        }
    }
}
