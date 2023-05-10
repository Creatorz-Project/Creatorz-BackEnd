//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITokens {
    struct SocialToken {
        uint ID;
        string URI;
        uint256 totalSupply;
        uint circulatingSupply;
        uint price;
        bool launched;
        uint revenueSplit;
        address creator;
        uint maxHoldingAmount;
        uint videoIds;
    }

    struct Video {
        uint Id;
        string URI;
        address Owner;
        address Creator;
        uint Price;
        uint SocialTokenId;
        uint OwnerPercentage;
        uint HoldersPercentage;
        address[] Benefeciaries;
        bool Listed;
        bool Published;
        bool AdsEnabled;
        uint RoomId;
    }

    struct SocialTokenHolder {
        uint Id;
        uint amount;
        uint price;
        uint currentlyListed;
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

    struct Room {
        uint Id;
        string URI;
        address Creator;
        address Owner;
        uint Price;
        uint DisplayReward;
        uint[] VideoIds;
        bool Listed;
    }

    function getSocialToken(
        uint _id
    ) external view returns (SocialToken memory);

    function getAd(uint _adId) external view returns (Ad memory);

    function getVideo(uint _id) external view returns (Video memory);

    function getRoom(uint _id) external view returns (Room memory);

    function getSocialTokenHolder(
        uint _id,
        address _account
    ) external view returns (SocialTokenHolder memory);

    function getBalance(
        address _account,
        uint _id
    ) external view returns (uint256);

    function transferTokens(
        address _from,
        address _to,
        uint256 _amount,
        uint _id
    ) external;

    function transferBatch(
        address _from,
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts
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

    function updateVideoParameters(
        uint _id,
        address _owner,
        uint _price,
        address _beneficiary,
        uint _action,
        bool _listed,
        bool _published,
        bool _AdsEnabled,
        uint _OwnerPercentage,
        uint _HoldersPercentage,
        uint _socialTokenId,
        uint _roomId
    ) external ;

    function updateRoomParameters(
        uint _id,
        address _owner,
        uint _price,
        uint _displayCharge,
        uint _videoId,
        uint _action,
        bool _listed
    ) external;

    function updateSocialTokenParameters(
        uint _id,
        uint _circulatingSupply,
        uint price,
        bool _launched,
        uint _revenueSplit,
        uint videoId
    ) external;

    function updateSocialTokenHolderParameters(
        uint _id,
        uint _amount,
        uint _price,
        uint _currentlyListed,
        address _account
    ) external;
}
