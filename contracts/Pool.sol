// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "OpenZeppelin/openzeppelin-contracts@4.4.2/contracts/token/ERC20/IERC20.sol";

contract Pool {
    struct PoolParametrs {
        uint256 claimTime;
        uint256 unstakeTime;
        uint8 procent;
    }

    struct Stake {
        uint256 investedAmount;
        uint256 timeInvested;
    }
    PoolParametrs poolParametrs;
    mapping(address => Stake) internal stakers;
    address rewardToken;
    address stakeToken;
    error ClaimTime();
    error UnstakeTime();
    error MinimalAmount();

    constructor(
        address stakeToken_,
        address rewardToken_,
        uint256 claimTime_,
        uint256 unstakeTime_,
        uint8 procent_
    ) {
        stakeToken = stakeToken_;
        rewardToken = rewardToken_;
        poolParametrs.claimTime = claimTime_;
        poolParametrs.unstakeTime = unstakeTime_;
        poolParametrs.procent = procent_;
    }

    function getInfoPool() external returns (PoolParametrs memory) {
        return (
            PoolParametrs(
                poolParametrs.claimTime,
                poolParametrs.unstakeTime,
                poolParametrs.procent
            )
        );
    }

    function getInfoStake() external returns (Stake memory) {
        Stake storage stake = stakers[msg.sender];
        return (Stake(stake.investedAmount, stake.timeInvested));
    }

    function stake(uint256 amount) external {
        if (IERC20(stakeToken).balanceOf(msg.sender) < 1)
            revert MinimalAmount();

        IERC20(stakeToken).transferFrom(msg.sender, address(this), amount);
        stakers[msg.sender].investedAmount += amount;
        stakers[msg.sender].timeInvested = block.timestamp;
    }

    function claim() external {
        if (block.timestamp < poolParametrs.claimTime) revert ClaimTime();
        uint256 rewardAmount = _calcProcent(
            stakers[msg.sender].investedAmount,
            poolParametrs.procent
        );
        IERC20(rewardToken).transfer(msg.sender, rewardAmount);
    }

    function unstake() external {
        if (block.timestamp < poolParametrs.unstakeTime) revert UnstakeTime();
        uint256 rewardAmount = _calcProcent(
            stakers[msg.sender].investedAmount,
            poolParametrs.procent
        );
        stakers[msg.sender].investedAmount = 0;
        IERC20(rewardToken).transfer(msg.sender, rewardAmount);
        IERC20(stakeToken).transfer(
            msg.sender,
            stakers[msg.sender].investedAmount
        );
    }

    function _calcProcent(uint256 amount, uint8 procent)
        internal
        pure
        returns (uint256)
    {
        return (amount * procent) / 100;
    }
}
