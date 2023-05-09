//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ITokens.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract AdManager is ERC1155Holder {
    ITokens private token;

    event CampaignStarted(uint AdId, uint MaxBudget);
    event CampaignStopped(uint AdId, uint RemainingBudget);
    event AdDisplayed(uint VideoId, uint AdId, uint Reward);
    event PublisherRoomAdded(uint RoomId, uint AdId);
    event PublisherRoomRemoved(uint RoomId, uint AdId);

    constructor(address _tokenAddress) {
        token = ITokens(_tokenAddress);
    }

    function getVideo(uint _id) public view returns (ITokens.Video memory) {
        return token.getVideo(_id);
    }

    function getAd(uint _adId) public view returns (ITokens.Ad memory) {
        return token.getAd(_adId);
    }

    function startCampaign(uint _AdId, uint _maxBudget) public {
        ITokens.Ad memory ad = getAd(_AdId);
        require(ad.Active == false, "Ad is already active");
        token.updateAdParameters(
            _AdId,
            0,
            2,
            true,
            ad.TotalSpent,
            ad.CurrentBudget + _maxBudget,
            ad.CurrentBudget + _maxBudget
        );
        token.transferCreatorzTokens(ad.Advertiser, address(this), _maxBudget);
        emit CampaignStarted(_AdId, _maxBudget);
    }

    function stopCampaign(uint _AdId) public {
        ITokens.Ad memory ad = getAd(_AdId);
        require(ad.Active == true, "Ad is not active");
        token.updateAdParameters(
            _AdId,
            0,
            2,
            false,
            ad.TotalSpent,
            ad.CurrentBudget,
            ad.CurrentBudget
        );
        token.transferCreatorzTokens(
            address(this),
            ad.Advertiser,
            ad.CurrentBudget
        );
        emit CampaignStopped(_AdId, ad.CurrentBudget);
    }

    function displayAd(uint _videoId, uint _AdId) public {
        ITokens.Video memory video = getVideo(_videoId);
        uint roomId = video.RoomId;
        ITokens.Ad memory ad = getAd(_AdId);
        ITokens.Room memory room = token.getRoom(roomId);
        require(ad.Active == true, "Ad is not active");
        require(video.AdsEnabled == true, "Ads are not enabled for this video");
        require(
            ad.CurrentBudget >= room.DisplayReward,
            "Ad has reached its budget"
        );
        uint publisherReward = room.DisplayReward *
            (video.OwnerPercentage / 100);
        uint beneficieriesReward = room.DisplayReward *
            (video.HoldersPercentage / 100);
        token.transferCreatorzTokens(
            address(this),
            video.Owner,
            publisherReward
        );
        for (uint i = 0; i < video.Benefeciaries.length; i++) {
            token.transferCreatorzTokens(
                address(this),
                video.Benefeciaries[i],
                beneficieriesReward
            );
        }
        token.updateAdParameters(
            _AdId,
            0,
            2,
            ad.Active,
            ad.TotalSpent + room.DisplayReward,
            ad.CurrentBudget - room.DisplayReward,
            ad.MaxBudget
        );
        emit AdDisplayed(_videoId, _AdId, room.DisplayReward);
    }

    function addPublishingRoom(uint _AdId, uint _RoomId) public {
        ITokens.Ad memory ad = getAd(_AdId);
        require(ad.Active == true, "Campaign is not active");
        require(
            ad.CurrentBudget >= token.getRoom(_RoomId).DisplayReward,
            "Ad has reached its budget"
        );
        for (uint i = 0; i < ad.PublishingRooms.length; i++) {
            require(
                ad.PublishingRooms[i] != _RoomId,
                "Room is already added to the campaign"
            );
        }
        token.updateAdParameters(
            _AdId,
            _RoomId,
            1,
            ad.Active,
            ad.TotalSpent,
            ad.CurrentBudget,
            ad.MaxBudget
        );
    }

    function removePublishingRoom(uint _AdId, uint _RoomId) public {
        ITokens.Ad memory ad = getAd(_AdId);
        require(ad.Active == true, "Campaign is not active");
        for (uint i = 0; i < ad.PublishingRooms.length; i++) {
            require(
                ad.PublishingRooms[i] == _RoomId,
                "Room is not added to the campaign"
            );
        }
        token.updateAdParameters(
            _AdId,
            _RoomId,
            0,
            ad.Active,
            ad.TotalSpent,
            ad.CurrentBudget,
            ad.MaxBudget
        );
        emit PublisherRoomRemoved(_RoomId, _AdId);
    }
}
