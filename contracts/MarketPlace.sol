//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ITokens.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract MarketPlace is ERC1155Holder {
    ITokens private token;

    event VideoListed(uint _id, uint _price);
    event VideoUnlisted(uint _id);
    event VideoPurchased(
        uint _id,
        address _buyer,
        address _seller,
        uint _price
    );
    event RoomListed(uint _id, uint _price);
    event RoomUnlisted(uint _id);
    event RoomPurchased(uint _id, address _buyer, address _seller, uint _price);

    constructor(address _token) {
        token = ITokens(_token);
    }

    function getVideo(uint _id) external view returns (ITokens.Video memory) {
        return token.getVideo(_id);
    }

    function getRoom(uint _id) external view returns (ITokens.Room memory) {
        return token.getRoom(_id);
    }

    function getSocialToken(
        uint _id
    ) external view returns (ITokens.SocialToken memory) {
        return token.getSocialToken(_id);
    }

    function listVideo(uint _id, uint _price) public {
        ITokens.Video memory video = token.getVideo(_id);
        require(
            video.Owner == msg.sender,
            "You are not the owner of this video"
        );
        require(video.Listed == false, "Video is already listed");
        token.updateVideoParameters(
            _id,
            msg.sender,
            _price,
            address(0),
            2,
            true,
            video.Published,
            video.AdsEnabled,
            video.RoomId
        );
        token.transferTokens(msg.sender, address(this), _id, 1);
        emit VideoListed(_id, _price);
    }

    function unlistVideo(uint _id) public {
        ITokens.Video memory video = token.getVideo(_id);
        require(
            video.Owner == msg.sender,
            "You are not the owner of this video"
        );
        require(video.Listed == true, "Video is not listed");
        token.updateVideoParameters(
            _id,
            msg.sender,
            0,
            address(0),
            2,
            false,
            video.Published,
            video.AdsEnabled,
            video.RoomId
        );
        token.transferTokens(address(this), msg.sender, _id, 1);
    }

    function buyVideo(uint _id, uint _roomId) public {
        ITokens.Video memory video = token.getVideo(_id);
        address currentOwner = video.Owner;
        require(video.Listed == true, "Video is not listed");
        require(
            token.getRoom(_roomId).Owner == msg.sender,
            "You are not the owner of this room"
        );
        token.transferTokens(address(this), msg.sender, _id, 1);
        token.transferTokens(msg.sender, address(this), 0, video.Price);
        token.updateVideoParameters(
            _id,
            msg.sender,
            0,
            currentOwner,
            0,
            false,
            video.Published,
            video.AdsEnabled,
            _roomId
        );
        token.updateVideoParameters(
            _id,
            msg.sender,
            0,
            msg.sender,
            1,
            false,
            video.Published,
            video.AdsEnabled,
            video.RoomId
        );
        emit VideoPurchased(_id, msg.sender, currentOwner, video.Price);
    }

    function listRoom(uint _id, uint _price) public {
        ITokens.Room memory room = token.getRoom(_id);
        require(room.Owner == msg.sender, "You are not the owner of this room");
        require(room.Listed == false, "Room is already listed");
        token.updateRoomParameters(
            _id,
            msg.sender,
            _price,
            room.DisplayReward,
            0,
            2,
            true
        );
        token.transferTokens(msg.sender, address(this), _id, 1);
        uint[] memory amounts = new uint[](room.VideoIds.length);
        for (uint i = 0; i < room.VideoIds.length; i++) {
            amounts[i] = 1;
        }
        token.transferBatch(msg.sender, address(this), room.VideoIds, amounts);
        emit RoomListed(_id, _price);
    }

    function unListRoom(uint _id) public {
        ITokens.Room memory room = token.getRoom(_id);
        require(room.Owner == msg.sender, "You are not the owner of this room");
        require(room.Listed == true, "Room is not listed");
        token.updateRoomParameters(
            _id,
            msg.sender,
            0,
            room.DisplayReward,
            0,
            2,
            false
        );
        token.transferTokens(address(this), msg.sender, _id, 1);
        uint[] memory amounts = new uint[](room.VideoIds.length);
        for (uint i = 0; i < room.VideoIds.length; i++) {
            amounts[i] = 1;
        }
        token.transferBatch(address(this), msg.sender, room.VideoIds, amounts);
        emit RoomUnlisted(_id);
    }

    function buyRoom(uint _id) public {
        ITokens.Room memory room = token.getRoom(_id);
        require(room.Listed == true, "Room is not listed");
        token.transferTokens(address(this), msg.sender, _id, 1);
        token.transferTokens(msg.sender, address(this), 0, room.Price);
        uint[] memory amounts = new uint[](room.VideoIds.length);
        for (uint i = 0; i < room.VideoIds.length; i++) {
            amounts[i] = 1;
        }
        token.transferBatch(address(this), msg.sender, room.VideoIds, amounts);
        token.updateRoomParameters(
            _id,
            msg.sender,
            0,
            room.DisplayReward,
            0,
            2,
            false
        );
        for (uint i = 0; i < room.VideoIds.length; i++) {
            token.updateVideoParameters(
                room.VideoIds[i],
                msg.sender,
                0,
                address(0),
                2,
                false,
                false,
                false,
                _id
            );
        }
        emit RoomPurchased(_id, msg.sender, room.Owner, room.Price);
    }
}
