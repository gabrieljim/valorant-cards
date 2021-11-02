//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ValorantTracker is ERC1155, ChainlinkClient, Ownable {
    using Chainlink for Chainlink.Request;

    uint8 public constant CLASSIC = 0;
    uint8 public constant SHORTY = 1;
    uint8 public constant FRENZY = 2;
    uint8 public constant GHOST = 3;
    uint8 public constant SHERIFF = 4;
    uint8 public constant BUCKY = 5;
    uint8 public constant STINGER = 6;
    uint8 public constant MARSHAL = 7;
    uint8 public constant ARES = 8;
    uint8 public constant SPECTRE = 9;
    uint8 public constant JUDGE = 10;
    uint8 public constant BULLDOG = 11;
    uint8 public constant GUARDIAN = 12;
    uint8 public constant PHANTOM = 13;
    uint8 public constant VANDAL = 14;
    uint8 public constant ODIN = 15;
    uint8 public constant OPERATOR = 16;

    constructor() ERC1155("") {
        setPublicChainlinkToken();
        _mint(address(this), CLASSIC, 1, "");
        _mint(address(this), SHORTY, 1, "");
        _mint(address(this), FRENZY, 1, "");
        _mint(address(this), GHOST, 1, "");
        _mint(address(this), SHERIFF, 1, "");
        _mint(address(this), BUCKY, 1, "");
        _mint(address(this), STINGER, 1, "");
        _mint(address(this), MARSHAL, 1, "");
        _mint(address(this), ARES, 1, "");
        _mint(address(this), SPECTRE, 1, "");
        _mint(address(this), JUDGE, 1, "");
        _mint(address(this), BULLDOG, 1, "");
        _mint(address(this), GUARDIAN, 1, "");
        _mint(address(this), PHANTOM, 1, "");
        _mint(address(this), VANDAL, 1, "");
        _mint(address(this), ODIN, 1, "");
        _mint(address(this), OPERATOR, 1, "");
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
