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
        uint[] roomIds;
    }
    struct userHoldings {
        uint Id;
        uint amount;
    }

    mapping(uint => SocialToken) private socialTokens;
    mapping(address => mapping(uint => userHoldings)) private userSocialTokens;

    event TokenMinted(
        uint ID,
        string URI,
        uint256 amount,
        uint price,
        bool launched,
        uint revenueSplit,
        address creator,
        uint maxHoldingAmount,
        uint[] videoIds,
        uint[] roomIds
    );
    event TokenSold(uint Id, uint amount, address seller, address buyer);
    event TokenLaunched(uint Id);

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
        uint[] memory _videoIds,
        uint[] memory _roomIds
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
            _videoIds,
            _roomIds
        );
        socialTokens[newTokenId] = newToken;
        userSocialTokens[msg.sender][newTokenId] = userHoldings(
            newTokenId,
            _amount
        );
        emit TokenMinted(
            newTokenId,
            _URI,
            _amount,
            _price,
            false,
            _revenueSplit,
            msg.sender,
            _maxHoldingAmount,
            _videoIds,
            _roomIds
        );
    }

    function launchSocialTokens(uint _id) public {
        require(
            socialTokens[_id].creator == msg.sender,
            "You are not the creator of this token"
        );
        require(
            socialTokens[_id].launched == false,
            "This token is already launched"
        );
        socialTokens[_id].launched = true;
        socialTokens[_id].circulatingSupply = socialTokens[_id].totalSupply;
        userSocialTokens[msg.sender][_id].amount = socialTokens[_id]
            .totalSupply;
        emit TokenLaunched(_id);
    }

    function buySocialToken(
        uint _id,
        uint _amount,
        address _seller
    ) public payable {
        require(balanceOf(_seller, _id) >= _amount, "Not enough tokens");
        require(
            balanceOf(msg.sender, CreatorzToken) >=
                socialTokens[_id].price * _amount,
            "Not enough Creatorz tokens"
        );
        require(
            socialTokens[_id].maxHoldingAmount >=
                userSocialTokens[msg.sender][_id].amount + _amount,
            "You can't hold more than the max holding amount"
        );
        require(
            userSocialTokens[_seller][_id].amount <= _amount,
            "Seller Doesnt have enough tokens"
        );
        _safeTransferFrom(_seller, msg.sender, _id, _amount, "");
        _safeTransferFrom(
            msg.sender,
            _seller,
            CreatorzToken,
            socialTokens[_id].price * _amount,
            ""
        );
        userSocialTokens[msg.sender][_id].amount += _amount;
        userSocialTokens[_seller][_id].amount -= _amount;
        socialTokens[_id].circulatingSupply -= _amount;
        emit TokenSold(_id, _amount, _seller, msg.sender);
    }
}
