//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITokens {
    struct Video {
        uint id;
        string URI;
        uint256 price;
        uint256 views;
        uint256 likes;
        uint256 dislikes;
        uint256 shares;
        uint256 comments;
        uint256 total;
        uint256 timestamp;
    }
    struct SocialToken {
        uint id;
        string URI;
        uint256 totalSupply;
        uint256 circulatingSupply;
        uint256 price;
        bool launched;
        uint256 revenueSplit;
        address creator;
        uint256 maxHoldingAmount;
        uint[] videoIds;
    }
    struct Room {
        uint id;
        string URI;
        address creator;
        address owner;
        uint256 price;
        uint[] videoIds;
    }

    function getVideo(uint _id) external view returns (Video memory);

    function getSocialToken(
        uint _id
    ) external view returns (SocialToken memory);

    function getRoom(uint _id) external view returns (Room memory);
}
