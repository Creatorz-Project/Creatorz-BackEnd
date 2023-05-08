//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

contract Token is ERC1155URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint private CreatorzToken;

    address private _owner;

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
        uint[] videoIds;
    }

    struct Video {
        uint Id;
        string URI;
        address Owner;
        address Creator;
        uint Price;
        uint SocialTokenId;
        uint DisplayReward;
        uint ClickReward;
        uint OwnerPercentage;
        uint HoldersPercentage;
        address[] Benefeciaries;
        bool AdsEnabled;
        uint RoomId;
    }

    struct Ad {
        uint Id;
        string URI;
        address Advertiser;
        uint[] PublishingRooms;
        bool Active;
        uint TotalSpent;
        uint MaxBudget;
    }

    struct Room {
        uint Id;
        string URI;
        address Creator;
        address Owner;
        uint Price;
        uint[] VideoIds;
    }

    mapping(uint => SocialToken) private socialTokens;
    mapping(uint => Video) private videos;
    mapping(uint => Room) private rooms;
    mapping(uint => Ad) private ads;

    event TokenMinted(
        uint ID,
        string URI,
        uint256 amount,
        uint price,
        bool launched,
        uint revenueSplit,
        address creator,
        uint maxHoldingAmount,
        uint[] videoIds
    );

    event VideoMinted(uint Id, string URI, address Owner);
    event RoomMinted(uint Id, string URI, address Owner);
    event TokenSold(uint Id, uint amount, address seller, address buyer);
    event TokenLaunched(uint Id);
    event TokenListed(uint Id, uint price, uint amount);
    event AdCreated(uint Id, string URI, address Advertiser);

    constructor() ERC1155(" ") {
        _owner = msg.sender;
        CreatorzToken = _tokenIds.current();
    }

    function getCreatorzTokens() public {
        _mint(msg.sender, CreatorzToken, 10 ether, "");
    }

    function mintSocialTokens(
        uint _amount,
        uint _revenueSplit,
        uint _price,
        string memory _URI,
        uint _maxHoldingAmount,
        uint[] memory _videoIds
    ) public {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId, _amount, "");
        _setURI(newTokenId, _URI);
        SocialToken memory newToken = SocialToken(
            newTokenId,
            _URI,
            _amount,
            0,
            _price,
            false,
            _revenueSplit,
            msg.sender,
            _maxHoldingAmount,
            _videoIds
        );
        socialTokens[newTokenId] = newToken;
        emit TokenMinted(
            newTokenId,
            _URI,
            _amount,
            _price,
            false,
            _revenueSplit,
            msg.sender,
            _maxHoldingAmount,
            _videoIds
        );
    }

    function mintVideo(string memory _URI, uint _roomId) public {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId, 1, "");
        _setURI(newTokenId, _URI);
        Video memory newVideo = Video(
            newTokenId,
            _URI,
            msg.sender,
            msg.sender,
            0,
            0,
            0,
            0,
            0,
            0,
            new address[](0),
            false,
            _roomId
        );
        videos[newTokenId] = newVideo;
        emit VideoMinted(newTokenId, _URI, msg.sender);
    }

    function createRoom(string memory _URI) public {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId, 1, "");
        _setURI(newTokenId, _URI);
        Room memory newRoom = Room(
            newTokenId,
            _URI,
            msg.sender,
            msg.sender,
            0,
            new uint[](0)
        );
        rooms[newTokenId] = newRoom;
        emit RoomMinted(newTokenId, _URI, msg.sender);
    }

    function createAd(string memory _uri) public {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId, 1, "");
        _setURI(newTokenId, _uri);
        Ad memory newAd = Ad(
            newTokenId,
            _uri,
            msg.sender,
            new uint[](0),
            false,
            0,
            0
        );
        ads[newTokenId] = newAd;
        emit AdCreated(newTokenId, _uri, msg.sender);
    }

    function getVideo(uint _id) external view returns (Video memory) {
        return videos[_id];
    }

    function getAd(uint _id) external view returns (Ad memory) {
        return ads[_id];
    }

    function getSocialToken(
        uint _id
    ) external view returns (SocialToken memory) {
        return socialTokens[_id];
    }
}
