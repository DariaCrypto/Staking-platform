import pytest

from brownie import AToken, BToken, RewardToken, Staking, StakeToken, accounts

CLAIM_TIME = 600
UNSTAKE_TIME = 1200


@pytest.fixture
def stakeToken():
    return accounts[0].deploy(StakeToken)


@pytest.fixture
def aToken():
    return accounts[0].deploy(AToken, accounts[0], 100e18)


@pytest.fixture
def bToken():
    return accounts[0].deploy(BToken, accounts[0], 100e18)


@pytest.fixture
def rewardToken():
    return accounts[0].deploy(RewardToken, accounts[0], 100e18)


@pytest.fixture
def staking(bToken, rewardToken):
    return accounts[0].deploy(Staking, bToken.address, rewardToken.address,
                              CLAIM_TIME, UNSTAKE_TIME, 30)


def test_staking_info(staking):
    infoStake = staking.infoStake.call({'from': accounts[0]})
    assert infoStake == (CLAIM_TIME, UNSTAKE_TIME, 30)
