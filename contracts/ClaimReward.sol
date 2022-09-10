// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.5;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

abstract contract SkyToken {

    function leftSupply() virtual view public returns(uint256);
    function mint(address to, uint256 amount) virtual external;
    function burn(uint amount)virtual external;
}
contract ClaimReward{

    SkyToken private token;

    address public owner;

    uint public _rollOverAmount;
    uint public _dailyRewardAmount = 15000;
    uint public _lastClaimTime;
    uint public _contractPublishTime;

    event RewardClaimed(address _to,uint _amount);


    constructor(address tokenAddress, uint dailyRewardAmount) {
        owner = msg.sender;
        token = SkyToken(tokenAddress);
        _rollOverAmount = dailyRewardAmount;
        _dailyRewardAmount = dailyRewardAmount;
        _contractPublishTime = block.timestamp;
    }
    modifier onlyOwner {
      require(msg.sender == owner, "Only onwer of the contract can claim reward");
      _;
    }

    function OwnerReward(uint256 amount) onlyOwner payable public {
        
        require(amount > 0 && amount < 1500000000, "Invalid amount value.");

        uint timeDifference;
        if(_lastClaimTime == 0)
            timeDifference = block.timestamp - _contractPublishTime;
        else 
        {
            timeDifference = block.timestamp - _lastClaimTime;
            require((timeDifference)/3600 > 24, "Only one claim request can be made within 24 hours.");
        }

        uint claimableAmount = (((timeDifference)/86400) * _dailyRewardAmount) + _rollOverAmount;

        require(amount <= claimableAmount,"Amount value is more than claimable");
        require(amount <= token.leftSupply(), "Balance is low");
        
        _rollOverAmount = claimableAmount - amount;
        _lastClaimTime = block.timestamp;
        token.mint(owner,amount);

        emit RewardClaimed(owner,amount);
    }
}