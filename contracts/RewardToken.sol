// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "OpenZeppelin/openzeppelin-contracts@4.4.2/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20 {
    constructor() ERC20("RewardToken", "RT") {}

    function mintTo(address mintAddress, uint256 totalMint) external {
        _mint(mintAddress, totalMint);
    }
}
