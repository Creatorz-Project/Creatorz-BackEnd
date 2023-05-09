//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITokens {
    struct Video {
        uint Id;
        string URI;
        address Owner;
        address Creator;
        uint Price;
        uint SocialTokenId;
        uint ClickReward;
        uint OwnerPercentage;
        uint HoldersPercentage;
        address[] Benefeciaries;
        bool AdsEnabled;
        uint RoomId;
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
        uint DisplayReward;
        uint[] videoIds;
    }

    struct Ad {
        uint Id;
        string URI;
        address Advertiser;
        uint[] PublishingRooms;
        bool Active;
        uint TotalSpent;
        uint CurrentBudget;
        uint MaxBudget;
    }

    function getSocialToken(
        uint _id
    ) external view returns (SocialToken memory);

    function getAd(uint _adId) external view returns (Ad memory);

    function getVideo(uint _id) external view returns (Video memory);

    function getRoom(uint _id) external view returns (Room memory);

    function transferCreatorzTokens(
        address _from,
        address _to,
        uint256 _amount
    ) external;

    function updateAdParameters(
        uint _id,
        uint _roomId,
        uint roomAdded,
        bool _status,
        uint _totalSpent,
        uint _currentBudget,
        uint _maxBudget
    ) external;
}
