import pytest
import brownie
from brownie import StakeToken, RewardToken, Pool, accounts, chain

CLAIM_TIME = 600
UNSTAKE_TIME = 1200


@pytest.fixture
def stakeToken():
    return accounts[0].deploy(StakeToken, accounts[0], 100e18)


@pytest.fixture
def rewardToken():
    return accounts[0].deploy(RewardToken)


@pytest.fixture
def pool(stakeToken, rewardToken):
    return accounts[0].deploy(Pool, stakeToken.address, rewardToken.address,
                              CLAIM_TIME, UNSTAKE_TIME, 30)


def test_staking_info(pool):
    infoPool = pool.getInfoPool.call({'from': accounts[0]})
    assert infoPool == (CLAIM_TIME, UNSTAKE_TIME, 30)


def test_stake(pool, stakeToken):
    stakeToken.approve(pool.address, 100)
    with brownie.reverts():
        pool.stake.call(10, {'from': accounts[1]})
    pool.stake.call(10, {'from': accounts[0]})
    stakeInfo = pool.getInfoStake.call({'from': accounts[0]})
    assert stakeInfo == (10, chain.time)
