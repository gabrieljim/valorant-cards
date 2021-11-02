//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

interface ILink {
    function transfer(address _to, uint256 _value) external returns (bool);

    function balanceOf(address _owner) external returns (uint256 balance);
}

contract ValorantCards is Ownable, ERC1155, VRFConsumerBase, ChainlinkClient {
    using Chainlink for Chainlink.Request;

    address private linkToken;

    // Chainlink VRF
    bytes32 private keyHash;
    uint256 private vrfFee;

    uint256 public randomResult;

    // Chainlink API calls
    address private oracle;
    bytes32 private jobId;
    uint256 private oracleFee;

    uint256 public playerLevel;

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
        bytes32 _keyHash,
        address _oracle,
        bytes32 _jobId,
        uint256 _oracleFee
    ) ERC1155("") VRFConsumerBase(_vrfCoordinator, _linkToken) {
        setPublicChainlinkToken();

        linkToken = _linkToken;
        keyHash = _keyHash;
        vrfFee = 0.1 * 10**18;

        oracle = _oracle;
        jobId = _jobId;
        oracleFee = _oracleFee;

        for (
            uint8 i = uint8(WEAPONS.CLASSIC);
            i <= uint8(WEAPONS.OPERATOR);
            i++
        ) {
            _mint(address(this), i, 1, "");
        }
    }

    function requestUserLevel() public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        request.add(
            "get",
            "https://api.henrikdev.xyz/valorant/v1/account/draven/2023"
        );
        request.add("path", "data.account_level");

        return sendChainlinkRequestTo(oracle, request, oracleFee);
    }

    function fulfill(bytes32 _requestId, uint256 _level)
        public
        recordChainlinkFulfillment(_requestId)
    {
        playerLevel = _level;
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= vrfFee, "NOT_ENOUGH_LINK");
        return requestRandomness(keyHash, vrfFee);
    }

    function fulfillRandomness(bytes32 _requestId, uint256 _randomness)
        internal
        override
    {
        randomResult = _randomness;
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

    function withdrawLink() external onlyOwner {
        uint256 amount = ILink(linkToken).balanceOf(address(this));
        ILink(linkToken).transfer(owner(), amount);
    }
}
