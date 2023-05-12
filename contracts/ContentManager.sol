//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ITokens.sol";

contract ContentManager {
    ITokens private tokens;

    constructor(address _tokens) {
        tokens = ITokens(_tokens);
    }

    event VideoPublished(
        uint videoId,
        uint roomId,
        address owner,
        address creator,
        string URI
    );
    event VideoUnpublished(uint videoId, uint roomId, address owner);
    event SocialTokenLaunched(
        uint tokenId,
        address creator,
        uint price,
        uint amount,
        uint videoIds
    );

    function publishVideo(
        uint _id,
        uint _ownerPercentage,
        uint _holdersPercentage,
        bool _adsEnabled
    ) public {
        require(
            tokens.getVideo(_id).Owner == msg.sender,
            "Only the creator can publish a video"
        );
        require(
            tokens.getVideo(_id).Published == false,
            "Video is already published"
        );
        ITokens.Video memory video = tokens.getVideo(_id);
        require(
            tokens.getSocialToken(video.SocialTokenId).launched == true,
            "Social token is not launched"
        );
        tokens.updateVideoParameters(
            _id,
            video.Owner,
            video.Price,
            address(0),
            2,
            false,
            true,
            _adsEnabled,
            video.RoomId
        );
        tokens.updateVideoRevenueParameters(
            _id,
            _ownerPercentage,
            _holdersPercentage
        );
        emit VideoPublished(
            _id,
            video.RoomId,
            video.Owner,
            video.Creator,
            video.URI
        );
    }

    function unpublishVideo(uint _id) public {
        require(
            tokens.getVideo(_id).Owner == msg.sender,
            "Only the creator can unpublish a video"
        );
        require(
            tokens.getVideo(_id).Published == false,
            "Video is already unpublished"
        );
        ITokens.Video memory video = tokens.getVideo(_id);
        tokens.updateVideoParameters(
            _id,
            video.Owner,
            video.Price,
            address(0),
            2,
            false,
            false,
            false,
            video.RoomId
        );
        emit VideoUnpublished(_id, video.RoomId, video.Owner);
    }

    function launchSocialToken(uint _id) public {
        require(
            tokens.getSocialToken(_id).creator == msg.sender,
            "Only the creator can launch a social token"
        );
        require(
            tokens.getSocialToken(_id).launched == false,
            "Social token is already launched"
        );
        ITokens.SocialToken memory socialToken = tokens.getSocialToken(_id);
        tokens.updateSocialTokenParameters(
            _id,
            socialToken.circulatingSupply,
            socialToken.price,
            true,
            socialToken.revenueSplit,
            socialToken.videoIds
        );
        tokens.updateSocialTokenHolderParameters(
            _id,
            socialToken.totalSupply,
            socialToken.price,
            socialToken.circulatingSupply,
            msg.sender
        );
        emit SocialTokenLaunched(
            _id,
            socialToken.creator,
            socialToken.price,
            socialToken.totalSupply,
            socialToken.videoIds
        );
    }
}
