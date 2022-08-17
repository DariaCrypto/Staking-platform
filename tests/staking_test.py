import pytest

from brownie import AToken, BToken, RewardToken, Staking, StakeToken, accounts


def test_preprocess():
    claimTime = 600
    unstakeTime = 1200
    stakeToken = StakeToken.deploy({'from': accounts[0]})
    aToken = AToken.deploy(accounts[0], 100e18, {'from': accounts[0]})
    bToken = BToken.deploy(accounts[0], 100e18, {'from': accounts[0]})
    rewardToken = RewardToken.deploy(
        accounts[0], 100e18, {'from': accounts[0]})
    staking = Staking.deploy(bToken.address, rewardToken.address,
                             claimTime, unstakeTime, 30, {'from': accounts[0]})

    infoStake = staking.infoStake.call({'from': accounts[0]})
    assert infoStake == (claimTime, unstakeTime, 30)
