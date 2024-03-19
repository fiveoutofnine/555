// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title Mileage and location data for each of the 555 days of running
/// @author fiveoutofnine
/// @notice A library for retrieving mileage and location data to render the art
/// and metadata in {FiveFiveFiveArt}.
library FiveFiveFiveData {
    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    /// @notice A bitpacked value of the city the run took place in on each day.
    /// Each day's city is represented by 4 bits, and the data for some
    /// 0-indexed day `i` is stored at bits `[4 * i + 4, 4 * i + 8)`. See
    /// {FiveFiveFiveData.getDayLocation} for the corresponding name mappings.
    /// @dev Note that the hex dump has a beginning offset of 4 bits.
    bytes internal constant LOCATION_DATA =
        hex"000000000000000000000000000000000000000000000000000000000000000001"
        hex"111110000222222222222222222222222222222222222222222222222222222222"
        hex"222333333330000000000000000000000000000000000000000004000000000000"
        hex"000000005566666666666666666666666666666666666666666000000000000000"
        hex"0000022222222777772222222222000000000000000000000000000008888889a9"
        hex"00000000000000000000000000000bbbccc0000000000000000000000000002222"
        hex"2222222ddd22222000000000000000000000000000000000000000000000000000"
        hex"0000000000000000000222eeeee222222222222222222222222222222222200000"
        hex"0000000000000000fffffffff000";

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
        hex"063c96362c4257a47296539c45336306586b97517f484180f6c16f166b72e5798f"
        hex"35dd7275577a3dbc6b870a642827604c916a561f76d53e5bd4c340d62a60b3ec64"
        hex"1b5b89f86681a3e98f3507756929ab286576543aa6a4518492f54dd4f96d251757"
        hex"d5a17f951b4b0b749e26794f02548907a1793254bfd40f73d8cf87336a51697b97"
        hex"e5ad1f58f040e85e37388c3eb79c57c7543278efa3a6412cd3ffe563a6a0854438"
        hex"43e85c2a2c35feee41f64741e36f6614f1bfe4d07d760f49611281151470a77c65"
        hex"a6254e49782db7253a284735c4e12973cdc0f41f52881e474320439c9792f9fe76"
        hex"9698a837096935335642879d26ec79566b38e59c2b05bf5425aa5ac7407487d33c"
        hex"460064278562086f74d3dc37842b45367461567c5158912489924c33267e04f488"
        hex"06ab6105d273a77e89a78c4bd49146e7427817d07466d17213eb29c3a07ec78d68"
        hex"983f60941940e7584344172cc58483f7ac84b736bc574c7645c272547e5007433e"
        hex"a2e75565dd7465c32ed8b2416876ca284cc198d29ff8df2915157c783f5716be2c"
        hex"d5e841962f3ee7a17d487883e7424277ae3e547e6595444691e366b47183051477"
        hex"33db4b18d04795337933ec62d9644c88b97957c68a265777962e60241581f72bb2"
        hex"a3b770c5787e490e43e75c99c44f7c46e483e6067394c67bc5ad4f27a070760fa9"
        hex"a6b672546445a3abbba53472abf95c229d83e4836426675ff51552fab18db7dd40"
        hex"376d6b34c74b87284b2a2b6517cd67e81456e6267e25df7a365f3ecbde8e6c1d77"
        hex"038a8284134db9c556379154976e6a5b057d1672554ca851753b78e43672572a69"
        hex"17fd5ba7d85de79780979f5f18e18206086d488f4baabe8d5b6a9cf688912b187b"
        hex"38fc8a383abce6cc8566a58fa7f98308189146586fa6f2c9776777876e65b89e78"
        hex"aa527498e577384583e822bf780f78c6c78288bfa3697a9366843eeb0352a94a86"
        hex"88898b371865b848d0c87689a6f15f378b76579e89981c7b79856f171679483a8d"
        hex"25b35377405b86f685e8936a4a5591d7e871d8407a98728ff8678ab7de8748547f"
        hex"17d541dc9e78481965d70a82371d7fa72484379076f93e5ab872a4c8b7a7a8dc91"
        hex"585d5f0a147e16d4bf371392aa1693e925aba9d39919399208fa7e771e7569466a"
        hex"66586509e58f6853";

    // -------------------------------------------------------------------------
    // Functions
    // -------------------------------------------------------------------------

    /// @notice Returns the name of the city the run took place in on a given
    /// day.
    /// @dev Valid values for `_day` are in `[0, 554]`. The function does not
    /// handle invalid `_day` values.
    /// @param _day 0-indexed day to get the location data for.
    /// @return string memory The name of the city the run took place.
    /// @return uint256 The length of the city's name.
    function getDayLocation(uint256 _day) internal pure returns (string memory, uint256) {
        // The corresponding location data is stored at bits
        // `[4 * _day + 4, 4 * _day + 8)`, so the index of the byte we want to
        // retrieve is `(4 * _ day + 4) >> 3`, which is equivalent to
        // `(_day + 1) >> 1`.
        uint256 index;
        assembly {
            // Equivalent to `index = (_day + 1) >> 1`.
            index := shr(1, add(_day, 1))
        }
        uint256 value = (uint8(LOCATION_DATA[index]) >> (_day & 1 == 0 ? 0 : 4)) & 0xf;

        if (value == 0) return ("new york city", 13);
        if (value == 1) return ("san francisco", 13);
        if (value == 2) return ("seoul", 5);
        if (value == 3) return ("huntington beach", 16);
        if (value == 4) return ("westminister", 12);
        if (value == 5) return ("milan", 5);
        if (value == 6) return (unicode"luštica bay", 11);
        if (value == 7) return ("shanghai", 8);
        if (value == 8) return ("paris", 5);
        if (value == 9) return (unicode"reykjavík", 9);
        if (value == 10) return ("selfoss", 7);
        if (value == 11) return ("scotts valley", 13);
        if (value == 12) return ("redwood city", 12);
        if (value == 13) return ("jeju", 4);
        if (value == 14) return ("kagoshima", 9);
        return ("denver", 6);
    }

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

            // If `_day` is even, the relevant data is stored at the first
            // byte's 4 most significant bits, and the second byte's 8 least
            // significant bits. Similarly, if `_day` is odd, the relevant
            // data is stored at the first byte's 8 least significant bits,
            // and the second byte's 4 most significant bits.
            return _day & 1 == 0 ? ((a & 0xf) << 8) | b : (a << 4) | ((b >> 4) & 0xf);
        }
    }
}
