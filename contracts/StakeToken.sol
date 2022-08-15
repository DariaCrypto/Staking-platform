// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "interfaces/IUniswapV2Router01.sol";

contract StakeToken {
    address uniswap = 0xf164fC0Ec4E93095b804a4795bBe1e041497b92a;

    function getStakeToken(address AToken, address BToken) external {
        IUniswapV2Router01(uniswap).addLiquidity(
            AToken,
            BToken,
            1 ether,
            1 ether,
            1 ether,
            1 ether,
            msg.sender,
            block.timestamp + 1
        );
    }
}
