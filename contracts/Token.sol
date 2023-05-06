//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";

contract Token is ERC1155URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint private CreatorzToken;

    address private _owner;

    constructor() ERC1155(" ") {
        _owner = msg.sender;
        CreatorzToken = _tokenIds.current();
    }

    function getCreatorzTokens() public {
        _mint(msg.sender, CreatorzToken, 10 ether, "");
    }
}
