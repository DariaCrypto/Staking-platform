// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "interfaces/IUniswapV2ERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@4.4.2/contracts/token/ERC20/IERC20.sol";

contract Staking {
    struct StakingParametrs {
        uint256 claimTime;
        uint256 unstakeTime;
        uint8 procent;
    }

    struct Stake {
        uint256 investedAmount;
        uint256 timeInvested;
    }
    StakingParametrs stakingParametrs;
    mapping(address => Stake) internal stakers;
    address liquidity;
    address rewardToken;
    error ClaimTime();
    error UnstakeTime();
    error MinimalAmount();

    constructor(
        address liquidity_,
        address rewardToken_,
        uint256 claimTime_,
        uint256 unstakeTime_,
        uint8 procent_
    ) {
        liquidity = liquidity_;
        rewardToken = rewardToken_;
        stakingParametrs.claimTime = claimTime_;
        stakingParametrs.unstakeTime = unstakeTime_;
        stakingParametrs.procent = procent_;
    }

    function infoStake() external returns (StakingParametrs memory) {
        return (
            StakingParametrs(
                stakingParametrs.claimTime,
                stakingParametrs.unstakeTime,
                stakingParametrs.procent
            )
        );
    }

    function stake(uint256 amount) external {
        if (IUniswapV2ERC20(liquidity).balanceOf(msg.sender) < 1)
            revert MinimalAmount();

        IUniswapV2ERC20(liquidity).transferFrom(
            msg.sender,
            address(this),
            amount
        );
        stakers[msg.sender].investedAmount += amount;
    }

    function claim() external {
        if (block.timestamp < stakingParametrs.claimTime) revert ClaimTime();
        uint256 rewardAmount = _calcProcent(
            stakers[msg.sender].investedAmount,
            stakingParametrs.procent
        );
        IERC20(rewardToken).transfer(msg.sender, rewardAmount);
    }

    function unstake() external {
        if (block.timestamp < stakingParametrs.unstakeTime)
            revert UnstakeTime();
        uint256 rewardAmount = _calcProcent(
            stakers[msg.sender].investedAmount,
            stakingParametrs.procent
        );
        stakers[msg.sender].investedAmount = 0;
        IERC20(rewardToken).transfer(msg.sender, rewardAmount);
        IUniswapV2ERC20(liquidity).transfer(
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
