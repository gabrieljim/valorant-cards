//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract ValorantCards is Ownable, ERC1155, VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;

    uint256 public randomResult;

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

    constructor(
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash
    ) ERC1155("") VRFConsumerBase(_vrfCoordinator, _linkToken) {
        keyHash = _keyHash;
        fee = 0.1 * 10**18;

        for (
            uint8 i = uint8(WEAPONS.CLASSIC);
            i <= uint8(WEAPONS.OPERATOR);
            i++
        ) {
            _mint(address(this), i, 1, "");
        }
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "NOT_ENOUGH_LINK");
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        randomResult = randomness;
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
