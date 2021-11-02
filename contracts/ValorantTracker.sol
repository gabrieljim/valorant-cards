//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ValorantTracker is ERC1155, ChainlinkClient, Ownable {
    using Chainlink for Chainlink.Request;

    enum WEAPONS {
        CLASSIC,
        SHORTY,
        FRENZY,
        GHOST,
        SHERIFF,
        BUCKY,
        STINGER,
        MARSHAL,
        ARES,
        SPECTRE,
        JUDGE,
        BULLDOG,
        GUARDIAN,
        PHANTOM,
        VANDAL,
        ODIN,
        OPERATOR
    }

    constructor() ERC1155("") {
        setPublicChainlinkToken();

        for (
            uint8 i = uint8(WEAPONS.CLASSIC);
            i < uint8(WEAPONS.OPERATOR);
            i++
        ) {
            _mint(address(this), i, 1, "");
        }
    }

    function uri(uint256 _tokenId)
        public
        pure
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "https://gateway.pinata.cloud/ipfs/QmNsYjBYU9Vtefm7tgAHWQB1ovTTXMXwLT9LjXkwEgXd1i/",
                    Strings.toString(_tokenId),
                    ".json"
                )
            );
    }

    function contractURI() public pure returns (string memory) {
        return
            "https://gateway.pinata.cloud/ipfs/QmatYiY3xyMRmRwoDdpDm1yjTF6tih6e9PhaaZWoZsrLMz";
    }
}
