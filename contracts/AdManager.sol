//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ITokens.sol";

contract AdManager {
    ITokens private token;

    constructor(address _tokenAddress) {
        token = ITokens(_tokenAddress);
    }

    function getAd(uint _adId) public view returns (ITokens.Ad memory) {
        return token.getAd(_adId);
    }

    function getVideo(uint _id) public view returns (ITokens.Video memory) {
        return token.getVideo(_id);
    }

    function displayAd(uint _videoId, uint _AdId) public {
        ITokens.Video memory video = getVideo(_videoId);
        ITokens.Ad memory ad = getAd(_AdId);
        require(video.AdsEnabled == true, "Ads are not enabled for this video");
        require(ad.Active == true, "Ad is not active");
        require(ad.MaxBudget > ad.TotalSpent, "Ad has reached its budget");
        uint PublisherReward = video.DisplayReward *
            (video.OwnerPercentage / 100);
        uint BenefeciariesReward = video.DisplayReward *
            (video.HoldersPercentage / 100);
        token._safeTransferFrom(
            address(this),
            video.Owner,
            0,
            PublisherReward,
            ""
        );
        for (uint i = 0; i < video.Benefeciaries.length; i++) {
            token._safeTransferFrom(
                address(this),
                video.Benefeciaries[i],
                0,
                BenefeciariesReward / video.Benefeciaries.length,
                ""
            );
        }
    }
}
